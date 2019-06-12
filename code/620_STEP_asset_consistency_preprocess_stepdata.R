#
# Investigative analysis of the consistency of STEP asset (relation) type 
#   definitions based on spreadsheets provided by Sabine with the metadata 
#   and an export from asset definitions from STEP.
#
# BHE, 29-05-2019, 11-06-2019
#

library(tidyverse)
library(readr)

# process the data exported from the different STEP environments:
for (env in c("dev" , "tst")) {
  
  ###############################################################################
  # read asset metadata from "to-csv-format" converted STEP-export
  #
  ###############################################################################
  
  filename <- 
    paste0("./data/csv/",env,"/620_STEP_assets_metadata.csv")
  asset.meta.r <-
    readr::read_csv(file = filename)
  filename <- 
    paste0("./data/csv/",env,"/620_STEP_asset_specs_metadata.csv")
  asset_specs.meta.r <-
    readr::read_csv(file = filename)
  
  glimpse(asset.meta.r)
  glimpse(asset_specs.meta.r)
  
  ###############################################################################
  # data cleaning
  ###############################################################################
  
  asset.reference.c <-
    asset.meta.r %>%
    # filter on asset-reference-type
    dplyr::filter(type == 'asset-ref')
  
  asset.meta <-
    asset.meta.r %>%
    # filter on asset-type
    dplyr::filter(type == 'asset') %>%
    # add asset specs
    dplyr::right_join(asset_specs.meta.r, by = c("type", "id")) %>%
    # remove 'PHL' prefix
    dplyr::mutate(spec_id = stringr::str_remove(stringr::str_remove(spec_id, "PH-"), "Asset-"))
  
  asset.meta.c <-
    # join asset-metadata with asset-reference to
    #   - get doctype (defined on the relation, not on the asset)
    #   - get cardinality of the asset-assetref relation
    #nb. prevent too many double names, so sub-select columns (needs an inversion of processing of the tables)
    asset.reference.c %>%
    dplyr::select(id, parentID) %>%
    dplyr::rename(doctype = id) %>%
    dplyr::right_join(asset.meta, by = c("parentID" = "id")) %>%
    # clean-up mess of column names
    dplyr::rename(id = parentID) %>%
    dplyr::select(-parentID.y) %>%
    # reshuffle order of columns
    dplyr::select(type, id, doctype, everything())
  
  # save for future use:
  filename <- 
    paste0("./data/STEP_assets/",env,"/asset.meta.step.rds")
  saveRDS(asset.meta.c, file = filename)
  filename <- 
    paste0("./data/STEP_assets/",env,"/asset-references.meta.step.rds")
  saveRDS(asset.reference.c, file = filename)
}

# DONE
#
# start matching with meta-data from Sabine's speradsheets
