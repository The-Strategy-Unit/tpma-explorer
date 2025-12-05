#' Server-Side Application
#' @param input,output,session Internal parameters for 'shiny'.
#' @noRd
app_server <- function(input, output, session) {
  # Variables ----
  geographies <- c(
    "New Hospital Programme (NHP) schemes" = "nhp",
    "Local authorities (LAs)" = "la"
  )
  data_types <- c("age_sex", "diagnoses", "procedures", "rates")
  baseline_year <- Sys.getenv("BASELINE_YEAR") |> as.numeric()

  # Data ----
  inputs_container <- get_container(
    container_name = Sys.getenv("AZ_CONTAINER_INPUTS")
  )
  inputs_data <- get_all_geo_data(inputs_container, geographies, data_types)
  age_sex_data <- shiny::reactive({
    shiny::req(selected_geography())
    inputs_data[[selected_geography()]][["age_sex"]] |>
      prepare_age_sex_data()
  })
  diagnoses_data <- shiny::reactive({
    shiny::req(selected_geography())
    inputs_data[[selected_geography()]][["diagnoses"]]
  })
  procedures_data <- shiny::reactive({
    shiny::req(selected_geography())
    inputs_data[[selected_geography()]][["procedures"]]
  })
  rates_data <- shiny::reactive({
    shiny::req(selected_geography())
    inputs_data[[selected_geography()]][["rates"]]
  })
  nee_data <- readr::read_csv(
    app_sys("app", "data", "nee_table.csv"),
    col_types = "cddd"
  )

  # Lookups (general) ----
  descriptions_lookup <- jsonlite::read_json(
    app_sys("app", "data", "descriptions.json"),
    simplifyVector = TRUE
  )
  diagnoses_lookup <- readr::read_csv(
    app_sys("app", "data", "diagnoses.csv"),
    col_types = "c"
  )
  procedures_lookup <- readr::read_csv(
    app_sys("app", "data", "procedures.csv"),
    col_types = "c"
  )
  strategies_config <- get_golem_config("mitigators_config")
  strategies_lookup <- jsonlite::read_json(
    app_sys("app", "data", "mitigators.json"),
    simplify_vector = TRUE
  )

  # Lookups ----
  # TODO: read lookups into single object, as per providers
  nhp_providers_lookup <- jsonlite::read_json(
    app_sys("app", "data", "nhp-datasets.json"),
    simplify_vector = TRUE
  )
  la_providers_lookup <- jsonlite::read_json(
    app_sys("app", "data", "la-datasets.json"),
    simplify_vector = TRUE
  )
  nhp_peers_lookup <- readr::read_csv(
    app_sys("app", "data", "nhp-peers.csv"),
    col_types = "c"
  )
  la_peers_lookup <- readr::read_csv(
    app_sys("app", "data", "la-peers.csv"),
    col_types = "c"
  )
  # TODO: make reactives in similar style to providers
  providers_lookup <- shiny::reactive({
    shiny::req(selected_geography())
    shiny::req(nhp_providers_lookup)
    shiny::req(la_providers_lookup)
    if (selected_geography() == "nhp") {
      nhp_providers_lookup
    } else {
      la_providers_lookup
    }
  })
  peers_lookup <- shiny::reactive({
    shiny::req(selected_geography())
    shiny::req(nhp_peers_lookup)
    shiny::req(la_peers_lookup)
    if (selected_geography() == "nhp") nhp_peers_lookup else la_peers_lookup
  })

  # User inputs ----
  selected_geography <- mod_select_geography_server(
    "mod_select_geography",
    geographies
  )
  selected_provider <- mod_select_provider_server(
    "mod_select_provider",
    selected_geography,
    providers_lookup
  )
  selected_strategy <- mod_select_strategy_server(
    "mod_select_strategy",
    strategies_lookup
  )

  # Open UI accordion ----
  shiny::observe({
    shiny::req(selected_provider())
    shiny::req(selected_strategy())
    bslib::accordion_panel_open(id = "sidebar_accordion", values = TRUE)
  })

  # Modules ----
  mod_show_strategy_text_server(
    "mod_show_strategy_text",
    descriptions_lookup,
    selected_strategy
  )
  mod_plot_rates_server(
    "mod_plot_rates",
    rates_data,
    strategies_config,
    peers_lookup,
    selected_provider,
    selected_strategy,
    baseline_year
  )
  mod_table_procedures_server(
    "mod_table_procedures",
    procedures_data,
    procedures_lookup,
    selected_provider,
    selected_strategy,
    baseline_year
  )
  mod_table_diagnoses_server(
    "mod_table_diagnoses",
    diagnoses_data,
    diagnoses_lookup,
    selected_provider,
    selected_strategy,
    baseline_year
  )
  mod_plot_age_sex_pyramid_server(
    "mod_plot_age_sex_pyramid",
    age_sex_data,
    selected_provider,
    selected_strategy,
    baseline_year
  )
  mod_plot_nee_server(
    "mod_plot_nee",
    nee_data,
    selected_strategy
  )
}
