#' Server-Side Application
#' @param input,output,session Internal parameters for 'shiny'.
#' @noRd
app_server <- function(input, output, session) {
  # Constants ----
  BASE_SIZE <- 16 # scaling for plot elements

  # User inputs ----
  selected_geography <- mod_select_geography_server(
    "mod_select_geography"
  )
  selected_provider <- mod_select_provider_server(
    "mod_select_provider",
    selected_geography
  )
  selected_strategy <- mod_select_strategy_server(
    "mod_select_strategy"
  )
  selected_year <- shiny::reactive({
    as.numeric(Sys.getenv("BASELINE_YEAR", 202324))
  })

  # Open sidebar ---
  # Sidebar options only relevant to visualisations and overview
  shiny::observe({
    if (input$page_navbar %in% c("Overview", "Visualisations")) {
      bslib::toggle_sidebar("sidebar", open = TRUE)
    } else {
      bslib::toggle_sidebar("sidebar", open = FALSE)
    }
  }) |>
    shiny::bindEvent(input$page_navbar)

  # Open sidebar accordions ----
  shiny::observe({
    # Data must load before accordions open
    shiny::req(selected_provider())
    shiny::req(selected_strategy())
    bslib::accordion_panel_open(id = "sidebar_accordion", values = TRUE)
  })

  tpmas <- readr::read_csv(
    "https://raw.githubusercontent.com/The-Strategy-Unit/TPMAs/fcc86e34b109451326385a332e89992add443ccc/reference/tpma-lookup.csv"
  ) |>
    dplyr::filter_out(.data$active_to == "NA") |>
    dplyr::distinct(
      .data$activity_type,
      .data$tpma_mechanism,
      .data$tpma_name
    )

  mechanism_order <- c(
    "Prevention",
    "De-adoption",
    "Redirection/Substitution",
    "Hospital Efficiency"
  )

  mechanism_labels <- c(
    "Prevention" = "Prevention",
    "De-adoption" = "De-adoption",
    "Redirection/Substitution" = "Redirection / substitution",
    "Hospital Efficiency" = "Efficiency"
  )

  setting_classes <- c(
    "IP" = "tpma-ip",
    "OP" = "tpma-op",
    "A&E" = "tpma-ae"
  )

  # Fewer in number appear towards the top of category lanes
  setting_order <- c("OP", "A&E", "IP")

  tpma_card <- function(label, css_class, setting) {
    tag_class <- dplyr::case_when(
      setting == "IP" ~ "tag-ip",
      setting == "OP" ~ "tag-op",
      setting == "A&E" ~ "tag-ae"
    )

    div(
      class = "tpma-card",
      div(class = paste("tpma-tag", tag_class), setting),
      div(class = "tpma-name", label)
    )
  }

  create_cell <- function(data, mechanism) {
    rows <- data |> dplyr::filter(.data$tpma_mechanism == mechanism)

    if (nrow(rows) == 0) {
      return(shiny::tags$td(class = "cell empty-cell"))
    }

    rows <- rows |>
      dplyr::mutate(setting_rank = match(.data$activity_type, setting_order)) |>
      dplyr::arrange(.data$setting_rank, .data$tpma_name)

    shiny::tags$td(
      class = "cell",
      lapply(
        split(rows, seq_len(nrow(rows))),
        function(row) {
          tpma_card(
            label = row$tpma_name,
            css_class = setting_classes[[row$activity_type]],
            setting = row$activity_type
          )
        }
      )
    )
  }

  mechanism_hint_files <- c(
    "Prevention" = "mechanism-prevention.md",
    "De-adoption" = "mechanism-deadoption.md",
    "Redirection/Substitution" = "mechanism-redirection-substitution.md",
    "Hospital Efficiency" = "mechanism-hospital-efficiency.md"
  )

  output$tpma_table <- shiny::renderUI({
    shiny::tags$table(
      class = "matrix-container",

      shiny::tags$thead(
        shiny::tags$tr(
          lapply(
            mechanism_order,
            function(mechanism) {
              tags$th(
                scope = "col",
                class = "col-header",
                tags$div(
                  class = "col-header-title",
                  mechanism_labels[[mechanism]]
                ),
                tags$div(
                  class = "col-header-hint",
                  md_file_to_html(
                    "app",
                    "text",
                    mechanism_hint_files[[mechanism]]
                  )
                )
              )
            }
          )
        )
      ),

      shiny::tags$tbody(
        shiny::tags$tr(
          lapply(
            mechanism_order,
            function(mechanism) {
              create_cell(tpmas, mechanism)
            }
          )
        )
      )
    )
  })

  # Modules ----
  mod_show_strategy_text_server(
    "mod_show_strategy_text",
    selected_strategy
  )

  mod_plot_rates_server(
    "mod_plot_rates",
    selected_geography,
    selected_provider,
    selected_strategy,
    selected_year,
    BASE_SIZE
  )
  mod_table_procedures_server(
    "mod_table_procedures",
    selected_geography,
    selected_provider,
    selected_strategy,
    selected_year
  )
  mod_table_diagnoses_server(
    "mod_table_diagnoses",
    selected_geography,
    selected_provider,
    selected_strategy,
    selected_year
  )
  mod_plot_age_sex_pyramid_server(
    "mod_plot_age_sex_pyramid",
    selected_geography,
    selected_provider,
    selected_strategy,
    selected_year,
    BASE_SIZE
  )
  mod_plot_nee_server(
    "mod_plot_nee",
    selected_strategy
  )

  # Reset cache with query param ?reset_cache=true
  # nocov start
  shiny::observe({
    shiny::req("su-data-science" %in% session$groups)

    u <- shiny::parseQueryString(session$clientData$url_search)

    shiny::req(!is.null(u$reset_cache)) # i.e. param value doesn't matter
    cat("reset cache\n")

    dc <- shiny::shinyOptions()$cache

    dc$reset()
  })
  # nocov end
}
