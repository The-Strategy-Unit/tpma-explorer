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
    "get_golem_config" = mockery::mock("strategies_config"),
    "make_strategy_group_lookup" = mockery::mock("strategy_group_lookup"),

    "get_peers_lookup" = mockery::mock("peers_lookup", cycle = TRUE),
    "get_providers_lookup" = mockery::mock("providers_lookup", cycle = TRUE),
    "get_rates_data" = mockery::mock("rates"),
    "generate_rates_trend_data" = mockery::mock("rates_trend_data"),
    "generate_rates_funnel_data" = mockery::mock("rates_funnel_data"),
    "uprime_calculations" = mockery::mock("uprime"),
    "get_rates_y_axis_limits" = mockery::mock("y_axis_limits"),

    "mod_plot_rates_trend_server" = mockery::mock(),
    "mod_plot_rates_funnel_server" = mockery::mock(),
    "mod_plot_rates_box_server" = mockery::mock()
  )
  do.call(testthat::local_mocked_bindings, c(mocks, .env = .env))

  mocks
}
