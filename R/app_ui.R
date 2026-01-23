#' Application User Interface
#' @param request Internal parameter for 'shiny'.
#' @noRd
app_ui <- function(request) {
  bslib::page_navbar(
    id = "page_navbar",
    title = "Explore potentially-mitigatable activity data",
    selected = "Visualisations", # start with this panel open
    fillable = FALSE, # allow page scroll

    bslib::nav_panel(
      id = "nav_panel_viz",
      title = "Visualisations",

      bslib::card(
        fill = FALSE,
        bslib::card_header(
          class = "bg-warning",
          bsicons::bs_icon("exclamation-triangle"),
          "Warning"
        ),
        "This app is in development and its output has not been verified.",
        "The information presented here should not be relied on as fact."
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
    ),

    bslib::nav_panel(
      id = "nav_panel_info",
      title = "Information",
      bslib::layout_columns(
        bslib::layout_columns(
          col_widths = c(12, 12),
          bslib::card(
            id = "card_purpose",
            bslib::card_header("Purpose"),
            md_file_to_html("app", "text", "info-purpose.md")
          ),
          bslib::card(
            id = "card_data",
            bslib::card_header("Definitions"),
            md_file_to_html("app", "text", "info-definitions.md")
          ),
          bslib::card(
            id = "card_data",
            bslib::card_header("Data"),
            md_file_to_html("app", "text", "info-data.md")
          )
        ),
        bslib::layout_columns(
          col_widths = c(12, 12),
          bslib::card(
            id = "card_navigation",
            bslib::card_header("Navigation"),
            md_file_to_html("app", "text", "info-navigation.md")
          ),
          bslib::card(
            id = "card_how_to_use",
            bslib::card_header("Interface"),
            md_file_to_html("app", "text", "info-interface.md")
          )
        )
      )
    ),

    bslib::nav_item(
      class = "ms-auto", # push to far-right
      tags$a(
        href = Sys.getenv("FEEDBACK_FORM_URL"),
        target = "_blank",
        class = "nav-link",
        bsicons::bs_icon("chat-dots"),
        "Give feedback"
      )
    ),

    sidebar = bslib::sidebar(
      bslib::accordion(
        id = "sidebar_accordion",
        open = FALSE,
        multiple = TRUE,
        bslib::accordion_panel(
          title = "Datasets",
          icon = bsicons::bs_icon("table"),
          mod_select_geography_ui("mod_select_geography"),
          mod_select_provider_ui("mod_select_provider"),
        ),
        bslib::accordion_panel(
          title = "Types of potentially mitigatable activity (TPMAs)",
          icon = bsicons::bs_icon("hospital"),
          mod_select_strategy_ui("mod_select_strategy")
        )
      )
    )
  )
}
