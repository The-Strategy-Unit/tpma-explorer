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
#' @noRd
mod_select_strategy_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    shiny::observe({
      strategies <- jsonlite::read_json(
        app_sys("app", "data", "mitigators.json"),
        simplify_vector = TRUE
      )
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
