#' Server-Side Application
#' @param input,output,session Internal parameters for 'shiny'.
#' @noRd
app_server <- function(input, output, session) {
  # Constants ----
  # nolint start: object_name_linter.
  BASE_SIZE <- 16 # scaling for plot elements
  # nolint end

  # User inputs ----
  selected_geography <- mod_select_geography_server(
    "mod_select_geography"
  )
  selected_provider <- mod_select_provider_server(
    "mod_select_provider",
    selected_geography
  )
  selected_strategy <- mod_select_strategy_server(
    "mod_select_strategy"
  )
  selected_year <- shiny::reactive({
    as.numeric(Sys.getenv("BASELINE_YEAR", 202324))
  })

  # Open sidebar ---
  shiny::observe({
    if (input$page_navbar == "Visualisations") {
      # Sidebar options only relevant to visualisations
      bslib::toggle_sidebar("sidebar", open = TRUE)
    } else {
      bslib::toggle_sidebar("sidebar", open = FALSE)
    }
  }) |>
    shiny::bindEvent(input$page_navbar)

  # Open sidebar accordions ----
  shiny::observe({
    # Data must load before accordions open
    shiny::req(selected_provider())
    shiny::req(selected_strategy())
    bslib::accordion_panel_open(id = "sidebar_accordion", values = TRUE)
  })

  # Modules ----
  mod_show_strategy_text_server(
    "mod_show_strategy_text",
    selected_strategy
  )
  mod_plot_rates_server(
    "mod_plot_rates",
    selected_geography,
    selected_provider,
    selected_strategy,
    selected_year,
    BASE_SIZE
  )
  mod_table_procedures_server(
    "mod_table_procedures",
    selected_geography,
    selected_provider,
    selected_strategy,
    selected_year
  )
  mod_table_diagnoses_server(
    "mod_table_diagnoses",
    selected_geography,
    selected_provider,
    selected_strategy,
    selected_year
  )
  mod_plot_age_sex_pyramid_server(
    "mod_plot_age_sex_pyramid",
    selected_geography,
    selected_provider,
    selected_strategy,
    selected_year,
    BASE_SIZE
  )
  mod_plot_nee_server(
    "mod_plot_nee",
    selected_strategy
  )
}
