# tpma-explorer

[![Project Status: Concept – Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)

An app to explore data for Types of Potentially-Mitigatable Activity (TPMAs).

The app is [deployed to Posit Connect](https://connect.strategyunitwm.nhs.uk/tpma-explorer/) (login and permissions required).

## For developers

To run the app, you must:

* create an `.Renviron` file from the `.Renviron.example` template
* run `devtools::install_deps(dependencies = TRUE)` to install required dependencies from the `DESCRIPTION`
* run `dev/app.R` to launch the app locally for development purposes
* run `dev/deploy.R` to deploy the app to Posit Connect when ready

The app is made with [Shiny](https://shiny.posit.co/) and is an R package following [the nolem approach](https://github.com/StatsRhian/nolem). In `R/`:

* Shiny modules (server and UI components) are stored in `mod_*.R` scripts
* functions to help prepare data are in `utils_*.R` scripts
* logic for user facing outputs (plots, tables) are in `fct_*.R` scripts
