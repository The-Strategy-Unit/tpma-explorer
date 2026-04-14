#' Application User Interface
#' @param request Internal parameter for 'shiny'.
#' @noRd
app_ui <- function(request) {
  bslib::page_navbar(
    id = "page_navbar",
    title = "Explore opportunities to reduce hospital care",
    selected = "Visualisations", # start with this panel open
    fillable = FALSE, # allow page scroll

    sidebar = bslib::sidebar(
      id = "sidebar",
      open = "closed",
      width = 400,
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
          title = "Types of Potentially-Mitigatable Activity (TPMAs)",
          icon = bsicons::bs_icon("hospital"),
          mod_select_strategy_ui("mod_select_strategy")
        ),
        bslib::accordion_panel(
          title = "Bookmark",
          icon = bsicons::bs_icon("bookmark"),
          shiny::bookmarkButton(
            label = "Generate shareable URL",
            title = "Bookmark your selections and get a URL for sharing",
            icon = NULL
          )
        )
      )
    ),

    bslib::nav_panel(
      id = "nav_panel_viz",
      title = "Visualisations",
      icon = bsicons::bs_icon("graph-up"),

      bslib::card(
        bslib::card_header(
          class = "text-bg-info",
          bsicons::bs_icon("info-circle"),
          "Note"
        ),
        "This app is in continuous development.",
        "Please give feedback by clicking the link in the top-right."
      ),
      mod_show_strategy_text_ui("mod_show_strategy_text"),
      mod_plot_rates_ui("mod_plot_rates"),
      bslib::layout_columns(
        col_widths = c(6, 6),
        mod_table_diagnoses_ui("mod_table_diagnoses"),
        mod_table_procedures_ui("mod_table_procedures")
      ),
      bslib::layout_columns(
        col_widths = c(6, 6),
        mod_plot_age_sex_pyramid_ui("mod_plot_age_sex_pyramid"),
        mod_plot_nee_ui("mod_plot_nee")
      )
    ),

    bslib::nav_panel(
      id = "nav_panel_info",
      title = "Information",
      icon = bsicons::bs_icon("book"),

      bslib::layout_columns(
        col_widths = c(6, 6),
        fill = FALSE,
        bslib::layout_columns(
          col_widths = 12,
          fill = FALSE,
          bslib::card(
            id = "card_purpose",
            bslib::card_header("Purpose"),
            md_file_to_html("app", "text", "info-purpose.md")
          ),
          bslib::card(
            id = "card_related",
            bslib::card_header("Related"),
            md_file_to_html("app", "text", "info-related.md")
          ),
          bslib::card(
            id = "card_data",
            bslib::card_header("Data"),
            md_file_to_html("app", "text", "info-data.md")
          ),
          bslib::card(
            id = "card_data",
            bslib::card_header("Definitions"),
            md_file_to_html("app", "text", "info-definitions.md")
          )
        ),
        bslib::layout_columns(
          col_widths = 12,
          fill = FALSE,
          bslib::card(
            id = "card_navigation",
            bslib::card_header("Navigation"),
            md_file_to_html("app", "text", "info-navigation.md")
          ),
          bslib::card(
            id = "card_how_to_use",
            bslib::card_header("Interface"),
            md_file_to_html("app", "text", "info-interface.md")
          ),
          bslib::card(
            id = "card_author",
            bslib::card_header("Authors"),
            style = "display:inline;", # put items on the same line
            md_file_to_html("app", "text", "info-author.md"),
            paste0(
              "Version ",
              as.character(utils::packageVersion(utils::packageName())),
              "."
            )
          )
        )
      )
    ),

    bslib::nav_item(
      class = "ms-auto", # push to far-right
      shiny::tags$a(
        href = Sys.getenv("FEEDBACK_FORM_URL"),
        target = "_blank",
        class = "nav-link",
        bsicons::bs_icon("chat-dots"),
        "Give feedback"
      )
    )
  )
}
