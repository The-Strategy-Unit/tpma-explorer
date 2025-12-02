#' Read Inputs Datasets for All Geographies
#' @param inputs_container A blob_container/storage_container list. The
#'     object containing the connection to the Azure container hosting the
#'     datasets named by `data_types`.
#' @param geographies Character. The geography level for which the user wants to
#'     select a provider.
#' @param data_types Character. A vector of filenames (without filetypes) for
#'     each of the inputs data files that you want to read from
#'     the `inputs_container`.
#' @return A list. One element for each of the `geographies`, with subelements
#'     that are dataframes of each one of the `data_types`.
#' @export
get_all_geo_data <- function(inputs_container, geographies, data_types) {
  purrr::map(
    geographies,
    \(geography) {
      purrr::map(
        data_types,
        \(data_type) {
          container_dir <- if (geography == "la") {
            "local_authorities"
          } else {
            Sys.getenv("DATA_VERSION")
          }
          col_renames <- c(provider = "resladst_ons")
          azkit::read_azure_parquet(
            inputs_container,
            data_type,
            container_dir
          ) |>
            dplyr::rename(dplyr::any_of(col_renames)) # standardise
        }
      ) |>
        purrr::set_names(data_types)
    }
  ) |>
    purrr::set_names(geographies)
}
