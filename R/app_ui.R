#' Application User Interface
#' @param request Internal parameter for 'shiny'.
#' @noRd
app_ui <- function(request) {
  bslib::page_navbar(
    id = "page_navbar",
    title = "Explore opportunities to reduce hospital care",
    selected = "Overview",
    fillable = FALSE,
    header = shiny::tags$head(
      shiny::tags$style(shiny::HTML(
        "
        .matrix-container{
          width:100%;
          border-collapse:separate;
          border-spacing:14px;
          table-layout:fixed;
        }
        .col-header{
          padding:18px;
          text-align:center;
          border-radius:14px;
          font-weight:600;
          background:#E8EDEE;   /* NHS Light Grey */
          color:#425563;        /* NHS Dark Grey */
        }
        .cell{
          padding:6px;
          vertical-align:top;
        }
        .tpma-card{
          margin-bottom:4px;
          padding:10px 12px;
          border-radius:4px;
          border:1px solid #E8EDEE;
          background:#FFFFFF;
          position:relative;
        }

        .setting-tag{
          position:absolute;
          top:6px;
          right:8px;
          padding:2px 6px;
          border-radius:3px;
          background:#F3F2F1;
          font-size:11px;
          font-weight:700;
        }
        .tpma-name{
          padding-right:40px;
        }
        .tpma-ip{
          border-left:6px solid #28a197; /* Gov.uk teal */
        }
        .tpma-op{
          border-left:6px solid #F46A25; /* Gov.uk orange */
        }
        .tpma-ae{
          border-left:6px solid #A285D1; /* Gov.uk light purple */
        }
        .empty-cell{
          min-height:20px;
        }
      "
      ))
    ),

    sidebar = bslib::sidebar(
      id = "sidebar",
      open = "closed",
      width = 400,

      shiny::conditionalPanel(
        condition = "input.page_navbar == 'Overview'",
        bslib::card(
          md_file_to_html("app", "text", "sidebar-explanation.md")
        )
      ),

      shiny::conditionalPanel(
        condition = "input.page_navbar != 'Overview'",

        bslib::accordion(
          id = "sidebar_accordion",
          open = FALSE,
          multiple = TRUE,

          bslib::accordion_panel(
            title = "Datasets",
            icon = bsicons::bs_icon("table"),
            mod_select_geography_ui("mod_select_geography"),
            mod_select_provider_ui("mod_select_provider")
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
              title = "Bookmark your selections and get a URL for sharing"
            )
          )
        )
      )
    ),

    bslib::nav_panel(
      id = "Overview",
      title = "Overview",
      icon = bsicons::bs_icon("grid"),

      bslib::card(
        bslib::card_header(
          class = "text-bg-info",
          bsicons::bs_icon("info-circle"),
          "Note"
        ),
        "This app is in continuous development.",
        "Please give feedback by clicking the link in the top-right."
      ),

      bslib::card(
        bslib::card_header("TPMA Matrix"),
        shiny::uiOutput("tpma_table")
      )
    ),

    bslib::nav_panel(
      id = "nav_panel_context",
      title = "Context",
      icon = bsicons::bs_icon("book"),

      bslib::card(
        bslib::card_header(
          class = "text-bg-info",
          bsicons::bs_icon("info-circle"),
          "Note"
        ),
        "This app is in continuous development.",
        "Please give feedback by clicking the link in the top-right."
      ),

      bslib::layout_columns(
        col_widths = c(6, 6),

        bslib::card(
          id = "card_context_challenge",
          bslib::card_header("The challenge"),
          md_file_to_html("app", "text", "context-challenge.md")
        ),

        bslib::card(
          id = "card_context_tool",
          bslib::card_header("Explore opportunities"),
          md_file_to_html("app", "text", "context-tool.md")
        )
      ),

      bslib::layout_columns(
        col_widths = c(6, 6),

        bslib::card(
          id = "card_context_tpmas",
          bslib::card_header(
            "Types of Potentially Mitigatable Activity (TPMAs)"
          ),
          md_file_to_html("app", "text", "context-tpmas.md")
        ),

        bslib::card(
          id = "card_context_example",
          bslib::card_header("Example"),
          md_file_to_html("app", "text", "context-example.md")
        )
      ),

      bslib::layout_columns(
        col_widths = c(6, 6),

        bslib::card(
          id = "card_context_care_shift",
          bslib::card_header(
            "Opportunities to shift care from hospitals to community (care shift)"
          ),
          md_file_to_html("app", "text", "context-care-shift.md")
        ),

        bslib::card(
          id = "card_context_reduction",
          bslib::card_header("How much hospital activity can be reduced?"),
          md_file_to_html("app", "text", "context-reduction.md")
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
      icon = bsicons::bs_icon("info-circle"),

      bslib::card(
        bslib::card_header(
          class = "text-bg-info",
          bsicons::bs_icon("info-circle"),
          "Note"
        ),
        "This app is in continuous development.",
        "Please give feedback by clicking the link in the top-right."
      ),

      bslib::layout_columns(
        col_widths = c(6, 6),
        fill = FALSE,

        bslib::layout_columns(
          col_widths = 12,
          fill = FALSE,

          bslib::card(
            id = "card_info_data",
            bslib::card_header("Data"),
            md_file_to_html("app", "text", "info-data.md")
          ),

          bslib::card(
            id = "card_info_definitions",
            bslib::card_header("Definitions"),
            md_file_to_html("app", "text", "info-definitions.md")
          ),

          bslib::card(
            id = "card_info_author",
            bslib::card_header("Authors"),
            style = "display:inline;",
            md_file_to_html("app", "text", "info-author.md"),
            paste0(
              "Version ",
              as.character(utils::packageVersion(utils::packageName())),
              "."
            )
          )
        ),

        bslib::layout_columns(
          col_widths = 12,
          fill = FALSE,

          bslib::card(
            id = "card_info_navigation",
            bslib::card_header("Navigation"),
            md_file_to_html("app", "text", "info-navigation.md")
          ),

          bslib::card(
            id = "card_info_interface",
            bslib::card_header("Interface"),
            md_file_to_html("app", "text", "info-interface.md")
          )
        )
      )
    ),

    bslib::nav_item(
      class = "ms-auto",
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
