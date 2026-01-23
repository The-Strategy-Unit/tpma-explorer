#' Plot Age-Sex Pyramid UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_plot_age_sex_pyramid_ui <- function(id) {
  ns <- shiny::NS(id)
  bslib::card(
    bslib::card_header(
      "Age-sex pyramid",
      bslib::tooltip(
        bsicons::bs_icon("info-circle"),
        md_file_to_html("app", "text", "viz-pyramid.md"),
        placement = "right"
      )
    ),
    bslib::card_body(
      shinycssloaders::withSpinner(
        shiny::plotOutput(ns("age_sex_pyramid"))
      )
    ),
    full_screen = TRUE
  )
}

#' Plot Age-Sex Pyramid Server
#' @param id Internal parameter for `shiny`.
#' @param age_sex_data A data.frame. Age-sex data read from Azure and processed
#'     with [prepare_age_sex_data]. Counts for each strategy split by provider,
#'     year, age group and sex.
#' @param selected_provider Character. Provider code, e.g. `"RCF"`.
#' @param selected_strategy Character. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @param baseline_year Integer. Baseline year in the form `202324`.
#' @noRd
# nolint start: object_length_linter.
mod_plot_age_sex_pyramid_server <- function(
  # nolint end
  id,
  age_sex_data,
  selected_provider,
  selected_strategy,
  baseline_year
) {
  shiny::moduleServer(id, function(input, output, session) {
    output$age_sex_pyramid <- shiny::renderPlot({
      shiny::req(age_sex_data())
      shiny::req(selected_provider())
      shiny::req(selected_strategy())
      shiny::req(baseline_year)

      age_sex_filtered <- age_sex_data() |>
        dplyr::filter(
          .data$provider == selected_provider(),
          .data$strategy == selected_strategy(),
          .data$fyear == .env$baseline_year
        )

      shiny::validate(shiny::need(
        nrow(age_sex_filtered) > 0,
        "No data available for these selections."
      ))

      plot_age_sex_pyramid(age_sex_filtered)
    })
  })
}
