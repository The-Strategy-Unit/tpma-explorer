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
  expected <- tibble::tibble(provider = "R00", strategy = "a", fyear = 2)

  # act
  shiny::testServer(
    mod_plot_age_sex_pyramid_server,
    args = list(
      inputs_data = reactiveVal(inputs_data_sample),
      selected_provider = reactiveVal("R00"),
      selected_strategy = reactiveVal("a"),
      selected_year = reactiveVal(2)
    ),
    {
      actual <- age_sex_data()

      # assert
      expect_equal(actual, "age_sex_data")

      expect_called(m, 1)
      expect_args(m, 1, expected)
    }
  )
})

test_that("age_sex_pyramid (no rows)", {
  # arrange
  testthat::local_mocked_bindings("prepare_age_sex_data" = \(...) {
    tibble::tibble()
  })

  # act
  shiny::testServer(
    mod_plot_age_sex_pyramid_server,
    args = list(
      inputs_data = reactiveVal(inputs_data_sample),
      selected_provider = reactiveVal("R00"),
      selected_strategy = reactiveVal("a"),
      selected_year = reactiveVal(2)
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
  m <- mock("plot")
  testthat::local_mocked_bindings(
    "prepare_age_sex_data" = identity,
    "plot_age_sex_pyramid" = m
  )

  # replace renderPlot to avoid actual plotting, replace with renderText so we
  # can simply check the output
  testthat::local_mocked_bindings(
    "renderPlot" = shiny::renderText,
    .package = "shiny"
  )

  expected <- tibble::tibble(provider = "R00", strategy = "a", fyear = 2)

  # act
  shiny::testServer(
    mod_plot_age_sex_pyramid_server,
    args = list(
      inputs_data = reactiveVal(inputs_data_sample),
      selected_provider = reactiveVal("R00"),
      selected_strategy = reactiveVal("a"),
      selected_year = reactiveVal(2)
    ),
    {
      actual <- output$age_sex_pyramid

      # assert
      expect_equal(actual, "plot")

      expect_called(m, 1)
      expect_args(m, 1, expected)
    }
  )
})
