The primary data source is [**Hospital Episode Statistics (HES)**](https://digital.nhs.uk/data-and-information/data-tools-and-services/data-services/hospital-episode-statistics).

Data is shown for a given **baseline** financial year, which is currently 2023/24, though trend information is also shown.
Counts of less than five are **suppressed**.

The data was **prepared** as part of the modelling process for the New Hospital Programme (NHP).
The [model project information website](https://connect.strategyunitwm.nhs.uk/nhp/project_information/) contains further details, such as [age-sex standardisation](https://connect.strategyunitwm.nhs.uk/nhp/project_information/modelling_methodology/activity_mitigators/direct_standardisation_of_tpmas.html) of TPMAs and how we [derive hospital catchments](https://connect.strategyunitwm.nhs.uk/nhp/project_information/data_extraction/deriving_hospital_catchments.html) for rate calculations.
You can find the Python source code in [the inputs_data scripts](https://github.com/The-Strategy-Unit/nhp_data/tree/main/src/nhp/data/inputs_data) of [the open nhp_data GitHub repository](https://github.com/The-Strategy-Unit/nhp_data).
