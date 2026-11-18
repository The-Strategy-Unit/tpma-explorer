test_that("ui", {
  skip_if(interactive(), "This test will fail in interactive mode")

  setup_ui_test()

  ui <- mod_select_provider_ui("test")

  expect_snapshot(ui)
})

test_that("server returns reactive", {
  # arrange
  test_server <- function(input, output, session) {
    selected_provider <- mod_select_provider_server("test", reactiveVal("nhp"))
  }

  # act
  shiny::testServer(test_server, {
    session$setInputs("test-provider_select" = "a")
    expect_equal(selected_provider(), "a")

    session$setInputs("test-provider_select" = "b")
    expect_equal(selected_provider(), "b")
  })
})

test_that("providers reactive", {
  # arrange
  m <- mock("providers nhp", "providers la", "providers icb")

  testthat::local_mocked_bindings(
    "read_json_file" = m,
    .package = "yyjsonr"
  )
  testthat::local_mocked_bindings(
    "app_sys" = \(...) file.path("inst", ...)
  )

  # act
  shiny::testServer(
    mod_select_provider_server,
    args = list(
      selected_geography = reactiveVal()
    ),
    {
      # assert
      selected_geography("nhp")
      expect_equal(providers(), "providers nhp")

      selected_geography("la")
      expect_equal(providers(), "providers la")

      selected_geography("icb")
      expect_equal(providers(), "providers icb")

      selected_geography("other")
      expect_error(providers())

      expect_called(m, 3)
      expect_args(m, 1, "inst/app/reference/nhp-datasets.json")
      expect_args(m, 2, "inst/app/reference/la-datasets.json")
      expect_args(m, 3, "inst/app/reference/icb-datasets.json")
    }
  )
})

test_that("it updates the select input", {
  # arrange
  m <- mock()
  testthat::local_mocked_bindings(
    "updateSelectInput" = m,
    .package = "shiny"
  )

  # mock what will happen to providers as we change the selected geography
  testthat::local_mocked_bindings(
    "read_json_file" = mock(
      list("A" = "a", "B" = "b"),
      list("C" = "c", "D" = "d"),
      list("E" = "e", "F" = "f")
    ),
    .package = "yyjsonr"
  )

  # act
  shiny::testServer(
    mod_select_provider_server,
    args = list(
      selected_geography = reactiveVal()
    ),
    {
      # assert
      selected_geography("nhp")
      session$private$flush()
      expect_called(m, 1)
      expect_args(
        m,
        1,
        session,
        "provider_select",
        choices = c("a" = "A", "b" = "B"),
        selected = "RRK" # default selection
      )

      selected_geography("la")
      session$private$flush()
      expect_called(m, 2)
      expect_args(
        m,
        2,
        session,
        "provider_select",
        choices = c("c" = "C", "d" = "D"),
        selected = "E08000025" # default selection
      )

      selected_geography("icb")
      session$private$flush()
      expect_called(m, 3)
      expect_args(
        m,
        3,
        session,
        "provider_select",
        choices = c("e" = "E", "f" = "F"),
        selected = "QHL" # default selection
      )
    }
  )
})

test_that("it selects the restored value when it is valid", {
  # arrange
  m_update <- mock()
  local_mocked_bindings("updateSelectInput" = m_update, .package = "shiny")

  m_restore <- mock("XYZ")
  local_mocked_bindings("restoreInput" = m_restore, .package = "shiny")

  local_mocked_bindings(
    "read_json_file" = mock(
      list("XYZ" = "Some Trust", "RRK" = "Uni Hospitals Birmingham")
    ),
    .package = "yyjsonr"
  )

  # act
  shiny::testServer(
    mod_select_provider_server,
    args = list(selected_geography = \() "nhp"),
    {
      session$private$flush()

      # assert
      expect_called(m_update, 1)
      expect_args(
        m_update,
        1,
        session,
        "provider_select",
        choices = c("Some Trust" = "XYZ", "Uni Hospitals Birmingham" = "RRK"),
        selected = "XYZ" # i.e. the restored value, not the 'RRK' default
      )
    }
  )
})

test_that("get_provider_prompt", {
  expect_equal(as.character(get_provider_prompt("la")), "Select a local authority:")
  expect_equal(as.character(get_provider_prompt("nhp")), "Select a provider trust:")
  expect_equal(as.character(get_provider_prompt("icb")), "Select an ICB:")
})
