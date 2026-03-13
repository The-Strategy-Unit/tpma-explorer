# Generate a lookup of care-shift TPMA groupings

# Set file paths ----

# Lookup provided via Sharepoint
# https://github.com/The-Strategy-Unit/tpma-explorer/issues/130#issuecomment-3915631889
cs_path <- "Groupings for care shift(Sheet1).csv" # adjust path if needed

# Some of the TPMA names in the provided lookup are out of date. We can use the
# TPMA lookup from Project Information to match in the correct names:
# https://connect.strategyunitwm.nhs.uk/nhp/project_information/user_guide/mitigators_lookup.html
pi_path <- "data.csv" # adjust path if needed

# Create lookup ----

cs_lookup_provided <- readr::read_csv(cs_path, col_types = "c") |>
  dplyr::mutate(
    code = Code,
    care_shift_name = `Sub category`,
    .keep = "none"
  )

pi_lookup <- readr::read_csv(pi_path, col_types = "c") |>
  dplyr::filter(To == "-") |> # filter out deprecated TPMAs
  dplyr::select(code = Code, strategy = Variable)

cs_lookup <- dplyr::full_join(pi_lookup, cs_lookup_provided, by = "code") |>
  dplyr::mutate(
    care_shift_name = dplyr::if_else(
      is.na(care_shift_name),
      "Other",
      care_shift_name
    ),
    care_shift_category = stringr::str_to_snake(care_shift_name)
  ) |>
  dplyr::select(strategy, care_shift_category, care_shift_name)

readr::write_csv(cs_lookup, "inst/app/data/mitigators-care-shift.csv")
