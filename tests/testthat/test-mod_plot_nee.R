test_that("ui", {
  setup_ui_test()

  ui <- mod_plot_nee_ui("test")

  expect_snapshot(ui)
})

test_that("selected_nee_data", {
  # arrange
  expected <- tibble::tibble(
    param_name = "smoking",
    mean = 84.3,
    percentile10 = 98.9,
    percentile90 = 60.0
  )

  # act
  shiny::testServer(
    mod_plot_nee_server,
    args = list(
      selected_strategy = reactiveVal("smoking")
    ),
    {
      actual <- selected_nee_data()

      # assert
      expect_equal(actual, expected, tolerance = 1e-1)
    }
  )
})

test_that("nee (no rows)", {
  # arrange
  testthat::local_mocked_bindings("prepare_age_sex_data" = \(...) {
    tibble::tibble()
  })

  # act
  shiny::testServer(
    mod_plot_nee_server,
    args = list(
      selected_strategy = reactiveVal("X")
    ),
    {
      # assert
      expect_error(output$nee)
    }
  )
})


test_that("nee (with rows)", {
  # arrange
  m <- mock("plot")
  testthat::local_mocked_bindings(
    "plot_nee" = m
  )

  # replace renderPlot to avoid actual plotting, replace with renderText so we
  # can simply check the output
  testthat::local_mocked_bindings(
    "renderPlot" = shiny::renderText,
    .package = "shiny"
  )

  # act
  shiny::testServer(
    mod_plot_nee_server,
    args = list(
      selected_strategy = reactiveVal("smoking")
    ),
    {
      actual <- output$nee

      # assert
      expect_equal(actual, "plot")

      expect_called(m, 1)
      expect_call(m, 1, plot_nee(df))
    }
  )
})
