#' Show Strategy Description UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_show_strategy_text_ui <- function(id) {
  ns <- shiny::NS(id)
  bslib::card(
    bslib::card_header("Description"),
    bslib::card_body(
      shinycssloaders::withSpinner(
        shiny::htmlOutput(ns("strategy_text"))
      )
    )
  )
}

#' Get Strategye descriptions Lookup
#' @return a character vector of the strategy stubs.
#' @noRd
mod_show_strategy_text_get_descriptions_lookup <- function() {
  jsonlite::read_json(
    app_sys("app", "data", "descriptions.json"),
    simplifyVector = TRUE
  )
}

#' Show Strategy Description Server
#' @param id Internal parameter for `shiny`.
#' @noRd
mod_show_strategy_text_server <- function(
  id,
  selected_strategy
) {
  # load static data items
  descriptions_lookup <- mod_show_strategy_text_get_descriptions_lookup()

  # return the shiny module
  shiny::moduleServer(id, function(input, output, session) {
    strategy_stub <- shiny::reactive({
      strategy <- shiny::req(selected_strategy())

      is_stub <- stringr::str_detect(strategy, descriptions_lookup)
      descriptions_lookup[is_stub]
    })

    strategy_text <- shiny::reactive({
      s <- shiny::req(strategy_stub())
      fetch_strategy_text(s)
    }) |>
      shiny::bindCache(strategy_stub())

    output$strategy_text <- shiny::renderText({
      t <- shiny::req(strategy_text())
      md_string_to_html(t)
    })
  })
}
