#' Plot Rates Trend UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_plot_rates_trend_ui <- function(id) {
  ns <- shiny::NS(id)
  bslib::card(
    bslib::card_header("Rates Trend"),
    bslib::card_body(shiny::plotOutput(ns("rates_trend_plot"))),
    full_screen = TRUE
  )
}

#' Plot Rates Trend Server
#' @param id Internal parameter for `shiny`.
#' @param rates A data.frame. Annual rate values for combinations of provider
#'     and TPMA.
#' @param selected_provider Character. Provider code, e.g. `"RCX"`.
#' @param selected_strategy Character. TPMA variable name, e.g.
#'     `"discharged_no_treatment_adult_ambulance"`.
#' @param y_axis_limits Numeric vector. Min and max values for the y axis.
#' @noRd
mod_plot_rates_trend_server <- function(
  id,
  rates,
  selected_provider,
  selected_strategy,
  y_axis_limits
) {
  shiny::moduleServer(id, function(input, output, session) {
    output$rates_trend_plot <- shiny::renderPlot({
      rates <- rates()
      shiny::validate(shiny::need(
        nrow(rates) > 0,
        "No data available for these selections."
      ))
      plot_rates_trend(rates, y_axis_limits = y_axis_limits())
    })
  })
}
