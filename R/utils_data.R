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
      sex = dplyr::case_match(
        .data[["sex"]],
        "1" ~ "Males",
        "2" ~ "Females",
        .default = NA_character_
      ),
      sex = factor(.data[["sex"]], levels = c("Males", "Females")),
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
#' @return A lookup from strategy name to strategy group name.
#' @export
make_strategy_group_lookup <- function(strategies_config) {
  strategies_config |>
    purrr::map(\(strategy_group) {
      strategy_group |>
        purrr::pluck("strategy_subset") |>
        names()
    }) |>
    purrr::imap(\(.x, .y) purrr::set_names(rep(.y, length(.x)), .x)) |>
    purrr::flatten()
}

#' Read an Markdown File and Convert to HTML
#' @param ... Character vectors. Construct a path to a Markdown file (like
#'     [file.path]).
#' @return A shiny HTML object.
#' @export
md_file_to_html <- function(...) {
  file <- app_sys(...)
  if (!file.exists(file)) {
    return(NULL)
  }
  shiny::HTML(markdown::mark_html(file, output = FALSE, template = FALSE))
}

#' Convert a Markdown String to HTML
#' @param text Character string. Markdown text to convert to HTML.
#' @return A shiny HTML object.
#' @export
md_string_to_html <- function(text) {
  shiny::HTML(markdown::mark_html(text, output = FALSE, template = FALSE))
}
