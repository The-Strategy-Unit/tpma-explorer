# tpma-explorer

<!-- badges: start -->
[![R-CMD-check](https://github.com/The-Strategy-Unit/tpma-explorer/actions/workflows/check.yaml/badge.svg)](https://github.com/The-Strategy-Unit/tpma-explorer/actions/workflows/check.yaml)
[![codecov](https://codecov.io/gh/The-Strategy-Unit/tpma-explorer/branch/main/graph/badge.svg)](https://codecov.io/gh/The-Strategy-Unit/tpma-explorer
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
)
<!-- badges: end -->

An app to explore opportunities to reduce hospital care, using data for Types of Potentially-Mitigatable Activity (TPMAs).

The app is [deployed openly to Posit Connect](https://connect.strategyunitwm.nhs.uk/tpma-explorer/) with no access requirements.

## For developers

This section is aimed at maintainers of the tool who work for The Strategy Unit Data Science team.

### Run and deploy

The app is made with [Shiny](https://shiny.posit.co/) and is an R package following [the nolem approach](https://github.com/StatsRhian/nolem).

To run the app, you must:

* create an `.Renviron` file from the `.Renviron.example` template (restart R after making changes to this file)
* run `devtools::install_deps(dependencies = TRUE)` to install required dependencies from the `DESCRIPTION`
* run `dev/app.R` to launch the app locally for development purposes
* run `dev/deploy.R` to deploy the app to Posit Connect when ready (to 'dev' following pull-requests, to 'prod' for releases)

### Data

Underlying data is generated via the NHP inputs-data pipeline in [the nhp_data repository](https://github.com/The-Strategy-Unit/nhp_data/) and is read into the app from the relevant Azure container (named in the `AZ_CONTAINER_INPUTS` environment variable).

### Files

In `R/` you can find:

* Shiny modules (server and UI components) that are stored in `mod_*.R` scripts
* functions to help prepare data in `utils_*.R` scripts
* logic for user facing outputs (plots, tables) in `fct_*.R` scripts

In `inst/` you can find:

* `golem-config.yaml`, which contains configuration (copied from [nhp_inputs](https://github.com/The-Strategy-Unit/nhp_inputs/blob/main/inst/golem-config.yml))
* lookup data files in `app/data/`
* Markdown files under `app/text/`, which contain body and tooltip text
