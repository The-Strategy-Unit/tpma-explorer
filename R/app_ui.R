#' Application User Interface
#' @param request Internal parameter for 'shiny'.
#' @noRd
app_ui <- function(request) {
  bslib::page_sidebar(
    title = "Explore potentially-mitigatable activity data (in development)",
    fillable = FALSE, # allow page scroll

    sidebar = bslib::sidebar(
      bslib::accordion(
        id = "sidebar-accordion",
        open = TRUE,
        multiple = TRUE,
        bslib::accordion_panel(
          title = "Statistical units",
          icon = bsicons::bs_icon("pin-map"),
          mod_select_geography_ui("mod_select_geography"),
          mod_select_provider_ui("mod_select_provider"),
        ),
        bslib::accordion_panel(
          title = "Types of potentially mitigatable activity (TPMAs)",
          icon = bsicons::bs_icon("hospital"),
          mod_select_strategy_ui("mod_select_strategy")
        )
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

    bslib::layout_columns(
      col_widths = c(3, 9),
      fill = FALSE,
      fillable = FALSE,
      mod_show_strategy_text_ui("mod_show_strategy_text"),
      bslib::layout_column_wrap(
        width = 1,
        gap = "0.8rem",
        mod_plot_rates_ui("mod_plot_rates"),
        bslib::layout_column_wrap(
          width = 1 / 2,
          mod_table_procedures_ui("mod_table_procedures"),
          mod_table_diagnoses_ui("mod_table_diagnoses")
        ),
        bslib::layout_column_wrap(
          width = 1 / 2,
          mod_plot_age_sex_pyramid_ui("mod_plot_age_sex_pyramid"),
          mod_plot_nee_ui("mod_plot_nee")
        ),
      )
    )
  )
}
