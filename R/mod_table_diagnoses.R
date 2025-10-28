#' Procedures Table UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_table_diagnoses_ui <- function(id) {
  ns <- shiny::NS(id)
  bslib::card(
    bslib::card_header("Diagnoses summary"),
    bslib::card_body(gt::gt_output(ns("diagnoses_table"))),
    fill = FALSE,
    full_screen = TRUE
  )
}

#' Diagnoses Table Server
#' @param id Internal parameter for `shiny`.
#' @param diagnoses A data.frame. Annual diagnosis counts by provider and
#'     strategy.
#' @param diagnosis_lookup A data.frame. Type, code and description for
#'     diagnoses.
#' @param selected_provider Character. Provider code, e.g. `"RCF"`.
#' @param selected_strategy Character. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @param start_year Integer. Baseline year in the form `202324`.
#' @noRd
mod_table_diagnoses_server <- function(
  id,
  diagnoses,
  diagnoses_lookup,
  selected_provider,
  selected_strategy,
  start_year
) {
  shiny::moduleServer(id, function(input, output, session) {
    shiny::validate(
      shiny::need(
        diagnoses,
        message = "Insufficient or suppressed data."
      )
    )

    output$diagnoses_table <- gt::render_gt({
      shiny::validate(
        shiny::need(
          !is.null(diagnoses) && nrow(diagnoses) > 0,
          "No diagnoses to display."
        )
      )

      diagnoses_prepared <- shiny::reactive({
        shiny::req(diagnoses)
        shiny::req(selected_provider())
        shiny::req(selected_strategy())
        shiny::req(start_year)

        prepare_diagnoses_data(
          diagnoses,
          diagnoses_lookup,
          selected_provider(),
          selected_strategy(),
          start_year
        )
      })

      shiny::validate(
        shiny::need(
          !is.null(diagnoses_prepared()) && nrow(diagnoses_prepared()) > 0,
          "No diagnoses to display."
        )
      )

      entable_diagnoses(diagnoses_prepared())
    })
  })
}
