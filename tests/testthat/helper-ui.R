setup_ui_test <- function(.env = parent.frame()) {
  testthat::local_mocked_bindings(
    "p_randomInt" = \(...) "X",
    .package = "shiny",
    .env = .env
  )
}
