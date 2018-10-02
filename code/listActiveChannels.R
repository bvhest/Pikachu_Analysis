#
# list active channels (based on report by Freek Segers, sept 2018).
#
# additional functionality:
#    - list channel parameters.
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

activeChannels.df <-
  channels.df %>%
  # remove columns that are not relevant for filtering on active channels 
  # (in other code)
  dplyr::select(Channel) %>%
  # and convert to lowercase
  dplyr::rename(channel = Channel)

###############################################################################
# export processed data (in csv-format suitable for spreadsheet)
###############################################################################
activeChannels.df %>%
  readr::write_excel_csv(path="./analyse/output/activeChannels.csv",
                         na = "")

activeChannels.df %>%
  saveRDS(file = "./analyse/output/activeChannels.Rds")

###############################################################################
# continue processing
###############################################################################

# check parameter-list
channels.params.df <-
  channels.df %>%
  # remove irrelevant columns
  dplyr::select(Channel, Options) %>%
  # split options
  tidyr::separate(col = Options, 
                  into = c('par1', 'par2', 'par3', 'par4','par5', 'par6', 'par7', 'par8'), 
                  sep = "\r\n",
                  fill = "right",
                  remove = TRUE) %>%
  # from wide to long format
  tidyr::gather(key = remove,
                value = parameter, 
                na.rm = TRUE,
                par1:par8) %>%
  # remove unnecesarry columns
  dplyr::select(-remove) %>%
  # split parameter name and value
  tidyr::separate(col = parameter, 
                  into = c('parameter', 'value'), 
                  sep = "=",
                  fill = "right",
                  remove = TRUE) %>%
  # convert channel name to lower-case:
  dplyr::rename(channel = Channel) %>%
  # sort alphabetically
  dplyr::arrange(channel, parameter)

glimpse(channels.params.df)

# transpose into (wide) tabel/spreadsheet format
channels.params.wide.df <-
  channels.params.df %>%
  tidyr::spread(key = parameter,
                value = value)

# note: the same paramters ae present in both lower- and title-case !!

###############################################################################
# export processed data (in csv-format suitable for spreadsheet)
###############################################################################
channels.params.wide.df %>%
  readr::write_excel_csv(path="./analyse/output/channelParameters_fromOverview.csv",
                         na = "")

