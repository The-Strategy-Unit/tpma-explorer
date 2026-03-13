#' Select Strategy UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_select_strategy_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::selectInput(
      ns("strategy_care_shift_select"),
      label = bslib::tooltip(
        trigger = list(
          "Choose a care-shift category",
          bsicons::bs_icon("info-circle")
        ),
        md_file_to_html("app", "text", "sidebar-tooltip-selections.md"),
      ),
      choices = NULL
    ),
    shiny::selectInput(
      ns("strategy_activity_type_select"),
      label = bslib::tooltip(
        trigger = list(
          "Filter by activity type",
          bsicons::bs_icon("info-circle")
        ),
        md_file_to_html("app", "text", "sidebar-tooltip-selections.md"),
      ),
      choices = c(
        "Inpatients" = "ip",
        "Outpatients" = "op",
        "Accident & Emergency" = "ae"
      )
    ),
    shiny::selectInput(
      ns("strategy_select"),
      label = bslib::tooltip(
        trigger = list("Choose a TPMA", bsicons::bs_icon("info-circle")),
        md_file_to_html("app", "text", "sidebar-tooltip-selections.md"),
      ),
      choices = NULL
    )
  )
}

#' Get TPMAs for the drop down menu
#'
#' Reads the mitigators.json file and extracts the name and category (IP/OP/AE).
#'
#' @return A named list of data frames, where the names are the categories (IP/OP/AE)
#' @noRd
mod_select_strategy_get_strategies <- function() {
  strategies <- app_sys("app", "data", "mitigators.json") |>
    yyjsonr::read_json_file()

  strategies |>
    unlist() |>
    tibble::enframe("strategy", "name") |>
    dplyr::mutate(
      category = stringr::str_extract(
        .data$name,
        "(?<= \\()(IP|OP|AE)(?=-(AA|EF))" # e.g. 'IP' in 'IP-AA-001'
      ) |>
        stringr::str_to_lower()
    ) |>
    dplyr::nest_by(.data$category) |>
    tibble::deframe()
}

#' Select Strategy Server
#' @param id Internal parameter for `shiny`.
#' @noRd
mod_select_strategy_server <- function(id) {
  # load static data items
  strategies <- mod_select_strategy_get_strategies()

  # return the shiny module
  shiny::moduleServer(id, function(input, output, session) {
    selected_activity_type <- shiny::reactive({
      shiny::req(input$strategy_activity_type_select)
      input$strategy_activity_type_select
    })

    shiny::observe({
      category <- shiny::req(selected_activity_type())

      strategy_choices <- strategies[[category]] |>
        dplyr::select("name", "strategy") |>
        tibble::deframe()

      shiny::updateSelectInput(
        session,
        "strategy_select",
        choices = strategy_choices
      )
    })

    shiny::onRestored(function(state) {
      # Enforce loading of selection when restoring from a bookmark
      shiny::updateSelectInput(
        session,
        "strategy_select",
        selected = state$input$strategy_select
      )
    })

    shiny::reactive(input$strategy_select)
  })
}
