#' Plot National Elicitation Exercise (NEE) UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_plot_nee_ui <- function(id) {
  ns <- shiny::NS(id)
  bslib::card(
    bslib::card_header(
      "National Elicitation Exercise (NEE) estimate",
      bslib::tooltip(
        bsicons::bs_icon("info-circle"),
        md_file_to_html("app", "text", "viz-tooltip-nee.md"),
        placement = "right"
      )
    ),
    bslib::card_body(
      md_file_to_html("app", "text", "viz-nee.md"),
      shinycssloaders::withSpinner(shiny::textOutput(ns("nee_text"))),
      shinycssloaders::withSpinner(
        shiny::plotOutput(ns("nee_plot"), height = "100px")
      )
    ),
    full_screen = TRUE
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

      nee_aggregate <- "This TPMA was not part of the NEE. No estimate is available."

      has_nee <- nrow(df) > 0
      if (has_nee) {
        nee_aggregate <- paste0(
          "The mean prediction for this TPMA was ",
          round(df$mean),
          "%, with an 80% prediction interval from ",
          round(df$percentile90),
          "% to ",
          round(df$percentile10),
          "%."
        )
      }

      nee_aggregate
    })

    output$nee_plot <- shiny::renderPlot({
      df <- selected_nee_data()
      shiny::req(nrow(df) > 0)
      plot_nee(df)
    })
  })
}
