#' Create 'gt' Summary Table of Procedures or Diagnoses
#' @param encounters_prepared A data.frame. Procedures or diagnoses
#'     ('encounters') data read from Azure and processed with
#'     [prepare_procedures_data] or [prepare_diagnoses_data].
#' @return A 'gt' table.
#' @export
entable_encounters <- function(encounters_prepared) {
  encounter_description <- names(encounters_prepared)[1]
  encounter_type <- stringr::str_remove(encounter_description, "_description")
  encounter_type_title <- stringr::str_to_title(encounter_type)

  encounters_prepared |>
    gt::gt(encounter_description) |>
    gt::cols_label(
      !!rlang::sym(encounter_description) := encounter_type_title,
      "n" = "Count of Activity (spells)",
      "pcnt" = "% of Total Activity"
    ) |>
    gt::tab_stubhead(encounter_type_title) |>
    gt::fmt_number(
      columns = "n",
      decimals = 0,
      use_seps = TRUE
    ) |>
    gt::fmt_percent(
      columns = "pcnt",
      decimals = 1
    ) |>
    gt::sub_missing(
      columns = c("n", "pcnt"),
      missing_text = "Suppressed"
    ) |>
    gt::grand_summary_rows(
      columns = "n",
      fns = list(Total = ~ sum(.)),
      fmt = list(
        ~ gt::fmt_number(., decimals = 0, use_seps = TRUE)
      )
    ) |>
    gt::tab_style(
      style = list(
        gt::cell_fill(color = "#EFEFEF"),
        gt::cell_text(weight = "bold")
      ),
      locations = list(
        gt::cells_column_labels(),
        gt::cells_stubhead(),
        gt::cells_grand_summary(),
        gt::cells_stub_grand_summary()
      )
    ) |>
    gt::tab_style(
      style = list(
        gt::cell_fill(color = "#FBFBFB"),
        gt::cell_text(weight = "bold")
      ),
      locations = list(
        gt::cells_body(
          rows = .data[[encounter_description]] == "Other"
        ),
        gt::cells_stub(
          rows = .data[[encounter_description]] == "Other"
        )
      )
    )
}
