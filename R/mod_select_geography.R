#' Select Geography UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_select_geography_ui <- function(id) {
  ns <- shiny::NS(id)

  shiny::radioButtons(
    ns("geography_select"),
    label = shiny::div(
      class = "mb-2",
      bslib::tooltip(
        trigger = list(
          "Explore data for:",
          bsicons::bs_icon("info-circle")
        ),
        shiny::div(
          style = "text-align: left;",
          md_file_to_html("app", "text", "sidebar-tooltip-geography.md")
        )
      )
    ),
    choices = c(
      "Local Authorities (LAs)" = "la",
      "NHS provider trusts" = "nhp",
      "Integrated Care Boards (ICBs)" = "icb"
    ),
    selected = "la" # default provider will be "E08000025" (Birmingham)
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
