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
