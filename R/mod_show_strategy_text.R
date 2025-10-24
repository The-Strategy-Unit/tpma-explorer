#' Show Strategy Description UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_show_strategy_text_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::htmlOutput(ns("strategy_text"))
}

#' Show Strategy Description Server
#' @param id Internal parameter for `shiny`.
#' @noRd
mod_show_strategy_text_server <- function(
  id,
  descriptions_lookup,
  selected_strategy
) {
  shiny::moduleServer(id, function(input, output, session) {
    output$strategy_text <- shiny::renderText({
      shiny::req(selected_strategy())
      shiny::req(descriptions_lookup)
      selected_strategy() |>
        fetch_strategy_text(descriptions_lookup) |>
        convert_md_to_html()
    })
  })
}
