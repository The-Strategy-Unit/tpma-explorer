setup_mod_plot_rates_ui_tests <- function(.env = parent.frame()) {
  setup_ui_test(.env)

  mocks <- list(
    "mod_plot_rates_trend_ui" = mockery::mock("mod_plot_rates_trend"),
    "mod_plot_rates_funnel_ui" = mockery::mock("mod_plot_rates_funnel"),
    "mod_plot_rates_box_ui" = mockery::mock("mod_plot_rates_box")
  )

  do.call(testthat::local_mocked_bindings, c(mocks, .env = .env))

  mocks
}

server_mod_plot_rates_server_tests <- function(.env = parent.frame()) {
  mocks <- list(
    "mod_plot_rates_trend_server" = mockery::mock(),
    "mod_plot_rates_funnel_server" = mockery::mock(),
    "mod_plot_rates_box_server" = mockery::mock(),
    "get_golem_config" = mockery::mock("strategies_config"),
    "make_strategy_group_lookup" = mockery::mock("strategy_group_lookup"),
    "get_peers_lookup" = mockery::mock("peers_lookup", cycle = TRUE),
    "get_rates_data" = mockery::mock("rates"),
    "get_rates_trend_data" = mockery::mock("rates_trend"),
    "generate_rates_baseline_data" = mockery::mock("rates_baseline"),
    "uprime_calculations" = mockery::mock("uprime")
  )
  do.call(testthat::local_mocked_bindings, c(mocks, .env = .env))

  mocks
}
