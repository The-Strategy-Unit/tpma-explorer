#' Prepare Age-Sex Data
#' @param age_sex_data A data.frame. Read from Azure. Counts for each strategy
#'     split by provider, year, age group and sex.
#' @return A data.frame.
#' @export
prepare_age_sex_data <- function(age_sex_data) {
  age_fct <- age_sex_data[["age_group"]] |> # nolint: object_usage_linter.
    unique() |>
    sort()

  age_sex_data |>
    dplyr::mutate(
      age_group = factor(
        .data[["age_group"]],
        levels = .env[["age_fct"]]
      ),
      dplyr::across(
        "sex",
        \(value) {
          forcats::fct_recode(
            as.character(value),
            "Males" = "1",
            "Females" = "2"
          )
        }
      ),
      dplyr::across(
        "n",
        \(value) {
          dplyr::if_else(
            .data[["sex"]] == "Males",
            value * -1, # negative, to appear on the left of the pyramid
            value # positive, to appear on the right of the pyramid
          )
        }
      )
    )
}

#' Read NHP Inputs App Config
#' @param value Value to retrieve from the config file.
#' @param config GOLEM_CONFIG_ACTIVE value. If unset, R_CONFIG_ACTIVE.
#'     If unset, "default".
#' @param use_parent Logical, scan the parent directory for config file.
#' @param file Location of the config file
#' @return A list.
#' @export
get_golem_config <- function(
  value,
  config = Sys.getenv(
    "GOLEM_CONFIG_ACTIVE",
    Sys.getenv(
      "R_CONFIG_ACTIVE",
      "default"
    )
  ),
  use_parent = TRUE,
  file = app_sys("golem-config.yml")
) {
  config::get(
    value = value,
    config = config,
    file = file,
    use_parent = use_parent
  )
}

#' Create a Simple Lookup of Strategies to Strategy Groups
#' @param strategies_config List. Configuration for strategies from the
#'     `"mitigators_config"` element of `golem-config.yml`, read in with
#'     [get_golem_config].
#' @return A data.frame.
#' @export
make_strategy_group_lookup <- function(strategies_config) {
  strategies_config |>
    purrr::map(\(strategy_group) {
      strategy_group |> purrr::pluck("strategy_subset") |> names()
    }) |>
    tibble::enframe(name = "group", value = "strategy") |>
    tidyr::unnest_longer("strategy")
}
