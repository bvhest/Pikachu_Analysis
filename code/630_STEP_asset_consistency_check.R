#
# Investigative analysis of the consistency of STEP asset (relation) type 
#   definitions based on spreadsheets provided by Sabine with the metadata 
#   and an export from asset definitions from STEP.
#
# BHE, 29-05-2019
#

# start matching with data exported from STEP

library(tidyverse)

# load data
asset.metdata.def <- 
  readRDS(file = "./data/STEP/assets/metadata/spreadsheet_asset_metadata.rds")
for (env in c(env1 , env2)) {
  
  asset.metdata.impl <- 
    readRDS(file = paste0("./data/STEP/assets/",env,"/step_asset_metadata.rds"))

  # how many unique assets?
  # defined
  asset.metdata.def %>%
    dplyr::distinct(doctype) %>%
    dplyr::count()
  # 197
  
  # implemented
  asset.metdata.impl %>%
    dplyr::filter(type == "asset") %>%
    dplyr::distinct(id) %>%
    dplyr::count()
  # 119
  
  # implemented relations (= number of doctypes)
  asset.metdata.impl %>%
    dplyr::filter(type == "asset") %>%
    dplyr::distinct(doctype) %>%
    dplyr::count()
  # 145
  
  # merge the two collections: 
  #   1. check missing implementations
  asset.metdata.def %>%
    dplyr::select(doctype) %>%
    dplyr::distinct(doctype) %>%
    dplyr::anti_join(asset.metdata.impl, by = "doctype") %>%
    dplyr::select(doctype) %>%
    dplyr::distinct(doctype)
  # 45 doctypes defined, but not implemented in STEP...
  
  #   2. check implementations without definition
  asset.metdata.impl %>%
    dplyr::select(doctype) %>%
    dplyr::distinct(doctype) %>%
    dplyr::anti_join(asset.metdata.def, by = "doctype") %>%
    dplyr::select(doctype) %>%
    dplyr::distinct(doctype)
  # 6 doctypes implemented, yet not defined
  
  # assets that are represented by different doctypes
  asset.metdata.impl %>%
    dplyr::filter(type == "asset") %>%
    dplyr::select(id, doctype, name) %>%
    dplyr::distinct(id, doctype, name) %>%
    dplyr::group_by(id) %>%
    dplyr::mutate(count_doctype = n()) %>%
    dplyr::filter(count_doctype > 1) %>%
    dplyr::arrange(desc(count_doctype))
  
  ################################################################################
  # check on completeness of implementation vs definition
  ################################################################################
  
  # product beauty shot (PBP=Productbeautyshot)
  asset.metdata.def %>%
    dplyr::filter(doctype == "PBP")
  
  asset.metdata.impl %>%
    dplyr::filter(type == "asset" & id == "Productbeautyshot")
  
  # filter the definition on the input values. 
  # These need to be compared with those in STEP.
  def <-
    asset.metdata.def %>%
    dplyr::filter(doctype == "PBP") %>%
    dplyr::filter(grepl(pattern = "XMLGEN_input", AssetConfigurationAutomation))

}
