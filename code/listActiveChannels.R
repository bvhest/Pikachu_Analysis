#
# list active channels (based on report by Freek Segers, sept 2018).
#
# BHE, 26-09-2018
#

#library(XML)
library(tidyverse)
library(readxl)

###############################################################################
# read spreadsheet
###############################################################################

channels.r <-
  readxl::read_xlsx(path = "./analyse/Channel_overview.xlsx",
                    sheet = 1, 
                    skip = 0)

###############################################################################
# clean data
###############################################################################

channels.df <-
  channels.r %>%
  # remove rubish-row
  dplyr::filter(Channel != "Pikachu B2C") %>% 
  # remove inactive channels
  dplyr::filter(is.na(Enabled))

###############################################################################
# export processed data (in csv-format suitable for spreadsheet)
###############################################################################
channels.df %>%
  readr::write_excel_csv(path="./analyse/output/activeChannels.csv",
                         na = "")

channels.df %>%
  saveRDS(file = "./analyse/output/activeChannels.Rds")
