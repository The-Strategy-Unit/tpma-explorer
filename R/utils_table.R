#' Prepare Data for Procedures Table
#' @param procedures_data A data.frame. Procedure data read in from Azure.
#'     Annual procedure counts by provider and strategy.
#' @param procedures_lookup A data.frame. Type, code and description for
#'     procedures.
#' @param provider Character. Provider code, e.g. `"RCF"`.
#' @param strategy Character. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @param baseline_year Integer. Baseline year in the form `202324`.
#' @return A data.frame.
#' @export
prepare_procedures_data <- function(
  procedures_data,
  procedures_lookup,
  provider,
  strategy,
  baseline_year
) {
  procedures_filtered <- procedures_data |>
    dplyr::filter(
      .data$provider == .env$provider,
      .data$strategy == .env$strategy,
      .data$fyear == .env$baseline_year
    )
  if (nrow(procedures_filtered) == 0) {
    return(NULL)
  }

  procedures_prepared <- procedures_filtered |>
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

#' Prepare Data for Diagnoses Table
#' @param diagnoses_data A data.frame. Diagnosis data read in from Azure. Annual
#'     diagnosis counts by provider and strategy.
#' @param diagnoses_lookup A data.frame. Type, code and description for
#'     diagnoses
#' @param provider Character. Provider code, e.g. `"RCF"`.
#' @param strategy Character. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @param baseline_year Integer. Baseline year in the form `202324`.
#' @return A data.frame.
#' @export
prepare_diagnoses_data <- function(
  diagnoses_data,
  diagnoses_lookup,
  provider,
  strategy,
  baseline_year
) {
  diagnoses_filtered <- diagnoses_data |>
    dplyr::filter(
      .data$provider == .env$provider,
      .data$strategy == .env$strategy,
      .data$fyear == .env$baseline_year
    )
  if (nrow(diagnoses_filtered) == 0) {
    return(NULL)
  }

  diagnoses_prepared <- diagnoses_filtered |>
    dplyr::inner_join(
      diagnoses_lookup,
      by = c("diagnosis" = "diagnosis_code")
    ) |>
    tidyr::replace_na(list(
      description = "Unknown/Invalid Diagnosis Code"
    )) |>
    dplyr::select("diagnosis_description", "n", "pcnt")

  n_total <- sum(diagnoses_prepared[["n"]])
  pcnt_total <- sum(diagnoses_prepared[["pcnt"]])

  # if we need to include an 'other' row
  if (pcnt_total < 1) {
    diagnoses_prepared <- dplyr::bind_rows(
      diagnoses_prepared,
      tibble::tibble(
        diagnosis_description = "Other",
        n = n_total * (1 - pcnt_total) / pcnt_total,
        pcnt = 1 - pcnt_total
      )
    )
  }

  diagnoses_prepared
}
