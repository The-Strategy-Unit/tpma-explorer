#' Fetch Strategy Text from NHP Inputs
#' @param strategy_stub Character. Strategy variable name stub, e.g.
#'     `"alcohol_partially_attributable"`.
#' @details Markdown files containing strategy descriptions are read from
#'     [NHP Inputs](https://github.com/The-Strategy-Unit/nhp_inputs/).
#' @return Character.
#' @export
fetch_strategy_text <- function(strategy_stub) {
  strategy_text_dir <- file.path(app_sys("app"), "data", "strategy_text")
  if (!dir.exists(strategy_text_dir)) {
    dir.create(strategy_text_dir, recursive = TRUE)
  }

  filename <- file.path(strategy_text_dir, glue::glue("{strategy_stub}.md"))

  if (!file.exists(filename)) {
    httr2::request("https://raw.githubusercontent.com") |>
      httr2::req_url_path(
        "The-Strategy-Unit",
        "nhp_inputs",
        "refs",
        "heads",
        "main",
        "inst",
        "app",
        "strategy_text",
        glue::glue("{strategy_stub}.md")
      ) |>
      httr2::req_perform() |>
      httr2::resp_body_string() |>
      readr::write_file(filename)
  }

  readr::read_lines(filename)
}
