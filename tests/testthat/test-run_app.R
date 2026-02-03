library(mockery)
library(testthat)

test_that("run_app", {
  # arrange
  m1 <- mock()
  m2 <- mock("app")
  m3 <- mock("cache")

  local_mocked_bindings(
    "shinyOptions" = m1,
    "shinyApp" = m2,
    .package = "shiny"
  )
  local_mocked_bindings(
    "cache_disk" = m3,
    .package = "cachem"
  )

  # act
  app <- run_app()

  # assert
  expect_equal(app, "app")

  expect_called(m1, 1)
  expect_args(m1, 1, cache = "cache")

  expect_called(m2, 1)
  expect_args(
    m2,
    1,
    ui = app_ui,
    server = app_server,
    enableBookmarking = "server"
  )

  expect_called(m3, 1)
  expect_args(m3, 1, ".cache")
})
