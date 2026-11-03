#' Download Inputs Datasets for Specific Geography
#' @param geography_folder Character. The geography level of the data to
#'     download. Either "provider", "lad23cd" or "icb".
#' @param data_version Character. The version of the data to download. By
#'     default, uses the value of the "DATA_VERSION" environment variable, or
#'     "dev" if that variable is not set.
#' @param redownload Logical. Whether to redownload the data if it already
#'     exists. By default, FALSE.
#' @export
download_geo_data <- function(
  geography_folder,
  data_version = Sys.getenv("DATA_VERSION", "dev"),
  redownload = FALSE
) {
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


`_download_geo_data` <- function(
  geography_folder,
  data_path,
  data_version = Sys.getenv("DATA_VERSION", "dev")
) {
  container_dir <- file.path(data_version, geography_folder)

  inputs_container <- azkit::get_container(
    container_name = Sys.getenv("AZ_CONTAINER_INPUTS")
  )

  c(
    "age_sex",
    "diagnoses",
    "procedures",
    "rates"
  ) |>
    purrr::set_names() |>
    purrr::walk(
      `_download_geo_data_file`,
      data_path,
      inputs_container,
      container_dir
    )

  invisible(NULL)
}


`_download_geo_data_file` <- function(
  data_type,
  data_path,
  inputs_container,
  container_dir
) {
  file_name <- file.path(
    data_path,
    paste0(data_type, ".parquet")
  )

  col_renames <- c(provider = "lad23cd", provider = "icb")

  azkit::read_azure_parquet(
    inputs_container,
    glue::glue("{container_dir}/{data_type}.parquet")
  ) |>
    dplyr::rename(dplyr::any_of(col_renames)) |>
    tidyr::drop_na("strategy") |>
    arrow::write_parquet(file_name)

  file_name
}

#' Download Inputs Datasets for Specific Geography
#'
#' Downloads all datasets for "provider", "lad23cd" and "icb" geographies. See
#' `download_geo_data()` for more details.
#'
#' @param data_version Character. The version of the data to download. By
#'    default, uses the value of the "DATA_VERSION" environment variable, or
#'   "dev" if that variable is not set.
#' @param redownload Logical. Whether to redownload the data if it already
#'    exists. By default, FALSE.
#'
#' @export
download_all_data <- function(
  data_version = Sys.getenv("DATA_VERSION", "dev"),
  redownload = FALSE
) {
  purrr::map(
    c("provider", "lad23cd", "icb"),
    download_geo_data,
    data_version = data_version,
    redownload = redownload
  )

  invisible(NULL)
}
