test_that("fetch_strategy_text works", {
  # arrange
  mock_http <- function(req) {
    httr2::response(status_code = 200, body = charToRaw("strategy text"))
  }
  httr2::local_mocked_responses(mock_http)

  mock_write_file <- mock("file")
  local_mocked_bindings(
    "write_file" = mock_write_file,
    .package = "readr"
  )

  # act
  fetch_strategy_text("stub", "filename.md")

  # assert
  expect_called(mock_write_file, 1)
  expect_args(mock_write_file, 1, "strategy text", "filename.md")
})

test_that("fetch_strategy_text calls correct url", {
  # arrange
  local_mocked_bindings(
    "req_perform" = identity,
    "resp_body_string" = identity,
    .package = "httr2"
  )

  local_mocked_bindings(
    "write_file" = \(x, ...) x,
    .package = "readr"
  )

  # act
  req <- fetch_strategy_text("stub", "filename.md")

  # assert

  expect_equal(
    req$url,
    "https://raw.githubusercontent.com/The-Strategy-Unit/nhp_inputs/refs/heads/main/inst/app/strategy_text/stub.md" # nolint
  )
})

test_that("get_strategy_text reads from file if it exists", {
  # arrange
  dir_exists_mock <- mock(TRUE)
  dir_create_mock <- mock()
  file_exists_mock <- mock(TRUE)
  fetch_strategy_mock <- mock()
  read_file_mock <- mock("strategy text")

  mockery::stub(read_strategy_text, "dir.exists", dir_exists_mock)
  mockery::stub(read_strategy_text, "dir.create", dir_create_mock)

  local_mocked_bindings(
    "fetch_strategy_text" = fetch_strategy_mock
  )
  local_mocked_bindings(
    "read_lines" = read_file_mock,
    .package = "readr"
  )

  # act
  text <- read_strategy_text("stub")

  # assert
  expect_equal(text, "strategy text")

  expect_called(fetch_strategy_mock, 0)
})

test_that("get_strategy_text fetches file if it doesn't exist", {
  # arrange
  dir_exists_mock <- mock(TRUE)
  dir_create_mock <- mock()
  file_exists_mock <- mock(FALSE)
  fetch_strategy_mock <- mock()
  read_file_mock <- mock("strategy text")

  mockery::stub(read_strategy_text, "dir.exists", dir_exists_mock)
  mockery::stub(read_strategy_text, "dir.create", dir_create_mock)

  local_mocked_bindings(
    "fetch_strategy_text" = fetch_strategy_mock,
    "app_sys" = file.path
  )
  local_mocked_bindings(
    "read_lines" = read_file_mock,
    .package = "readr"
  )

  # act
  text <- read_strategy_text("stub")

  # assert
  expect_equal(text, "strategy text")

  expect_called(fetch_strategy_mock, 1)
  expect_args(fetch_strategy_mock, 1, "stub", "app/data/strategy_text/stub.md")
})

test_that("get_strategy_text creates the directory if it doesn't exist", {
  # arrange
  dir_exists_mock <- mock(FALSE)
  dir_create_mock <- mock()
  file_exists_mock <- mock(TRUE)
  fetch_strategy_mock <- mock()
  read_file_mock <- mock("strategy text")

  mockery::stub(read_strategy_text, "dir.exists", dir_exists_mock)
  mockery::stub(read_strategy_text, "dir.create", dir_create_mock)

  local_mocked_bindings(
    "fetch_strategy_text" = fetch_strategy_mock,
    "app_sys" = file.path
  )
  local_mocked_bindings(
    "read_lines" = read_file_mock,
    .package = "readr"
  )

  # act
  text <- read_strategy_text("stub")

  # assert
  expect_equal(text, "strategy text")

  expect_called(dir_exists_mock, 1)
  expect_args(dir_exists_mock, 1, "app/data/strategy_text")
  expect_called(dir_create_mock, 1)
  expect_args(dir_create_mock, 1, "app/data/strategy_text", recursive = TRUE)
})
