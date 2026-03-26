#' Procedures Table UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_table_diagnoses_ui <- function(id) {
  ns <- shiny::NS(id)
  bslib::card(
    bslib::card_header(
      "Diagnoses summary",
      bslib::tooltip(
        bsicons::bs_icon("info-circle"),
        md_file_to_html("app", "text", "viz-tooltip-diagnoses.md"),
        placement = "right"
      )
    ),
    bslib::card_body(
      shinycssloaders::withSpinner(
        gt::gt_output(ns("diagnoses_table"))
      )
    ),
    fill = FALSE,
    full_screen = TRUE
  )
}

#' Diagnoses Table Server
#' @param id Internal parameter for `shiny`.
#' @param selected_geography A reactive. Selected geography. Either `"nhp"` or
#'     `"la"`.
#' @param selected_provider Reactive. Provider code, e.g. `"RCF"`.
#' @param selected_strategy Reactive. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @param selected_year Reactive. Selected year in the form `202324`.
#' @noRd
mod_table_diagnoses_server <- function(
  id,
  selected_geography,
  selected_provider,
  selected_strategy,
  selected_year
) {
  # load static data items
  diagnoses_lookup <- readr::read_csv(
    app_sys("app", "reference", "diagnoses.csv"),
    col_types = "c"
  )

  # return the shiny module
  shiny::moduleServer(id, function(input, output, session) {
    diagnoses_prepared <- shiny::reactive({
      geography <- shiny::req(selected_geography())
      provider <- shiny::req(selected_provider())
      strategy <- shiny::req(selected_strategy())
      year <- shiny::req(selected_year())

      prepare_diagnoses_data(
        diagnoses_lookup,
        geography,
        provider,
        strategy,
        year
      )
    })

    output$diagnoses_table <- gt::render_gt({
      df <- diagnoses_prepared()

      shiny::validate(
        shiny::need(
          !is.null(df) && nrow(df) > 0,
          "No diagnoses to display."
        )
      )

      entable_encounters(df)
    })
  })
}
