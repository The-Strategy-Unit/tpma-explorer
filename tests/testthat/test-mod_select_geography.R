test_that("ui", {
  skip_if(interactive(), "This test will fail in interactive mode")

  setup_ui_test()

  ui <- mod_select_geography_ui("test")

  expect_snapshot(ui)
})

test_that("server returns reactive", {
  # arrange
  test_server <- function(input, output, session) {
    selected_geography <- mod_select_geography_server("test")
  }

  # act
  shiny::testServer(test_server, {
    session$setInputs("test-geography_select" = "nhp")
    expect_equal(selected_geography(), "nhp")

    session$setInputs("test-geography_select" = "la")
    expect_equal(selected_geography(), "la")
  })
})
