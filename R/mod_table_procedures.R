#' Procedures Table UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_table_procedures_ui <- function(id) {
  ns <- shiny::NS(id)
  bslib::card(
    bslib::card_header("Procedures summary"),
    bslib::card_body(gt::gt_output(ns("procedures_table"))),
    fill = FALSE,
    full_screen = TRUE
  )
}

#' Procedures Table Server
#' @param id Internal parameter for `shiny`.
#' @param procedures A data.frame. Annual procedure counts by provider and
#'     strategy.
#' @param procedures_lookup A data.frame. Type, code and description for
#'     procedures.
#' @param selected_provider Character. Provider code, e.g. `"RCF"`.
#' @param selected_strategy Character. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @param start_year Integer. Baseline year in the form `202324`.
#' @noRd
mod_table_procedures_server <- function(
  id,
  procedures,
  procedures_lookup,
  selected_provider,
  selected_strategy,
  start_year
) {
  shiny::moduleServer(id, function(input, output, session) {
    procedures_prepared <- shiny::reactive({
      shiny::req(procedures)
      shiny::req(selected_provider())
      shiny::req(selected_strategy())
      shiny::req(start_year)

      prepare_procedures_data(
        procedures,
        procedures_lookup,
        selected_provider(),
        selected_strategy(),
        start_year
      )
    })

    output$procedures_table <- gt::render_gt({
      shiny::validate(
        shiny::need(
          !is.null(procedures_prepared()) && nrow(procedures_prepared()) > 0,
          "No procedures to display."
        )
      )
      procedures_prepared() |> entable_encounters()
    })
  })
}
