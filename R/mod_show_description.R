#' Show Descriptions UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_show_description_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::htmlOutput(ns("strategy_description"))
}

#' Show Descriptions Server
#' @param id Internal parameter for `shiny`.
#' @noRd
mod_show_description_server <- function(
  id,
  descriptions_lookup,
  selected_strategy
) {
  shiny::moduleServer(id, function(input, output, session) {
    output$strategy_description <- shiny::renderText({
      shiny::req(selected_strategy())
      selected_strategy() |>
        fetch_strategy_description(descriptions_lookup) |>
        convert_md_to_html()
    })
  })
}
