#' Plot Rates Funnel UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_plot_rates_funnel_ui <- function(id) {
  ns <- shiny::NS(id)
  bslib::card(
    bslib::card_header("Rates Funnel"),
    bslib::card_body(
      shinycssloaders::withSpinner(
        shiny::plotOutput(ns("rates_funnel_plot"))
      )
    ),
    full_screen = TRUE
  )
}

#' Plot Rates Funnel Server
#' @param id Internal parameter for `shiny`.
#' @param rates A data.frame. Annual rate values for combinations of provider
#'     and strategy
#' @param funnel_calculations A list. Output from [uprime_calculations] used to
#'     plot U-Prime lines.
#' @param y_axis_limits Numeric vector. Min and max values for the y axis.
#' @param x_axis_title Character. Title for the x-axis.
#' @noRd
mod_plot_rates_funnel_server <- function(
  id,
  rates,
  funnel_calculations,
  y_axis_limits,
  x_axis_title
) {
  shiny::moduleServer(id, function(input, output, session) {
    output$rates_funnel_plot <- shiny::renderPlot({
      rates <- rates()
      shiny::validate(shiny::need(
        nrow(rates) > 0,
        "No data available for these selections."
      ))
      shiny::req(y_axis_limits())
      shiny::req(x_axis_title())

      plot_rates_funnel(
        rates,
        funnel_calculations(),
        y_axis_limits(),
        x_axis_title = x_axis_title()
      )
    })
  })
}
