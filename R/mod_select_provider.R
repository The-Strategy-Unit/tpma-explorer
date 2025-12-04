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
#' @param geographies Character. The geography level for which the user wants to
#'     select a provider.
#' @param providers A named list. Names are provider codes (e.g. `"RCF"`) and
#'     their values are the corresponding human-readable names and codes (e.g.
#'     `"Airedale NHS Foundation Trust (RCF)"`).
#' @noRd
mod_select_provider_server <- function(id, selected_geography, providers) {
  shiny::moduleServer(id, function(input, output, session) {
    shiny::observe({
      shiny::req(selected_geography())
      shiny::req(providers())

      provider_choices <- purrr::set_names(names(providers()), providers())

      provider_label <- switch(
        selected_geography(),
        "nhp" = "Choose an NHP scheme:",
        "la" = "Choose a local authority:"
      )

      shiny::updateSelectInput(
        session,
        "provider_select",
        label = provider_label,
        choices = provider_choices
      )
    })

    shiny::reactive(input$provider_select)
  })
}
