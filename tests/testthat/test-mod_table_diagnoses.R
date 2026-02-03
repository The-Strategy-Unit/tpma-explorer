library(mockery)
library(testthat)

test_that("ui", {
  testthat::local_mocked_bindings(
    "p_randomInt" = \(...) "X",
    .package = "shiny"
  )

  ui <- mod_table_diagnoses_ui("test")

  expect_snapshot(ui)
})

test_that("it loads the diagnoses csv", {
  # arrange
  m <- mock("diagnoses_lookup")
  testthat::local_mocked_bindings("read_csv" = m, .package = "readr")

  # act
  shiny::testServer(
    mod_table_diagnoses_server,
    args = list(
      inputs_data = reactiveVal(),
      selected_provider = reactiveVal("R00"),
      selected_strategy = reactiveVal("strategy"),
      selected_year = reactiveVal(1)
    ),
    {
      # assert
      expect_equal(diagnoses_lookup, "diagnoses_lookup")
      expect_called(m, 1)
      expect_call(
        m,
        1,
        readr::read_csv(
          app_sys("app", "data", "diagnoses.csv"),
          col_types = "c"
        )
      )
    }
  )
})

test_that("diagnoses_data", {
  # arrange
  sample_inputs_data = list(
    diagnoses = "diagnoses"
  )

  # act
  shiny::testServer(
    mod_table_diagnoses_server,
    args = list(
      inputs_data = reactiveVal(sample_inputs_data),
      selected_provider = reactiveVal("R00"),
      selected_strategy = reactiveVal("strategy"),
      selected_year = reactiveVal(1)
    ),
    {
      actual <- diagnoses_data()

      # assert
      expect_equal(actual, "diagnoses")
    }
  )
})


test_that("diagnoses_prepared", {
  # arrange
  sample_inputs_data <- list(
    diagnoses = "diagnoses"
  )

  testthat::local_mocked_bindings(
    "read_csv" = \(...) "diagnoses_lookup",
    .package = "readr"
  )

  m <- mock("diagnoses_prepared")
  testthat::local_mocked_bindings(
    "prepare_diagnoses_data" = m
  )

  # act
  shiny::testServer(
    mod_table_diagnoses_server,
    args = list(
      inputs_data = reactiveVal(sample_inputs_data),
      selected_provider = reactiveVal("R00"),
      selected_strategy = reactiveVal("strategy"),
      selected_year = reactiveVal(1)
    ),
    {
      actual <- diagnoses_prepared()

      # assert
      expect_equal(actual, "diagnoses_prepared")
      expect_called(m, 1)
      expect_args(m, 1, "diagnoses", "diagnoses_lookup", "R00", "strategy", 1)
    }
  )
})

test_that("diagnoses_table (no rows)", {
  # arrange
  testthat::local_mocked_bindings("prepare_diagnoses_data" = \(...) {
    tibble::tibble()
  })

  # act
  shiny::testServer(
    mod_table_diagnoses_server,
    args = list(
      inputs_data = reactiveVal(list(diagnoses = "diagnoses")),
      selected_provider = reactiveVal("R00"),
      selected_strategy = reactiveVal("strategy"),
      selected_year = reactiveVal(1)
    ),
    {
      # assert
      expect_error(
        output$diagnoses_table,
        "No diagnoses to display."
      )
    }
  )
})

test_that("diagnoses_table (with rows)", {
  # arrange
  sample_prepared_data <- tibble::tibble(a = 1, b = 2)

  m <- mock("entabled")
  testthat::local_mocked_bindings(
    "prepare_diagnoses_data" = \(...) sample_prepared_data,
    "entable_encounters" = m
  )

  testthat::local_mocked_bindings(
    "render_gt" = shiny::renderText,
    .package = "gt"
  )

  # act
  shiny::testServer(
    mod_table_diagnoses_server,
    args = list(
      inputs_data = reactiveVal(list(diagnoses = "diagnoses")),
      selected_provider = reactiveVal("R00"),
      selected_strategy = reactiveVal("strategy"),
      selected_year = reactiveVal(1)
    ),
    {
      actual <- output$diagnoses_table

      # assert
      expect_equal(actual, "entabled")
      expect_called(m, 1)
      expect_args(m, 1, sample_prepared_data)
    }
  )
})
