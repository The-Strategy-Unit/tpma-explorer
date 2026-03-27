setup_app_ui_tests <- function(.env = parent.frame()) {
  # in helper-ui.R, ignore lint error "no visible global function definition for 'setup_ui_test'""
  setup_ui_test(.env) # nolint: object_usage_linter

  mocks <- list(
    "mod_select_geography_ui" = mockery::mock("mod_select_geography"),
    "mod_select_provider_ui" = mockery::mock("mod_select_provider"),
    "mod_select_strategy_ui" = mockery::mock("mod_select_strategy"),
    "mod_show_strategy_text_ui" = mockery::mock("mod_show_strategy_text"),
    "mod_plot_rates_ui" = mockery::mock("mod_plot_rates"),
    "mod_table_diagnoses_ui" = mockery::mock("mod_table_diagnoses"),
    "mod_table_procedures_ui" = mockery::mock("mod_table_procedures"),
    "mod_plot_age_sex_pyramid_ui" = mockery::mock("mod_plot_age_sex_pyramid"),
    "mod_plot_nee_ui" = mockery::mock("mod_plot_nee")
  )

  withr::local_envvar(
    .local_envir = .env,
    "FEEDBACK_FORM_URL" = "https://example.com/"
  )

  do.call(testthat::local_mocked_bindings, c(mocks, .env = .env))

  mocks
}
