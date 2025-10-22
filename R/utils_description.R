#' Fetch Strategy Text from NHP Inputs
#' @param strategy Character. The variable name for a strategy, e.g.
#'     `"discharged_no_treatment_adult_ambulance"`.
#' @details Markdown files containing strategy descriptions are read from
#'     [NHP Inputs](https://github.com/The-Strategy-Unit/nhp_inputs/).
#' @return Character.
#' @export
fetch_strategy_description <- function(strategy, descriptions_lookup) {
  strategy_text <- descriptions_lookup[stringr::str_detect(
    strategy,
    descriptions_lookup
  )]

  withr::with_tempfile("temp", {
    # nolint start object_usage_linter.
    utils::download.file(
      glue::glue(
        "https://raw.githubusercontent.com/The-Strategy-Unit/nhp_inputs/",
        "refs/heads/main/inst/app/strategy_text/{strategy_text}.md"
      ),
      temp
    )
    cat("\n", file = temp, append = TRUE) # stop 'incomplete final line' warning
    paste(readLines(temp), collapse = "\n")
    # nolint end
  })
}

#' Convert Strategy Text from Markdown to HTML
#' @param text Character. The Markdown text description for a strategy, as read
#'     by [fetch_strategy_description].
#' @return HTML/character.
#' @export
convert_md_to_html <- function(text) {
  shiny::HTML(markdown::mark_html(text, output = FALSE, template = FALSE))
}
