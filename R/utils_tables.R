#' Prepare Data for Procedures Table
#' @param procedures A data.frame. Annual procedure counts by provider and
#'     strategy.
#' @param procedures_lookup A data.frame. Type, code and description for
#'     procedures.
#' @param provider Character. Provider code, e.g. `"RCF"`.
#' @param strategy Character. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @param start_year Integer. Baseline year in the form `202324`.
#' @return A data.frame.
#' @export
prepare_procedures_data <- function(
  procedures,
  procedures_lookup,
  provider,
  strategy,
  start_year
) {
  procedures_prepared <- procedures |>
    dplyr::filter(
      .data$provider == .env$provider,
      .data$strategy == .env$strategy,
      .data$fyear == .env$start_year
    ) |>
    dplyr::left_join(procedures_lookup, by = c("procedure_code" = "code")) |>
    tidyr::replace_na(list(
      description = "Unknown/Invalid Procedure Code"
    )) |>
    dplyr::select("procedure_description" = "description", "n", "pcnt")

  n_total <- sum(procedures_prepared[["n"]])
  pcnt_total <- sum(procedures_prepared[["pcnt"]])

  # if we need to include an 'other' row
  if (pcnt_total < 1) {
    procedures_prepared <- dplyr::bind_rows(
      procedures_prepared,
      tibble::tibble(
        procedure_description = "Other",
        n = n_total * (1 - pcnt_total) / pcnt_total,
        pcnt = 1 - pcnt_total
      )
    )
  }

  procedures_prepared
}
