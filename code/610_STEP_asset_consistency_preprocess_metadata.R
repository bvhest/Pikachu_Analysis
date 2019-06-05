#
# Investigative analysis of the consistency of STEP asset (relation) type 
#   definitions based on spreadsheets provided by Sabine with the metadata 
#   and an export from asset definitions from STEP.
#
# BHE, 23-05-2019
#

library(tidyverse)
library(readxl)


###############################################################################
# read asset metadata from spreadsheet
#
# note: 
#   - replaced spaces in file-name with underscores.
#   - copied row 4 to new row 9.
#   - added headers to row 9, columns E & F: "Excel Metadata maintain", "Excel Metadata config"
#   - removed space in column name 'Doctype '
###############################################################################

asset.meta <-
  readxl::read_xlsx(path = "./data/STEP_assets/STEP_Asset_Type_Definition_Agreements_021.xlsx",
                    sheet = 3, # sheet "CMC2PIL Mapping"
                    skip = 8
                    )

glimpse(asset.meta)

###############################################################################
# data cleaning
#
# The spreadsheet has been lay-outed for readibility, not for tidy data. The 
# data frame contains many empty cels that shoould have contained repeated 
# values from the previous cels. 
# See solution on https://markhneedham.com/blog/2015/06/28/r-dplyr-update-rows-with-earlierprevious-rows-values/
###############################################################################
library(zoo)

asset.meta.c <-
  asset.meta %>% 
  mutate(Type = na.locf(Type))

glimpse(asset.meta.c)

# what is relevant?
# 1) at least the values in the column "DocType" (which should be interpreted as 
#   "Characteristics") and the columns from position 6 to 202 (the individual 
#   doctypes). 
#   So a transformation from wide to long is required.
# 2) the rows that start with a value "XMLGEN_*"
#   So a filtering is required

asset.meta.c <-
  asset.meta.c %>%
  # cleanup some columnnames:
  dplyr::rename(characteristic = Doctype,
                AssetConfigurationAutomation = 'Asset Configuration Automation',
                ExcelMetadataMaintain = 'Excel Metadata maintain',
                ExcelMetadataConfig = 'Excel Metadata config') %>%
  dplyr::filter(grepl("XMLGEN",AssetConfigurationAutomation)) %>%
  tidyr::gather(data = .,
                key = doctype,
                value = value,
                AEC:YOU)
  
# what is irrelevant?
# 1) those rows where both the "Characteristics" and the "value" are 'NA'.

asset.meta.c <-
  asset.meta.c %>%
  dplyr::filter(!(is.na(characteristic) & is.na(value)))

# make more readable by reshufling columns
asset.meta.c <-
  asset.meta.c %>%
  dplyr::select(doctype, characteristic, value, everything())

# filter out 2nd occurences of some doctype definitions
asset.meta.c <-
  asset.meta.c %>%
  # start wth filtering out shitty data
  dplyr::filter(!(doctype %in% c("...", "...94"))) %>%
  tidyr::separate(doctype, into = c("doctype", "doctype_rank"), sep = 3) %>%
  # now remove the stupid "..." separator
  dplyr::mutate(doctype_rank = stringr::str_remove(doctype_rank, pattern = "...")) %>%
  # and only keep the lowest 'rank' (= the data from the spreadsheet column with lowest rank)
  dplyr::group_by(doctype) %>%
  dplyr::filter(doctype_rank == max(doctype_rank)) %>%
  # and remove rakn-column (no longer required)
  dplyr::select(-doctype_rank)

# save for future use:
saveRDS(asset.meta.c, file = "./data/STEP_assets/asset.meta.spreadsheet.rds")

# DONE
#
# start matching with data exported from STEP

