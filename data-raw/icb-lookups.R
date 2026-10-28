# Prepare raw code/name lookup (2023) ----

# Data source from the ONS Open Geography Portal:
#   https://geoportal.statistics.gov.uk/datasets/ons::integrated-care-boards-april-2026-names-and-codes-in-en/about

names_lkup_resource <-
  "https://services1.arcgis.com/ESMARspQHYMw9BZ9/ArcGIS/rest/services/ICB_APR_2026_EN_NC/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson"

# Consider pagination in future if required
names_lkup_resp <- names_lkup_resource |>
  httr2::request() |>
  httr2::req_perform() |>
  httr2::resp_body_json()

names_lkup <- purrr::map(
  names_lkup_resp[["features"]],
  \(icb) {
    props <- icb[["properties"]]
    cd <- props[["ICB26CDH"]]
    nm_prep <- props[['ICB26NM']] |>
      stringr::str_remove(" Integrated Care Board$") |>
      stringr::str_remove("^NHS ")
    nm <- glue::glue("{nm_prep} ({cd})")
    setNames(nm, cd)
  }
) |>
  unlist() |>
  sort() |> # alphabetise by name
  as.list()

jsonlite::write_json(
  names_lkup,
  "inst/app/reference/icb-datasets.json",
  auto_unbox = TRUE,
  pretty = TRUE
)


# Prepare peers lookup ----

# There aren't 'peers' for ICBs, so for now we return a dummy file.

icb_lkup <- yyjsonr::read_json_file("inst/app/reference/icb-datasets.json")

icb_codes <- names(icb_lkup)
icb_peers <- data.frame(procode = icb_codes, peer = icb_codes)

readr::write_csv(icb_peers, "inst/app/reference/icb-peers.csv")
