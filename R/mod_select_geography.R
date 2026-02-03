#' Select Geography UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_select_geography_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::selectInput(
    ns("geography_select"),
    "Filter by geography:",
    choices = c(
      "NHS provider trusts" = "nhp",
      "Local authorities (LAs)" = "la"
    )
  )
}

#' Select Geography Server
#' @param id Internal parameter for `shiny`.
#' @noRd
mod_select_geography_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    shiny::reactive(input$geography_select)
  })
}
