#' Application User Interface
#' @param request Internal parameter for 'shiny'.
#' @noRd
app_ui <- function(request) {
  bslib::page_sidebar(
    title = "Explore TPMA data (in development)",

    sidebar = bslib::sidebar(
      mod_select_provider_ui("mod_select_provider"),
      mod_select_strategy_ui("mod_select_strategy"),
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

    bslib::layout_columns(
      bslib::card(
        bslib::card_header("Description"),
        bslib::card_body(mod_show_strategy_text_ui(
          "mod_show_strategy_text"
        ))
      ),
      bslib::card(
        bslib::card_header("Rates Trend"),
        bslib::card_body(mod_plot_rates_trend_ui("mod_plot_rates_trend")),
        full_screen = TRUE
      ),
      bslib::card(
        bslib::card_header("Rates Funnel"),
        bslib::card_body(mod_plot_rates_funnel_ui("mod_plot_rates_funnel")),
        full_screen = TRUE
      ),
      bslib::card(
        bslib::card_header("Rates Box"),
        bslib::card_body(mod_plot_rates_box_ui("mod_plot_rates_box")),
        full_screen = TRUE
      )
    )
  )
}
