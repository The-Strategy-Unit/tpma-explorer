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
#' @noRd
mod_select_provider_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    shiny::observe({
      providers <- jsonlite::read_json(
        app_sys("app", "data", "datasets.json"),
        simplify_vector = TRUE
      )
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
