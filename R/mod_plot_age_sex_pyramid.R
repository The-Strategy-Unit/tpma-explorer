#' Plot Age-Sex Pyramid Trend UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_plot_age_sex_pyramid_ui <- function(id) {
  ns <- shiny::NS(id)
  bslib::card(
    bslib::card_header("Age-sex pyramid"),
    bslib::card_body(shiny::plotOutput(ns("age_sex_pyramid"))),
    full_screen = TRUE
  )
}

#' Plot Age-Sex Pyramid Server
#' @param id Internal parameter for `shiny`.
#' @param age_sex_data A data.frame.
#' @param selected_provider Character. Provider code, e.g. `"RCF"`.
#' @param selected_strategy Character. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @noRd
mod_plot_age_sex_pyramid_server <- function(
  id,
  age_sex_data,
  selected_provider,
  selected_strategy,
  start_year
) {
  shiny::moduleServer(id, function(input, output, session) {
    output$age_sex_pyramid <- shiny::renderPlot({
      shiny::req(age_sex_data)
      shiny::req(selected_provider())
      shiny::req(selected_strategy())
      shiny::req(start_year)

      age_data <- age_sex_data |>
        dplyr::filter(
          .data$provider == selected_provider(),
          .data$strategy == selected_strategy(),
          .data$fyear == .env$start_year
        )

      shiny::validate(shiny::need(
        nrow(age_data) > 0,
        "No data available for these selections."
      ))

      plot_age_sex_pyramid(age_data)
    })
  })
}
