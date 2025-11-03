#' Plot Rates Box UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_plot_rates_box_ui <- function(id) {
  ns <- shiny::NS(id)
  bslib::card(
    bslib::card_header("Rates Box"),
    bslib::card_body(shiny::plotOutput(ns("rates_box_plot"))),
    full_screen = TRUE
  )
}

#' Plot Rates Box Server
#' @param id Internal parameter for `shiny`.
#' @param rates A data.frame. Annual rate values for combinations of provider
#'     and strategy.
#' @param peers_lookup A data.frame. A row per provider-peer pair.
#' @param selected_provider Character. Provider code, e.g. `"RCF"`.
#' @param selected_strategy Character. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @param y_axis_limits Numeric vector. Min and max values for the y axis.
#' @noRd
mod_plot_rates_box_server <- function(
  id,
  rates,
  peers_lookup,
  selected_provider,
  selected_strategy,
  y_axis_limits
) {
  shiny::moduleServer(id, function(input, output, session) {
    output$rates_box_plot <- shiny::renderPlot({
      rates <- rates()
      shiny::validate(shiny::need(
        nrow(rates) > 0,
        "No data available for these selections."
      ))
      plot_rates_box(rates, y_axis_limits())
    })
  })
}
