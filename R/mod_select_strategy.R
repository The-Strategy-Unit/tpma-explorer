#' Select Strategy UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_select_strategy_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::selectInput(
    ns("strategy_select"),
    "Choose a strategy:",
    choices = NULL
  )
}

#' Select Strategy Server
#' @param id Internal parameter for `shiny`.
#' @param strategies A named list. Names are strategy variable names (e.g.
#'     `"alcohol_partially_attributable_acute"`) and their values are the
#'     corresponding human-readable names and codes (e.g.
#'     `"Alcohol Related Admissions (Acute Conditions - Partially Attributable)
#'     (IP-AA-001)"`).
#' @noRd
mod_select_strategy_server <- function(id, strategies) {
  shiny::moduleServer(id, function(input, output, session) {
    shiny::observe({
      strategy_choices <- purrr::set_names(names(strategies), strategies)
      shiny::updateSelectInput(
        session,
        "strategy_select",
        choices = strategy_choices
      )
    })
    shiny::reactive(input$strategy_select)
  })
}
