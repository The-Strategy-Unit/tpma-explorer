#' Select Provider UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_select_provider_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::selectInput(
    ns("provider_select"),
    "Choose a provider:",
    choices = NULL
  )
}

#' Select Provider Server
#' @param id Internal parameter for `shiny`.
#' @param providers A named list. Names are provider codes (e.g. `"RCF"`) and
#'     their values are the corresponding human-readable names and codes (e.g.
#'     `"Airedale NHS Foundation Trust (RCF)"`).
#' @noRd
mod_select_provider_server <- function(id, providers) {
  shiny::moduleServer(id, function(input, output, session) {
    shiny::observe({
      provider_choices <- purrr::set_names(names(providers), providers)
      shiny::updateSelectInput(
        session,
        "provider_select",
        choices = provider_choices
      )
    })
    shiny::reactive(input$provider_select)
  })
}
