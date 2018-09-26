#
# read & analyse and export channel-asset configuration.
#
# BHE, 20-09-2018
#

library(XML)
library(tidyverse)

###############################################################################
# read data
###############################################################################
docType.xml <- 
  XML::xmlParse(file = "webapp.b2c/cmc2/xml/doctype_attributes.xml")

docType.df <- 
  XML:::xmlAttrsToDataFrame(getNodeSet(docType.xml, 
                                       path='/doctypes/doctype'))

colnames(docType.df)
glimpse(docType.df)

###############################################################################
# list data for specific export channel
###############################################################################

channelDocTypes.df <-
  docType.df %>%
  dplyr::filter(ICEcat == "yes") %>%
  dplyr::select(code, secureURL)
# 33 asset types

# check: voor ICEcat 33 asset types, zoals ook door Freek gevonden.

channelDocTypes.df <-
  docType.df %>%
  dplyr::filter(XCProducts == "yes") %>%
  dplyr::select(code) # , secureURL
 # 3 asset types

### THIS WORKS !!!

###############################################################################
# create a function to loop over all channels
#
# documentation:
#   - https://stackoverflow.com/questions/49786597/r-dplyr-filter-with-a-dynamic-variable-name
#
###############################################################################
var_ch <- "ICEcat"

# select unique channels from doctype_attributes.xml
var_channels <-
  colnames(docType.df)[10:length(colnames(docType.df))]

# create generic funtion:
listChannelDocTypes <- function(p_docTypes, p_channel) {
  channelDocTypes.df <-
    p_docTypes %>%
    dplyr::filter(!!rlang::sym(p_channel) == "yes") %>%
    dplyr::select(code, secureURL) %>%
    dplyr::mutate(channel = p_channel) %>%
    dplyr::select(channel, everything()) # move channel to first column position
  
  return(channelDocTypes.df)
}

# loop over channels
channelDocTypes.df <- 
  data.frame()

for (var_ch in var_channels) {

  channelDocTypes.df <-
    listChannelDocTypes(docType.df, var_ch) %>%
    dplyr::bind_rows(channelDocTypes.df)
}

# convert from long to wide format
channelDocTypes.wide.df <-
  channelDocTypes.df %>%
  dplyr::select(-secureURL) %>%
  dplyr::mutate(inUse = TRUE) %>%       # value-colomn required for spreading
  tidyr::spread(key = "channel",        # spread
                value = "inUse") %>%
  dplyr::select(SyndicationL1:SyndicationL5Assets, everything()) %>% # move syndication-levels to first column position
  dplyr::select(code, everything()) %>% # move code to first column position
  dplyr::arrange(code)

###############################################################################
# export processed data (in csv-format suitable for spreadsheet)
###############################################################################
channelDocTypes.wide.df %>%
  readr::write_excel_csv(path="./analyse/output/channelDocTypes.csv",
                         na = "")

channelDocTypes.wide.df %>%
  readr::write_csv(path="./analyse/output/channelDocTypes.csv",
                   na = "")
