#' @importFrom rlang .data .env :=
NULL

utils::globalVariables("temp")

# in order to mock these base functions in tests, we need to declare them
# see https://testthat.r-lib.org/articles/mocking.html
# nolint start
system.file <- NULL
file.exists <- NULL
# nolint end
