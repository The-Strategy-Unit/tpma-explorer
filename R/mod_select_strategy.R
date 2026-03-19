#' Select Strategy UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_select_strategy_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::checkboxInput(
      ns("strategy_care_shift_checkbox"),
      label = bslib::tooltip(
        trigger = list(
          "Filter for care-shift TPMAs",
          bsicons::bs_icon("info-circle")
        ),
        md_file_to_html("app", "text", "sidebar-tooltip-selections.md"),
      ),
      value = FALSE
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
      ns("strategy_category_select"),
      label = bslib::tooltip(
        trigger = list(
          "Filter by TPMA category",
          bsicons::bs_icon("info-circle")
        ),
        md_file_to_html("app", "text", "sidebar-tooltip-selections.md"),
      ),
      choices = NULL
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

#' Prepare Table of Options for Drodown Menus
#'
#' Reads the local mitigator-categories.csv and mitigators.json files. Extracts
#' names and categories into a single lookup table that can be filtered to help
#' decide what values to put in the dropdown menus.
#'
#' @return A data.frame.
#' @noRd
mod_select_strategy_get_strategies <- function() {
  # Read local lookups
  categories <- app_sys("app", "data", "mitigator-categories.csv") |>
    readr::read_csv(
      col_types = readr::cols(
        .default = "c",
        is_care_shift = readr::col_logical()
      )
    )
  strategies <- app_sys("app", "data", "mitigators.json") |>
    yyjsonr::read_json_file()

  strategies |>
    unlist() |>
    tibble::enframe("strategy", "strategy_name") |>
    dplyr::mutate(
      activity_type = stringr::str_extract(
        .data$strategy_name,
        "(?<= \\()(IP|OP|AE)(?=-(AA|EF))" # e.g. 'IP' in 'IP-AA-001'
      ) |>
        stringr::str_to_lower(),
      activity_type_name = dplyr::recode_values(
        activity_type,
        "ip" ~ "Inpatients",
        "op" ~ "Outpatients",
        "ae" ~ "Accident & Emergency"
      )
    ) |>
    dplyr::left_join(categories, by = "strategy")
}

#' Select Strategy Server
#' @param id Internal parameter for `shiny`.
#' @noRd
mod_select_strategy_server <- function(id) {
  # load static data items
  strategies_lookup <- mod_select_strategy_get_strategies()

  # return the shiny module
  shiny::moduleServer(id, function(input, output, session) {
    # A value to hold the bookmarked option if there's one being restored
    pending_strategy <- shiny::reactiveVal(NULL) # does nothing if not restoring

    selected_activity_type <- shiny::reactive({
      shiny::req(input$strategy_activity_type_select)
      input$strategy_activity_type_select
    })

    selected_category <- shiny::reactive({
      shiny::req(input$strategy_category_select)
      input$strategy_category_select
    })

    strategies_filtered <- shiny::reactive({
      shiny::req(input$strategy_activity_type_select)

      strategies_lookup <- strategies_lookup |>
        dplyr::filter(.data$activity_type == input$strategy_activity_type_select)

      if (isTRUE(input$strategy_care_shift_checkbox)) {
        strategies_lookup <- strategies_lookup |>
          dplyr::filter(.data$is_care_shift)
      }

      strategies_lookup
    })

    shiny::observe({
      category_choices <- strategies_filtered() |>
        dplyr::distinct(category_name, category) |>
        tibble::deframe()

      shiny::updateSelectInput(
        session,
        "strategy_category_select",
        choices = category_choices
      )
    })

    shiny::observe({
      shiny::req(input$strategy_category_select)

      strategy_choices <- strategies_filtered() |>
        dplyr::filter(.data$category == input$strategy_category_select) |>
        dplyr::select(strategy_name, strategy) |>
        tibble::deframe()

      # A bookmark restore will have changed this reactiveVal to a strategy
      # value, otherwise it remains NULL
      selected_value <- pending_strategy()

      shiny::updateSelectInput(
        session,
        "strategy_select",
        choices = strategy_choices,
        selected = selected_value # if NULL, default to first available option
      )
    })

    shiny::onRestored(function(state) {
      # Store the bookmarked value. The category dropdown will be updated below,
      # which will then result in the restored strategy being selected.
      pending_strategy(state$input$strategy_select)

      shiny::updateSelectInput(
        session,
        "strategy_category_select",
        selected = state$input$strategy_category_select
      )
    })

    shiny::reactive(input$strategy_select)
  })
}
