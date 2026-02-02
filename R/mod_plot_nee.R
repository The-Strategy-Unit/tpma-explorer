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
        md_file_to_html("app", "text", "viz-nee.md"),
        placement = "right"
      )
    ),
    bslib::card_body(
      shinycssloaders::withSpinner(shiny::plotOutput(ns("nee")))
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

    output$nee <- shiny::renderPlot({
      df <- selected_nee_data()

      shiny::validate(
        shiny::need(
          nrow(df) > 0,
          paste(
            "This type of potentially-mitigatable activity (TPMA) was not part",
            "of the National Elicitation Exercise (NEE), so a",
            "nationally-determined estimate is not available."
          )
        )
      )

      plot_nee(df)
    })
  })
}
