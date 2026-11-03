#' Select Provider UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_select_provider_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::selectInput(
    ns("provider_select"),
    label = shiny::div(
      class = "mb-2",
      bslib::tooltip(
        trigger = list(
          shiny::textOutput(ns("choose_org_text"), inline = TRUE),
          bsicons::bs_icon("info-circle")
        ),
        shiny::div(
          style = "text-align: left;",
          md_file_to_html("app", "text", "sidebar-tooltip-provider.md")
        )
      )
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
        "la" = "la-datasets.json",
        "nhp" = "nhp-datasets.json",
        "icb" = "icb-datasets.json"
      )

      shiny::req(filename)

      yyjsonr::read_json_file(app_sys("app", "reference", filename))
    }) |>
      shiny::bindEvent(selected_geography())

    shiny::observe({
      providers <- shiny::req(providers())
      geography <- shiny::req(selected_geography())

      provider_choices <- purrr::set_names(names(providers), providers)

      # Restore strategy value from bookmark, otherwise NULL
      restored_value <- shiny::restoreInput(
        id = session$ns("provider_select"),
        default = NULL
      )

      # To help check if the restored value is valid
      valid_values <- unname(provider_choices)

      selected_value <- if (!is.null(restored_value) && restored_value %in% valid_values) {
        restored_value
      } else {
        # Set a sensible default if not restored from a bookmark
        if (geography == "la") {
          "E08000025" # Birmingham
        } else if (geography == "nhp") {
          "RRK" # University Hospitals Birmingham NHS Foundation Trust
        }
      }

      shiny::updateSelectInput(
        session,
        "provider_select",
        choices = provider_choices,
        selected = selected_value
      )
    })

    output$choose_org_text <- shiny::renderText({
      unit <- switch(
        selected_geography(),
        "la" = "a local authority",
        "nhp" = "a provider trust",
        "icb" = "an ICB"
      )

      glue::glue("Select {unit}:")
    })

    shiny::reactive(input$provider_select)
  })
}
