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
readRDS(file = "./data/STEP_assets/asset.meta.spreadsheet.rds")
readRDS(file = "./data/STEP_assets/asset.meta.step.rds")
