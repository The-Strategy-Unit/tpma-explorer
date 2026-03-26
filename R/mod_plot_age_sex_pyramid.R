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
        md_file_to_html("app", "text", "viz-tooltip-pyramid.md"),
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
#' @param inputs_data A reactive. Contains a list with data.frames, which we can
#'     extract the age-sex data from.
#' @param selected_provider Reactive. Provider code, e.g. `"RCF"`.
#' @param selected_strategy Reactive. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @param selected_year Reactive. Selected year in the form `202324`.
#' @param base_size Numeric scalar. For scaling plot-element sizes.
#' @noRd
# nolint start: object_length_linter.
mod_plot_age_sex_pyramid_server <- function(
  # nolint end
  id,
  selected_geography,
  selected_provider,
  selected_strategy,
  selected_year,
  base_size
) {
  shiny::moduleServer(id, function(input, output, session) {
    age_sex_data <- shiny::reactive({
      geography <- shiny::req(selected_geography())
      provider <- shiny::req(selected_provider())
      strategy <- shiny::req(selected_strategy())
      year <- shiny::req(selected_year())

      prepare_age_sex_data(geography, provider, strategy, year)
    })

    output$age_sex_pyramid <- shiny::renderPlot({
      df <- shiny::req(age_sex_data())

      shiny::validate(shiny::need(
        nrow(df) > 0,
        "No data available for these selections."
      ))

      plot_age_sex_pyramid(df, base_size)
    })
  })
}
