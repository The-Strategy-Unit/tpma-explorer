#' Select Geography UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_select_geography_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::selectInput(
    ns("geography_select"),
    label = bslib::tooltip(
      trigger = list(
        "Filter by geography",
        bsicons::bs_icon("info-circle")
      ),
      md_file_to_html("app", "text", "sidebar-tooltip-selections.md"),
    ),
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
