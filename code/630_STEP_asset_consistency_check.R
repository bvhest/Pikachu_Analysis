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
  readRDS(file = "./data/STEP_assets/asset.meta.spreadsheet.rds")
asset.metdata.impl <- 
  readRDS(file = "./data/STEP_assets/asset.meta.step.rds")

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

