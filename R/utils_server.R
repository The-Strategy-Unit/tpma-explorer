#' Get Azure Container
#' @param ep_uri Character. Endpoint URI.
#' @param container_name Character. The name of the blob/storage container that
#'     hosts files you want to read.
#' @return A blob_container/storage_container list.
#' @export
get_container <- function(
  ep_uri = Sys.getenv("AZ_STORAGE_EP"),
  container_name = Sys.getenv("AZ_CONTAINER_INPUTS")
) {
  # if the app_id variable is empty, we assume that this is running on an Azure
  # VM, and then we will use Managed Identities for authentication.

  token <- tryCatch(
    {
      AzureAuth::get_managed_token("https://storage.azure.com/")
    },
    error = function(...) {
      AzureAuth::get_azure_token(
        resource = "https://storage.azure.com",
        tenant = "common",
        app = "04b07795-8ddb-461a-bbee-02f9e1bf7b46",
        use_cache = TRUE # avoid browser-authorisation prompt
      )
    }
  )
  ep_uri |>
    AzureStor::blob_endpoint(token = token) |>
    AzureStor::storage_container(container_name)
}

#' Read Inputs Datasets for All Geographies
#' @param geography Character. The geography level for which the user wants to
#'     select a provider. Either "nhp" or "la".
#' @param fyear Numeric. The financial year to filter the data to.
#' @return A list. One element for each dataframes of data.
#' @export
get_all_geo_data <- function(geography, fyear) {
  inputs_container <- get_container()

  data_types <- purrr::set_names(c(
    "age_sex",
    "diagnoses",
    "procedures",
    "rates"
  ))

  geography_folder <- switch(
    geography,
    "nhp" = "provider",
    "la" = "lad23cd"
  )

  stopifnot(
    "Unknown geography" = !is.null(geography_folder)
  )

  container_dir <- file.path(
    Sys.getenv("DATA_VERSION"),
    geography_folder
  )

  col_renames <- c(provider = "lad23cd")

  data_types |>
    purrr::map(
      \(data_type) {
        azkit::read_azure_parquet(
          inputs_container,
          data_type,
          container_dir
        ) |>
          dplyr::rename(dplyr::any_of(col_renames)) # standardise
      }
    ) |>
    purrr::modify_at(
      data_types[data_types != "rates"],
      dplyr::filter,
      .data[["fyear"]] == .env[["fyear"]]
    )
}


#' Download Inputs Datasets for Specific Geography
#' @param geography Character. The geography level for which the user wants to
#'     select a provider. Either "nhp" or "la".
#' @return A list. The filenames of the downloaded datasets.
#' @export
download_geo_data <- function(geography) {
  inputs_container <- get_container()

  data_types <- purrr::set_names(c(
    "age_sex",
    "diagnoses",
    "procedures",
    "rates"
  ))

  geography_folder <- switch(
    geography,
    "nhp" = "provider",
    "la" = "lad23cd"
  )

  stopifnot(
    "Unknown geography" = !is.null(geography_folder)
  )

  data_path <- file.path(app_sys("app"), "data", geography_folder)

  if (!dir.exists(data_path)) {
    dir.create(data_path, recursive = TRUE)
  }

  container_dir <- file.path(
    Sys.getenv("DATA_VERSION", "dev"),
    geography_folder
  )

  col_renames <- c(provider = "lad23cd")

  data_types |>
    purrr::map(
      \(data_type) {
        file_name <- file.path(
          data_path,
          paste0(data_type, ".parquet")
        )

        azkit::read_azure_parquet(
          inputs_container,
          data_type,
          container_dir
        ) |>
          dplyr::rename(dplyr::any_of(col_renames)) |>
          dplyr::arrange(
            dplyr::across(
              c(
                "fyear",
                "strategy",
                "provider",
                tidyselect::any_of(c("sex", "age_group"))
              )
            )
          ) |>
          tidyr::drop_na("strategy") |>
          arrow::write_parquet(file_name)

        file_name
      }
    )
}

#' Download Inputs Datasets for Specific Geography
#' @export
download_all_data <- function() {
  if (!dir.exists(app_sys("app", "data"))) {
    c("nhp", "la") |>
      purrr::set_names() |>
      purrr::map(download_geo_data)
  }

  invisible(NULL)
}
