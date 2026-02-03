library(mockery)

setup_app_ui_tests <- function(.env = parent.frame()) {
  testthat::local_mocked_bindings(
    "p_randomInt" = \(...) "X",
    .package = "shiny",
    .env = .env
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

  mocks
}

test_that("ui", {
  # arrange
  setup_app_ui_tests()

  # act
  ui <- app_ui("request")

  # assert
  expect_snapshot(ui)
})

test_that("calls mod_show_strategy_text_ui", {
  # arrange
  mocks <- setup_app_ui_tests()

  # act
  ui <- app_ui("request")

  # assert
  expect_called(mocks$mod_show_strategy_text_ui, 1)
  expect_args(mocks$mod_show_strategy_text_ui, 1, "mod_show_strategy_text")
})

test_that("calls mod_plot_rates_ui", {
  # arrange
  mocks <- setup_app_ui_tests()

  # act
  ui <- app_ui("request")

  # assert
  expect_called(mocks$mod_plot_rates_ui, 1)
  expect_args(mocks$mod_plot_rates_ui, 1, "mod_plot_rates")
})

test_that("calls mod_table_procedures_ui", {
  # arrange
  mocks <- setup_app_ui_tests()

  # act
  ui <- app_ui("request")

  # assert
  expect_called(mocks$mod_table_procedures_ui, 1)
  expect_args(mocks$mod_table_procedures_ui, 1, "mod_table_procedures")
})


test_that("calls mod_table_diagnoses_ui", {
  # arrange
  mocks <- setup_app_ui_tests()

  # act
  ui <- app_ui("request")

  # assert
  expect_called(mocks$mod_table_diagnoses_ui, 1)
  expect_args(mocks$mod_table_diagnoses_ui, 1, "mod_table_diagnoses")
})


test_that("calls mod_plot_age_sex_pyramid", {
  # arrange
  mocks <- setup_app_ui_tests()

  # act
  ui <- app_ui("request")

  # assert
  expect_called(mocks$mod_plot_age_sex_pyramid_ui, 1)
  expect_args(mocks$mod_plot_age_sex_pyramid_ui, 1, "mod_plot_age_sex_pyramid")
})

test_that("calls mod_plot_nee_ui", {
  # arrange
  mocks <- setup_app_ui_tests()

  # act
  ui <- app_ui("request")

  # assert
  expect_called(mocks$mod_plot_nee_ui, 1)
  expect_args(mocks$mod_plot_nee_ui, 1, "mod_plot_nee")
})

test_that("calls mod_select_geography_ui", {
  # arrange
  mocks <- setup_app_ui_tests()

  # act
  ui <- app_ui("request")

  # assert
  expect_called(mocks$mod_select_geography_ui, 1)
  expect_args(mocks$mod_select_geography_ui, 1, "mod_select_geography")
})

test_that("calls mod_select_provider_ui", {
  # arrange
  mocks <- setup_app_ui_tests()

  # act
  ui <- app_ui("request")

  # assert
  expect_called(mocks$mod_select_provider_ui, 1)
  expect_args(mocks$mod_select_provider_ui, 1, "mod_select_provider")
})

test_that("calls mod_select_strategy_ui", {
  # arrange
  mocks <- setup_app_ui_tests()

  # act
  ui <- app_ui("request")

  # assert
  expect_called(mocks$mod_select_strategy_ui, 1)
  expect_args(mocks$mod_select_strategy_ui, 1, "mod_select_strategy")
})
