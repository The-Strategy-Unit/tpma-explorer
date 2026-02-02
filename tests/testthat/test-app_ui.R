library(mockery)

test_that("ui", {
  testthat::local_mocked_bindings(
    "p_randomInt" = \(...) "X",
    .package = "shiny"
  )

  mocks <- list(
    "mod_show_strategy_text_ui" = mock("mod_show_strategy_text"),
    "mod_plot_rates_ui" = mock("mod_plot_rates"),
    "mod_table_procedures_ui" = mock("mod_table_procedures"),
    "mod_table_diagnoses_ui" = mock("mod_table_diagnoses"),
    "mod_plot_age_sex_pyramid_ui" = mock("mod_plot_age_sex_pyramid"),
    "mod_plot_nee_ui" = mock("mod_plot_nee"),
    "mod_select_geography_ui" = mock("mod_select_geography"),
    "mod_select_provider_ui" = mock("mod_select_provider"),
    "mod_select_strategy_ui" = mock("mod_select_strategy")
  )

  do.call(testthat::local_mocked_bindings, c(mocks, .env = .env))

  ui <- app_ui("request")

  expect_snapshot(ui)

  expect_called(mocks$mod_show_strategy_text_ui, 1)
  expect_args(mocks$mod_show_strategy_text_ui, 1, "mod_show_strategy_text")

  expect_called(mocks$mod_plot_rates_ui, 1)
  expect_args(mocks$mod_plot_rates_ui, 1, "mod_plot_rates")

  expect_called(mocks$mod_table_procedures_ui, 1)
  expect_args(mocks$mod_table_procedures_ui, 1, "mod_table_procedures")

  expect_called(mocks$mod_table_diagnoses_ui, 1)
  expect_args(mocks$mod_table_diagnoses_ui, 1, "mod_table_diagnoses")

  expect_called(mocks$mod_plot_age_sex_pyramid_ui, 1)
  expect_args(mocks$mod_plot_age_sex_pyramid_ui, 1, "mod_plot_age_sex_pyramid")

  expect_called(mocks$mod_plot_nee_ui, 1)
  expect_args(mocks$mod_plot_nee_ui, 1, "mod_plot_nee")

  expect_called(mocks$mod_select_geography_ui, 1)
  expect_args(mocks$mod_select_geography_ui, 1, "mod_select_geography")

  expect_called(mocks$mod_select_provider_ui, 1)
  expect_args(mocks$mod_select_provider_ui, 1, "mod_select_provider")

  expect_called(mocks$mod_select_strategy_ui, 1)
  expect_args(mocks$mod_select_strategy_ui, 1, "mod_select_strategy")
})
