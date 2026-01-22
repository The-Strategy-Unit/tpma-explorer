#' Procedures Table UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_table_diagnoses_ui <- function(id) {
  ns <- shiny::NS(id)
  bslib::card(
    bslib::card_header(
      "Diagnoses summary",
      bslib::tooltip(
        bsicons::bs_icon("question-circle"),
        md_file_to_html("app", "text", "card-info-diagnoses.md"),
        placement = "right"
      )
    ),
    bslib::card_body(
      shinycssloaders::withSpinner(
        gt::gt_output(ns("diagnoses_table"))
      )
    ),
    fill = FALSE,
    full_screen = TRUE
  )
}

#' Diagnoses Table Server
#' @param id Internal parameter for `shiny`.
#' @param diagnoses_data A data.frame. Diagnosis data read in from Azure. Annual
#'     diagnosis counts by provider and strategy.
#' @param diagnosis_lookup A data.frame. Type, code and description for
#'     diagnoses.
#' @param selected_provider Character. Provider code, e.g. `"RCF"`.
#' @param selected_strategy Character. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @param baseline_year Integer. Baseline year in the form `202324`.
#' @noRd
mod_table_diagnoses_server <- function(
  id,
  diagnoses_data,
  diagnoses_lookup,
  selected_provider,
  selected_strategy,
  baseline_year
) {
  shiny::moduleServer(id, function(input, output, session) {
    diagnoses_prepared <- shiny::reactive({
      shiny::req(diagnoses_data())
      shiny::req(selected_provider())
      shiny::req(selected_strategy())
      shiny::req(baseline_year)

      prepare_diagnoses_data(
        diagnoses_data(),
        diagnoses_lookup,
        selected_provider(),
        selected_strategy(),
        baseline_year
      )
    })

    output$diagnoses_table <- gt::render_gt({
      shiny::validate(
        shiny::need(
          !is.null(diagnoses_prepared()) && nrow(diagnoses_prepared()) > 0,
          "No diagnoses to display."
        )
      )
      diagnoses_prepared() |> entable_encounters()
    })
  })
}
