#
# Investigative analysis of the consistency of STEP asset (relation) type 
#   definitions based on spreadsheets provided by Sabine with the metadata 
#   and an export from asset definitions from STEP.
#
# BHE, 29-05-2019
#

library(tidyverse)
library(readr)


###############################################################################
# read asset metadata from to-csv-format converted STEP-export
#
###############################################################################

asset.meta.r <-
  readr::read_csv(file = "./data/csv/620_STEP_assets_metadata.csv")
asset_specs.meta.r <-
  readr::read_csv(file = "./data/csv/620_STEP_asset_specs_metadata.csv")

glimpse(asset.meta.r)
glimpse(asset_specs.meta.r)

###############################################################################
# data cleaning
###############################################################################

asset.meta <-
  asset.meta.r %>%
  # add asset specs
  dplyr::right_join(asset_specs.meta.r, by = c("type", "id")) %>%
  # remove 'PHL' prefix
  dplyr::mutate(spec_id = stringr::str_remove(stringr::str_remove(spec_id, "PH-"), "Asset-"))
  

# save for future use:
saveRDS(asset.meta, file = "./data/STEP_assets/asset.meta.step.rds")

# DONE
#
# start matching with meta-data from Sabine's speradsheets