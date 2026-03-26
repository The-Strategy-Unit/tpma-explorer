test_that("run_app", {
  # arrange
  download_all_data_mock <- mock()
  shiny_mock <- mock("app")

  local_mocked_bindings(
    "shinyApp" = shiny_mock,
    .package = "shiny"
  )
  local_mocked_bindings(
    "download_all_data" = download_all_data_mock
  )

  # act
  app <- run_app()

  # assert
  expect_equal(app, "app")

  expect_called(shiny_mock, 1)
  expect_args(
    shiny_mock,
    1,
    ui = app_ui,
    server = app_server,
    enableBookmarking = "server"
  )

  expect_called(download_all_data_mock, 1)
  expect_args(download_all_data_mock, 1)
})
