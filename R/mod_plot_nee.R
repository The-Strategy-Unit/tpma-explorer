#' Plot National Elicitation Exercise (NEE) UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_plot_nee_ui <- function(id) {
  ns <- shiny::NS(id)
  bslib::card(
    fill = FALSE,
    bslib::card_header("National Elicitation Exercise (NEE) estimate"),
    bslib::card_body(
      md_file_to_html("app", "text", "viz-nee.md"),
      shinycssloaders::withSpinner(shiny::htmlOutput(ns("nee_text")))
    )
  )
}

#' Plot National Elicitation Exercise (NEE) Server
#' @param id Internal parameter for `shiny`.
#' @param selected_strategy Character. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @noRd
mod_plot_nee_server <- function(id, selected_strategy) {
  # load static data items
  nee_data <- readr::read_csv(
    app_sys("app", "data", "nee_table.csv"),
    col_types = "cddd"
  )

  # return the shiny module
  shiny::moduleServer(id, function(input, output, session) {
    selected_nee_data <- shiny::reactive({
      strat <- shiny::req(selected_strategy())

      nee_data |>
        dplyr::filter(.data$param_name == strat)
    })

    output$nee_text <- shiny::renderText({
      df <- selected_nee_data()

      nee_aggregate <-
        "This TPMA was not part of that exercise. No estimate is available."

      has_nee <- nrow(df) > 0
      if (has_nee) {
        nee_aggregate <- paste0(
          "They predicted that a mean of <b>",
          round(df$mean),
          "%</b> (with an 80% prediction interval from <b>",
          round(df$percentile90),
          "%</b> to <b>",
          round(df$percentile10),
          "%</b>) of this type of activity could be mitigated."
        )
      }

      nee_aggregate
    })
  })
}
