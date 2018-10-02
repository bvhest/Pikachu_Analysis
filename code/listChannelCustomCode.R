#
# read & list channel custom code.
#
# BHE, 26-09-2018
#

#library(XML)
library(tidyverse)

###############################################################################
# read data
###############################################################################

custom_code.r <-
  list.files(path = "./webapp.b2c/pipes/ProductExport/xsl",
             pattern = "*.xsl",
             full.names = TRUE,
             recursive = TRUE,
             include.dirs = FALSE)

activeChannels.df <-
  readRDS(file = "./analyse/output/activeChannels.Rds")

###############################################################################
# munge into desired format:
#   - list of channels, including custom-code (files) per channel
#   - sorted alphabetically
###############################################################################

custom_code.df <-
  custom_code.r %>%
  # map to data-frame and provide name for nameless column:
  as.data.frame(stringsAsFactors = FALSE) %>%
  dplyr::select(files = 1) %>%
  # remove common part of path:
  dplyr::mutate(files = stringr::str_remove(string = files, 
                                            pattern = "./webapp.b2c/pipes/ProductExport/xsl/")) %>%
  # split into export channel (= directory) and filename:
  tidyr::separate(col = files, 
                  into = c('channel', 'file'), 
                  sep = "/",
                  fill = "left",
                  remove = TRUE) %>%
  # filter out the process base stylesheets, keeping only the export specific code:
  dplyr::filter(!is.na(channel)) %>%
  # sort alphabetically
  dplyr::arrange(channel, file) %>%
  # clean-up data: remove backup files (funny that these have been created while using a version-repository)
  dplyr::filter(!stringr::str_detect(string = tolower(file),
                                     pattern = "backup")) %>%
  # remove inactive channels/keep active channels
  dplyr::right_join(activeChannels.df, by = "channel")

# convert from long to wide format
custom_code.wide.df <-
  custom_code.df %>%
  dplyr::mutate(inUse = TRUE) %>%       # value-colomn required for spreading
  tidyr::spread(key = "channel",        # spread
                value = "inUse")

###############################################################################
# export processed data (in csv-format suitable for spreadsheet)
###############################################################################
custom_code.wide.df %>%
  readr::write_excel_csv(path="./analyse/output/channelCustomCode.csv",
                         na = "")
