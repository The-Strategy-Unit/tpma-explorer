#' Prepare Data for Procedures Table
#' @param procedures_lookup A data.frame. Type, code and description for
#'     procedures.
#' @param geography Character. Geography type, either `"nhp"` or `"la"`.
#' @param provider Character. Provider code, e.g. `"RCF"`.
#' @param strategy Character. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @param selected_year Integer. Baseline year in the form `202324`.
#' @return A data.frame.
#' @export
prepare_procedures_data <- function(
  procedures_lookup,
  geography,
  provider,
  strategy,
  selected_year
) {
  geography <- switch(geography, "nhp" = "provider", "la" = "lad23cd")

  filename <- app_sys("app", "data", geography, "procedures.parquet")

  procedures_filtered <- arrow::open_dataset(filename) |>
    dplyr::filter(
      .data$provider == .env$provider,
      .data$strategy == .env$strategy,
      .data$fyear == .env$selected_year
    ) |>
    dplyr::select("procedure_code", "n", "total", "pcnt", "rn") |>
    dplyr::collect()

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
#' @param diagnoses_lookup A data.frame. Type, code and description for
#'     diagnoses
#' @param geography Character. Geography type, either `"nhp"` or `"la"`.
#' @param provider Character. Provider code, e.g. `"RCF"`.
#' @param strategy Character. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @param selected_year Integer. Baseline year in the form `202324`.
#' @return A data.frame.
#' @export
prepare_diagnoses_data <- function(
  diagnoses_lookup,
  geography,
  provider,
  strategy,
  selected_year
) {
  geography <- switch(geography, "nhp" = "provider", "la" = "lad23cd")

  filename <- app_sys("app", "data", geography, "diagnoses.parquet")

  diagnoses_filtered <- arrow::open_dataset(filename) |>
    dplyr::filter(
      .data$provider == .env$provider,
      .data$strategy == .env$strategy,
      .data$fyear == .env$selected_year
    ) |>
    dplyr::select("diagnosis", "n", "total", "pcnt", "rn") |>
    dplyr::collect()

  if (nrow(diagnoses_filtered) == 0) {
    return(NULL)
  }

  diagnoses_prepared <- diagnoses_filtered |>
    dplyr::left_join(
      diagnoses_lookup,
      by = c("diagnosis" = "diagnosis_code")
    ) |>
    tidyr::replace_na(list(
      diagnosis_description = "Unknown/Invalid Diagnosis Code"
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
