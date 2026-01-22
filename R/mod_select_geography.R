#' Select Geography UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_select_geography_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::selectInput(
    ns("geography_select"),
    "Filter by geography:",
    choices = NULL
  )
}

#' Select Geography Server
#' @param id Internal parameter for `shiny`.
#' @param geographies Character. The geography level for which the user wants to
#'     select a provider.
#' @noRd
mod_select_geography_server <- function(id, geographies) {
  shiny::moduleServer(id, function(input, output, session) {
    shiny::observe({
      shiny::req(geographies)
      shiny::updateSelectInput(
        session,
        "geography_select",
        choices = geographies
      )
    })
    shiny::reactive(input$geography_select)
  })
}
