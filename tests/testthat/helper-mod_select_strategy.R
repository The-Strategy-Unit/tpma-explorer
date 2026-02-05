setup_mod_select_strategy_server <- function(.env = parent.frame()) {
  strategies <- list(
    ip = tibble::tibble(
      name = c("Strategy A", "Strategy B"),
      strategy = c("a", "b")
    ),
    op = tibble::tibble(
      name = c("Strategy C", "Strategy D"),
      strategy = c("c", "d")
    ),
    ae = tibble::tibble(
      name = c("Strategy E", "Strategy F"),
      strategy = c("e", "f")
    )
  )
  m <- mockery::mock(strategies)

  testthat::local_mocked_bindings(
    "mod_select_strategy_get_strategies" = m,
    .env = .env
  )

  m
}
