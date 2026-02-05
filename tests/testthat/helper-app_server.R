setup_app_server_tests <- function(.env = parent.frame()) {
  shiny::shinyOptions(cache = cachem::cache_mem())

  mocks <- list(
    mod_select_geography_server = mockery::mock(shiny::reactiveVal("nhp")),
    mod_select_provider_server = mockery::mock(shiny::reactiveVal("ABC")),
    mod_select_strategy_server = mockery::mock(shiny::reactiveVal("strategy")),
    get_all_geo_data = mockery::mock(inputs_data_sample, cycle = TRUE),
    mod_show_strategy_text_server = mockery::mock(),
    mod_plot_rates_server = mockery::mock(),
    mod_table_procedures_server = mockery::mock(),
    mod_table_diagnoses_server = mockery::mock(),
    mod_plot_age_sex_pyramid_server = mockery::mock(),
    mod_plot_nee_server = mockery::mock()
  )

  do.call(testthat::local_mocked_bindings, c(mocks, .env = .env))

  mocks
}
