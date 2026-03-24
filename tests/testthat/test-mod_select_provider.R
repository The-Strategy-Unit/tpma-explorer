test_that("ui", {
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
  m <- mock("providers nhp", "providers la")

  testthat::local_mocked_bindings(
    "read_json_file" = m,
    .package = "yyjsonr"
  )
  testthat::local_mocked_bindings(
    "app_sys" = \(...) file.path("inst", ...),
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

      selected_geography("other")
      expect_error(providers())

      expect_called(m, 2)
      expect_args(
        m,
        1,
        "inst/app/reference/nhp-datasets.json"
      )
      expect_args(
        m,
        2,
        "inst/app/reference/la-datasets.json"
      )
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
      list("C" = "c", "D" = "d")
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
        choices = c("a" = "A", "b" = "B")
      )

      selected_geography("la")
      session$private$flush()
      expect_called(m, 2)
      expect_args(
        m,
        2,
        session,
        "provider_select",
        choices = c("c" = "C", "d" = "D")
      )
    }
  )
})

test_that("onRestored works correctly", {
  # arrange
  m_update <- mock()
  m_restored <- mock()
  local_mocked_bindings(
    "updateSelectInput" = m_update,
    "onRestored" = m_restored,
    .package = "shiny"
  )

  # act
  shiny::testServer(
    mod_select_provider_server,
    args = list(
      selected_geography = reactiveVal("nhp")
    ),
    {
      # assert
      expect_called(m_restored, 1)
      expect_args(m_restored, 1, restore)

      restore(list(
        input = list(
          provider_select = "a"
        )
      ))
      expect_called(m_update, 1)
      expect_args(
        m_update,
        1,
        session,
        "provider_select",
        choices = c("a")
      )
    }
  )
})
