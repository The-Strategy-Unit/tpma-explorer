#' Procedures Table UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_table_procedures_ui <- function(id) {
  ns <- shiny::NS(id)
  bslib::card(
    bslib::card_header(
      "Procedures summary",
      bslib::tooltip(
        bsicons::bs_icon("info-circle"),
        md_file_to_html("app", "text", "viz-tooltip-procedures.md"),
        placement = "right"
      )
    ),
    bslib::card_body(
      shinycssloaders::withSpinner(
        gt::gt_output(ns("procedures_table"))
      )
    ),
    fill = FALSE,
    full_screen = TRUE
  )
}

mod_table_procedures_data <- function(
  selected_geography,
  selected_provider,
  selected_strategy,
  selected_year
) {
  get_arrow_dataset(selected_geography, "procedures") |>
    dplyr::filter(
      .data$provider == selected_provider,
      .data$strategy == selected_strategy,
      .data$fyear == selected_year
    ) |>
    dplyr::select("procedure_code", "n", "total", "pcnt", "rn") |>
    dplyr::collect()
}

#' Procedures Table Server
#' @param id Internal parameter for `shiny`.
#' @param selected_geography Reactive. Selected geography. Either `"nhp"` or
#'     `"la"`.
#' @param selected_provider Reactive. Provider code, e.g. `"RCF"`.
#' @param selected_strategy Reactive. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @param selected_year Reactive. Selected year in the form `202324`.
#' @noRd
mod_table_procedures_server <- function(
  id,
  selected_geography,
  selected_provider,
  selected_strategy,
  selected_year
) {
  # load static data items
  procedures_lookup <- readr::read_csv(
    app_sys("app", "reference", "procedures.csv"),
    col_types = "c"
  )

  # return the shiny module
  shiny::moduleServer(id, function(input, output, session) {
    procedures_prepared <- shiny::reactive({
      geography <- shiny::req(selected_geography())
      provider <- shiny::req(selected_provider())
      strategy <- shiny::req(selected_strategy())
      year <- shiny::req(selected_year())

      prepare_procedures_data(
        procedures_lookup,
        geography,
        provider,
        strategy,
        year
      )
    })

    output$procedures_table <- gt::render_gt({
      df <- procedures_prepared()

      shiny::validate(
        shiny::need(
          !is.null(df) && nrow(df) > 0,
          "No procedures to display."
        )
      )

      entable_encounters(df)
    })
  })
}
