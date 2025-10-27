#' Create 'gt' Summary Table of Procedures
#' @param procedures_prepared A data.frame.
#' @return A 'gt' table.
#' @export
entable_procedures <- function(procedures_prepared) {
  procedures_prepared |>
    gt::gt("procedure_description") |>
    gt::cols_label(
      "procedure_description" = "Procedure",
      "n" = "Count of Activity (spells)",
      "pcnt" = "% of Total Activity"
    ) |>
    gt::tab_stubhead("Procedure") |>
    gt::fmt_number(
      c("n"),
      decimals = 0,
      use_seps = TRUE
    ) |>
    gt::fmt_percent(
      c("pcnt"),
      decimals = 1
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
          rows = .data[["procedure_description"]] == "Other"
        ),
        gt::cells_stub(
          rows = .data[["procedure_description"]] == "Other"
        )
      )
    )
}
