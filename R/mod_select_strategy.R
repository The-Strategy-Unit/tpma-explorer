#' Select Strategy UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_select_strategy_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::selectInput(
      ns("strategy_category_select"),
      "Filter by activity type:",
      choices = c(
        "Inpatients" = "ip",
        "Outpatients" = "op",
        "Accident & Emergency" = "ae"
      )
    ),
    shiny::selectInput(
      ns("strategy_select"),
      "Choose a TPMA:",
      choices = NULL
    )
  )
}

#' Select Strategy Server
#' @param id Internal parameter for `shiny`.
#' @param strategies A named list. Names are strategy variable names (e.g.
#'     `"alcohol_partially_attributable_acute"`) and their values are the
#'     corresponding human-readable names and codes (e.g.
#'     `"Alcohol Related Admissions (Acute Conditions - Partially Attributable)
#'     (IP-AA-001)"`).
#' @noRd
mod_select_strategy_server <- function(id, strategies) {
  shiny::moduleServer(id, function(input, output, session) {
    shiny::req(strategies)

    select_category <- shiny::reactive({
      shiny::req(input$strategy_category_select)
      input$strategy_category_select
    })

    shiny::observe({
      shiny::req(select_category())

      category_strategies <- strategies |>
        unlist() |>
        tibble::enframe("strategy", "name") |>
        dplyr::mutate(
          category = stringr::str_extract(
            .data$name,
            "(?<= \\()(IP|OP|AE)(?=-(AA|EF))" # e.g. 'IP' in 'IP-AA-001'
          ) |>
            stringr::str_to_lower()
        ) |>
        dplyr::filter(.data$category == select_category()) |>
        dplyr::select("strategy", "name") |>
        tibble::deframe()

      strategy_choices <- purrr::set_names(
        names(category_strategies),
        category_strategies
      )

      shiny::updateSelectInput(
        session,
        "strategy_select",
        choices = strategy_choices
      )
    })

    shiny::reactive(input$strategy_select)
  })
}
