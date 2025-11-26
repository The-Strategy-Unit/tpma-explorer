#' Select Provider UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_select_provider_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::selectInput(
      ns("geography_select"),
      "Choose a geography:",
      choices = NULL
    ),
    shiny::selectInput(
      ns("provider_select"),
      "Choose a provider:",
      choices = NULL
    )
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
mod_select_provider_server <- function(id, geographies, providers) {
  shiny::moduleServer(id, function(input, output, session) {
    shiny::observe({
      shiny::req(geographies)
      shiny::updateSelectInput(
        session,
        "geography_select",
        choices = geographies
      )
    })
    selected_geography <- shiny::reactive(input$geography_select)

    shiny::observe({
      shiny::req(selected_geography())
      shiny::req(providers)
      if (selected_geography() == "NHP schemes") {
        provider_choices <- purrr::set_names(names(providers), providers)
        shiny::updateSelectInput(
          session,
          "provider_select",
          label = "Choose an NHP scheme:",
          choices = provider_choices
        )
      }
    })
    shiny::reactive(input$provider_select)
  })
}
