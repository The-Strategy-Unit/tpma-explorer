test_that("app_sys", {
  # arrange
  m <- mock("path/to/file")
  local_mocked_bindings(system.file = m)

  # act
  actual <- app_sys("subdir", "file.txt")

  # assert
  expect_equal(actual, "path/to/file")
  expect_called(m, 1)
  expect_args(m, 1, "subdir", "file.txt", package = "tpma.explorer")
})
