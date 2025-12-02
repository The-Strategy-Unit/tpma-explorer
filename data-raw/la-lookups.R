# Prepare raw code/name lookup ----

# Data source from the ONS Open Geography Portal:
#   https://geoportal.statistics.gov.uk/datasets/ons::local-authority-districts-april-2025-names-and-codes-in-the-uk-v2/about

names_lkup_resource <-
  "https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/LAD_APR_2025_UK_NC_v2/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson"

names_lkup_resp <- names_lkup_resource |>
  httr2::request() |>
  httr2::req_perform() |>
  httr2::resp_body_json()

names_lkup <- purrr::map(
  names_lkup_resp[["features"]],
  \(la) {
    props <- la[["properties"]]
    cd <- props[["LAD25CD"]]
    nm <- glue::glue("{props[['LAD25NM']]} ({cd})")
    setNames(nm, cd)
  }
) |>
  unlist() |>
  as.list() |>
  purrr::keep_at(\(la) stringr::str_detect(la, "^E")) # keep England only

jsonlite::write_json(
  names_lkup,
  "inst/app/data/la-datasets.json",
  auto_unbox = TRUE,
  pretty = TRUE
)

# Prepare raw neighbours data ----

# Download manually the file from the ONS:
#   https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/healthandwellbeing/adhocs/3048statisticalnearestneighboursforenglishuppertierandlowertierlocalauthorities

la_nbrs_path <- "localauthoritynearestneighboursengland.xlsx"

nbrs_lkup <- readxl::read_xlsx(
  la_nbrs_path,
  sheet = "Table 1",
  col_types = "text",
  skip = 3, # ignore titles and notes
  trim_ws = TRUE
) |>
  dplyr::mutate(
    # self as neighbour for plotting purposes
    `Neighbour 0` = `Lower tier local authority code`,
    .before = "Neighbour 1"
  ) |>
  dplyr::rename(procode = "Lower tier local authority code") |> # standardise
  dplyr::select(-"Lower tier local authority name") |>
  tidyr::pivot_longer(
    # pivot from a column-per-neighbour to a row per focus/neighbour
    tidyselect::starts_with("Neighbour"),
    names_to = NULL, # will be arranged by nearest neighbour first
    values_to = "peer"
  ) |>
  dplyr::group_by(procode) |>
  dplyr::slice(1:11) |> # self and 10 peers
  dplyr::ungroup()

readr::write_csv(nbrs_lkup, "inst/app/data/la-peers.csv")
