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

#' Procedures Table Server
#' @param id Internal parameter for `shiny`.
#' @param inputs_data A reactive. Contains a list with data.frames, which we can
#'     extract the procedures data from.
#' @param selected_provider Reactive. Provider code, e.g. `"RCF"`.
#' @param selected_strategy Reactive. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @param selected_year Reactive. Selected year in the form `202324`.
#' @noRd
mod_table_procedures_server <- function(
  id,
  inputs_data,
  selected_provider,
  selected_strategy,
  selected_year
) {
  # load static data items
  procedures_lookup <- readr::read_csv(
    app_sys("app", "data", "procedures.csv"),
    col_types = "c"
  )

  # return the shiny module
  shiny::moduleServer(id, function(input, output, session) {
    procedures_data <- shiny::reactive({
      inputs_data()[["procedures"]]
    })

    procedures_prepared <- shiny::reactive({
      df <- shiny::req(procedures_data())
      provider <- shiny::req(selected_provider())
      strategy <- shiny::req(selected_strategy())
      year <- shiny::req(selected_year())

      prepare_procedures_data(
        df,
        procedures_lookup,
        provider,
        strategy,
        year
      )
    })

    output$procedures_table <- gt::render_gt({
      shiny::validate(
        shiny::need(
          !is.null(procedures_prepared()) && nrow(procedures_prepared()) > 0,
          "No procedures to display."
        )
      )
      procedures_prepared() |> entable_encounters()
    })
  })
}
