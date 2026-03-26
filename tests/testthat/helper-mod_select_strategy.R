setup_mod_select_strategy_server <- function(.env = parent.frame()) {
  strategies <- tibble::tibble(
    strategy = c("a", "b", "c", "d", "e", "f"),
    strategy_name = c(
      "Strategy A",
      "Strategy B",
      "Strategy C",
      "Strategy D",
      "Strategy E",
      "Strategy F"
    ),
    activity_type = c("ip", "ip", "op", "op", "ae", "ae"),
    activity_type_name = c(
      "Inpatients",
      "Inpatients",
      "Outpatients",
      "Outpatients",
      "Accident & Emergency",
      "Accident & Emergency"
    ),
    category = c("aa", "ef", "aa", "ef", "aa", "ef"),
    category_name = c(
      "Admission avoidance",
      "Efficiency",
      "Admission avoidance",
      "Efficiency",
      "Admission avoidance",
      "Efficiency"
    ),
    is_care_shift = c(TRUE, FALSE, TRUE, FALSE, TRUE, FALSE)
  )
  m <- mockery::mock(strategies)

  testthat::local_mocked_bindings(
    "mod_select_strategy_get_strategies" = m,
    .env = .env
  )

  m
}
