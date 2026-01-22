#' Plot National Elicitation Exercise (NEE) UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_plot_nee_ui <- function(id) {
  ns <- shiny::NS(id)
  bslib::card(
    bslib::card_header(
      "National Elicitation Exercise (NEE) estimate",
      bslib::tooltip(
        bsicons::bs_icon("question-circle"),
        md_file_to_html("app", "text", "card-info-nee.md"),
        placement = "right"
      )
    ),
    bslib::card_body(
      shinycssloaders::withSpinner(shiny::plotOutput(ns("nee")))
    ),
    full_screen = TRUE
  )
}

#' Plot National Elicitation Exercise (NEE) Server
#' @param id Internal parameter for `shiny`.
#' @param nee_data A data.frame. Mean, p10 and p90 predictions for each of the
#'     strategies that were part of the National Elicitation Exercise (NEE).
#' @param selected_strategy Character. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @noRd
mod_plot_nee_server <- function(id, nee_data, selected_strategy) {
  shiny::moduleServer(id, function(input, output, session) {
    output$nee <- shiny::renderPlot({
      shiny::req(nee_data)
      shiny::req(selected_strategy())

      nee_filtered <- nee_data |>
        dplyr::filter(.data$param_name == selected_strategy())

      shiny::validate(
        shiny::need(
          nrow(nee_filtered) > 0,
          paste(
            "This type of potentially-mitigatable activity (TPMA) was not part",
            "of the National Elicitation Exercise (NEE), so a",
            "nationally-determined estimate is not available."
          )
        )
      )

      plot_nee(nee_filtered)
    })
  })
}
