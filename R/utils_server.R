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


#' Download Inputs Datasets for Specific Geography
#' @param geography_folder Character. The geography level of the data to
#'     download. Either "provider" or "lad23cd".
#' @param data_version Character. The version of the data to download. By
#'     default, uses the value of the "DATA_VERSION" environment variable, or
#'     "dev" if that variable is not set.
#' @param redownload Logical. Whether to redownload the data if it already
#'     exists. By default, FALSE.
#' @export
download_geo_data <- function(geography_folder, data_version = Sys.getenv("DATA_VERSION", "dev"), redownload = FALSE) {
  data_path <- file.path("app_data", geography_folder)

  if (fs::dir_exists(data_path)) {
    if (!redownload) {
      return(invisible(NULL))
    }
  } else {
    fs::dir_create(data_path, recurse = TRUE)
  }

  `_download_geo_data`(geography_folder, data_path, data_version)
}

# nolint start
`_download_geo_data` <- function(
  # nolint end
  geography_folder,
  data_path,
  data_version = Sys.getenv("DATA_VERSION", "dev")
) {
  container_dir <- file.path(data_version, geography_folder)

  inputs_container <- get_container()

  c(
    "age_sex",
    "diagnoses",
    "procedures",
    "rates"
  ) |>
    purrr::set_names() |>
    purrr::walk(`_download_geo_data_file`, data_path, inputs_container, container_dir)

  invisible(NULL)
}

# nolint start
`_download_geo_data_file` <- function(
  # nolint end
  data_type,
  data_path,
  inputs_container,
  container_dir
) {
  file_name <- file.path(
    data_path,
    paste0(data_type, ".parquet")
  )

  col_renames <- c(provider = "lad23cd")

  azkit::read_azure_parquet(
    inputs_container,
    data_type,
    container_dir
  ) |>
    dplyr::rename(dplyr::any_of(col_renames)) |>
    tidyr::drop_na("strategy") |>
    arrow::write_parquet(file_name)

  file_name
}

#' Download Inputs Datasets for Specific Geography
#'
#' Downloads all datasets for both "provider" and "lad23cd" geographies. See
#' `download_geo_data()` for more details.
#'
#' @param data_version Character. The version of the data to download. By
#'    default, uses the value of the "DATA_VERSION" environment variable, or
#'   "dev" if that variable is not set.
#' @param redownload Logical. Whether to redownload the data if it already
#'    exists. By default, FALSE.
#'
#' @export
download_all_data <- function(data_version = Sys.getenv("DATA_VERSION", "dev"), redownload = FALSE) {
  purrr::map(
    c("provider", "lad23cd"),
    download_geo_data,
    data_version = data_version,
    redownload = redownload
  )

  invisible(NULL)
}
