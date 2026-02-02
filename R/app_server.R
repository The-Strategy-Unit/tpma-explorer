#' Server-Side Application
#' @param input,output,session Internal parameters for 'shiny'.
#' @noRd
app_server <- function(input, output, session) {
  cache <- cachem::cache_disk(".cache")
  inputs_data_fn <- memoise::memoise(
    get_all_geo_data,
    cache = cache
  )

  # Variables ----
  geographies <- c(
    "NHS provider trusts" = "nhp",
    "Local authorities (LAs)" = "la"
  )
  data_types <- c("age_sex", "diagnoses", "procedures", "rates")

  # Data ----
  inputs_data_raw <- inputs_data_fn(geographies, data_types)

  inputs_data <- shiny::reactive({
    sg <- shiny::req(selected_geography())
    inputs_data_raw[[sg]]
  })

  # User inputs ----
  selected_geography <- mod_select_geography_server(
    "mod_select_geography",
    geographies
  )
  selected_provider <- mod_select_provider_server(
    "mod_select_provider",
    selected_geography
  )
  selected_strategy <- mod_select_strategy_server(
    "mod_select_strategy"
  )
  selected_year <- shiny::reactive({
    year <- as.numeric(Sys.getenv("BASELINE_YEAR"))

    if (is.na(year)) {
      inputs_data()[["rates"]] |>
        dplyr::pull(.data$fyear) |>
        max()
    } else {
      year
    }
  })

  # Open UI accordion ----
  shiny::observe({
    shiny::req(selected_provider())
    shiny::req(selected_strategy())
    bslib::accordion_panel_open(id = "sidebar_accordion", values = TRUE)
  })

  # Modules ----
  mod_show_strategy_text_server(
    "mod_show_strategy_text",
    selected_strategy,
    cache
  )
  mod_plot_rates_server(
    "mod_plot_rates",
    inputs_data,
    selected_geography,
    selected_provider,
    selected_strategy,
    selected_year
  )
  mod_table_procedures_server(
    "mod_table_procedures",
    inputs_data,
    selected_provider,
    selected_strategy,
    selected_year
  )
  mod_table_diagnoses_server(
    "mod_table_diagnoses",
    inputs_data,
    selected_provider,
    selected_strategy,
    selected_year
  )
  mod_plot_age_sex_pyramid_server(
    "mod_plot_age_sex_pyramid",
    inputs_data,
    selected_provider,
    selected_strategy,
    selected_year
  )
  mod_plot_nee_server(
    "mod_plot_nee",
    selected_strategy
  )
}
