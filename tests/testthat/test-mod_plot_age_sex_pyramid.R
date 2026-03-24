# nolint start
test_that("ui", {
  setup_ui_test()

  ui <- mod_plot_age_sex_pyramid_ui("test")

  expect_snapshot(ui)
})

test_that("age_sex_data", {
  # arrange
  m <- mock("age_sex_data")
  testthat::local_mocked_bindings("prepare_age_sex_data" = m)

  # act
  shiny::testServer(
    mod_plot_age_sex_pyramid_server,
    args = list(
      selected_geography = reactiveVal("geography"),
      selected_provider = reactiveVal("R00"),
      selected_strategy = reactiveVal("a"),
      selected_year = reactiveVal(2),
      16
    ),
    {
      actual <- age_sex_data()

      # assert
      expect_equal(actual, "age_sex_data")

      expect_called(m, 1)
      expect_args(m, 1, "geography", "R00", "a", 2)
    }
  )
})

test_that("age_sex_pyramid (no rows)", {
  # arrange
  testthat::local_mocked_bindings(
    "prepare_age_sex_data" = \(...) tibble::tibble()
  )

  # act
  shiny::testServer(
    mod_plot_age_sex_pyramid_server,
    args = list(
      selected_geography = reactiveVal("geography"),
      selected_provider = reactiveVal("R00"),
      selected_strategy = reactiveVal("a"),
      selected_year = reactiveVal(2),
      16
    ),
    {
      # assert
      expect_error(
        output$age_sex_pyramid,
        "No data available for these selections."
      )
    }
  )
})


test_that("age_sex_pyramid (with rows)", {
  # arrange
  expected <- tibble::tibble(provider = "R00", strategy = "a", fyear = 2)

  m <- mock("plot")
  testthat::local_mocked_bindings(
    "prepare_age_sex_data" = \(...) expected,
    "plot_age_sex_pyramid" = m
  )

  # replace renderPlot to avoid actual plotting, replace with renderText so we
  # can simply check the output
  testthat::local_mocked_bindings(
    "renderPlot" = shiny::renderText,
    .package = "shiny"
  )

  # act
  shiny::testServer(
    mod_plot_age_sex_pyramid_server,
    args = list(
      selected_geography = reactiveVal("geography"),
      selected_provider = reactiveVal("R00"),
      selected_strategy = reactiveVal("a"),
      selected_year = reactiveVal(2),
      16
    ),
    {
      actual <- output$age_sex_pyramid

      # assert
      expect_equal(actual, "plot")

      expect_called(m, 1)
      expect_args(m, 1, expected, 16)
    }
  )
})
