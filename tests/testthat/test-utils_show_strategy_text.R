test_that("fetch_strategy_text works", {
  # arrange
  m <- function(req) {
    httr2::response(status_code = 200, body = charToRaw("strategy text"))
  }
  httr2::local_mocked_responses(m)

  # act
  text <- fetch_strategy_text("stub")

  # assert
  expect_equal(text, "strategy text")
})

test_that("fetch_strategy_text calls correct url", {
  # arrange
  local_mocked_bindings(
    "req_perform" = identity,
    "resp_body_string" = identity,
    .package = "httr2"
  )

  # act
  req <- fetch_strategy_text("stub")

  # assert

  expect_equal(
    req$url,
    "https://raw.githubusercontent.com/The-Strategy-Unit/nhp_inputs/refs/heads/main/inst/app/strategy_text/stub.md" # nolint
  )
})
