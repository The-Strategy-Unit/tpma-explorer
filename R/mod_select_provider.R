#' Select Provider UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_select_provider_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::selectInput(
    ns("provider_select"),
    label = bslib::tooltip(
      trigger = list(
        "Choose a statistical unit",
        bsicons::bs_icon("info-circle")
      ),
      md_file_to_html("app", "text", "sidebar-selections.md"),
    ),
    choices = NULL
  )
}

#' Select Provider Server
#' @param id Internal parameter for `shiny`.
#' @param selected_geography Reactive. Selected geography, either `"nhp"` or
#'       `"la"`.
#' @noRd
mod_select_provider_server <- function(id, selected_geography) {
  shiny::moduleServer(id, function(input, output, session) {
    providers <- shiny::reactive({
      filename <- switch(
        selected_geography(),
        "nhp" = "nhp-datasets.json",
        "la" = "la-datasets.json"
      )

      shiny::req(filename)

      jsonlite::read_json(
        app_sys("app", "data", filename),
        simplify_vector = TRUE
      )
    }) |>
      shiny::bindEvent(selected_geography())

    shiny::observe({
      providers <- shiny::req(providers())
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
