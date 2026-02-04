#' Read Inputs Datasets for All Geographies
#' @param geography Character. The geography level for which the user wants to
#'     select a provider. Either "nhp" or "la".
#' @return A list. One element for each dataframes of data.
#' @export
get_all_geo_data <- function(geography) {
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

  purrr::map(
    data_types,
    \(data_type) {
      azkit::read_azure_parquet(
        inputs_container,
        data_type,
        container_dir
      ) |>
        dplyr::rename(dplyr::any_of(col_renames)) # standardise
    }
  )
}
