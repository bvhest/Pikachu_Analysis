#
# run the complete STEP asset metadata comparison between two given environments.
#
# BHE, 18-06-2019
#

###############################################################################
# install required libraries (if not yet installed)
###############################################################################
required_packages <- 
  c("tidyverse", "readr", "readxl", "compareDF")
new_packages <- 
  required_packages[!(required_packages %in% installed.packages()[,"Package"])]

if(length(new_packages) > 0) 
  install.packages(new_packages)

###############################################################################
# define environments
#   options: [dev, tst, acc, prd]
###############################################################################
env1 <- "tst"
env2 <- "acc"

###############################################################################
# call scripts
###############################################################################

# setup target directories (if not yet available)
# assumptions:
#   1. directories ./data/STEP/assets exists
#   2. the STEP XML export per environment is available in a subdirectory with 
#      the name of the environment. 
#      Example: ./data/STEP/assets/dev/STEP_asset_definitions_20190612.xml
source("./code/605_prepare_analysis_environment.R")
if(!succesfull) stop(message)

# transform STEP-XML into format that can be imported into R
source("./code/610_prepare_STEP_asset_metadata.R")
if(!succesfull) stop(message)

# process asset metadata from STEP (based on step 610)
source("./code/615_STEP_asset_consistency_preprocess_step_metadata.R")
if(!succesfull) stop(message)

# process asset metadata from spreadsheet
source("./code/620_STEP_asset_consistency_preprocess_spreadsheet_metadata.R")
if(!succesfull) stop(message)

# perform a comparison between the two provided environments and output the 
#   differences as html-tables
source("./code/640_STEP_asset_definitions_delta_between_environments.R")
if(!succesfull) stop(message)
