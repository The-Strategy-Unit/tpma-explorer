#' Plot Rates Trend UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_plot_rates_trend_ui <- function(id) {
  ns <- shiny::NS(id)
  bslib::card(
    bslib::card_header(
      "Rates Trend",
      bslib::tooltip(
        bsicons::bs_icon("info-circle"),
        md_file_to_html("app", "text", "viz-trend.md"),
        placement = "right"
      )
    ),
    bslib::card_body(
      shinycssloaders::withSpinner(
        shiny::plotOutput(ns("rates_trend_plot"))
      )
    ),
    full_screen = TRUE
  )
}

#' Plot Rates Trend Server
#' @param id Internal parameter for `shiny`.
#' @param rates A data.frame. Annual rate values for combinations of provider
#'     and strategy.
#' @param y_axis_limits Numeric vector. Min and max values for the y axis.
#' @param y_axis_title Character. Title for the y-axis.
#' @param y_labels Function. Function to format y-axis labels.
#' @param selected_year Reactive. Selected year in the form `202324`.
#' @noRd
mod_plot_rates_trend_server <- function(
  id,
  rates,
  y_axis_limits,
  y_axis_title,
  y_labels,
  selected_year
) {
  shiny::moduleServer(id, function(input, output, session) {
    output$rates_trend_plot <- shiny::renderPlot({
      shiny::validate(
        shiny::need(
          nrow(rates()) > 0,
          "No data available for these selections."
        )
      )

      plot_rates_trend(
        rates(),
        selected_year(),
        y_axis_limits(),
        y_axis_title = y_axis_title(),
        y_labels = y_labels()
      )
    })
  })
}
