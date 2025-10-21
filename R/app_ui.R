#' The application User-Interface
#' @param request Internal parameter for shiny.
#' @noRd
app_ui <- function(request) {
  bslib::page_sidebar(
    title = "TPMA Explorer",
    sidebar = bslib::sidebar(
      shiny::selectInput(
        "provider_select",
        "Choose a provider:",
        choices = NULL
      ),
      shiny::selectInput(
        "strategy_select",
        "Choose a strategy:",
        choices = NULL
      )
    ),

    bslib::card(
      fill = FALSE,
      bslib::card_header(
        class = "bg-warning",
        bsicons::bs_icon("exclamation-triangle"),
        "Warning"
      ),
      "This application is in development and its output has not been verified.
      The information presented here should not be relied on as fact."
    ),

    bslib::card(
      bslib::card_header("Trend in rates"),
      bslib::card_body(
        shiny::plotOutput("rates_plot")
      ),
      full_screen = TRUE
    )
  )
}
