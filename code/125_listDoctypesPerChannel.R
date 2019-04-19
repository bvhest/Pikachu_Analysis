#
# read & analyse and export channel-asset configuration.
#
# BHE, 20-09-2018
#

library(XML)
library(tidyverse)
library(rvest)

###############################################################################
# read data from file
###############################################################################
docTypeConfig.xml <- 
  XML::xmlParse(file = "webapp.b2c/cmc2/xml/doctype_attributes.xml")

docTypeConfig.df <- 
  XML:::xmlAttrsToDataFrame(XML::getNodeSet(docTypeConfig.xml, 
                                            path='/doctypes/doctype'))

colnames(docTypeConfig.df)
glimpse(docTypeConfig.df)

activeChannels.df <-
  readRDS(file = "./analyse/output/activeChannels.Rds")

# read doctype names directly from ccr website:
# http://pww.ccr.philips.com/cgi-bin/newmpr/conf_viewer.pl?confFile=doctypes.conf&sort=2

docTypesFile <-
  paste("./analyse/output","docTypes.Rds", sep = "/")

if (!file.exists(docTypesFile)) {
  url <- 
    "http://pww.ccr.philips.com/cgi-bin/newmpr/conf_viewer.pl?confFile=doctypes.conf&sort=2"
  url <- 
    "./code/data/ccr_doctypes.html"
  
  docTypes.r.df <- 
    url %>%
    xml2::read_html() %>%
    rvest::html_nodes('.tborder') %>%
    rvest::html_table(header = TRUE,
                      fill = TRUE)
  
  docTypes.df <- 
    docTypes.r.df[[1]]
  
  glimpse(docTypes.df)
  
  saveRDS(docTypes.df,
           file = docTypesFile)

} else {
  docTypes.df <-
    readRDS(file = docTypesFile)
}

# cleanup
remove(docTypesFile, docTypeConfig.xml)

###############################################################################
# list data for specific export channel
###############################################################################

# channelDocTypes.df <-
#   docType.df %>%
#   dplyr::filter(ICEcat == "yes") %>%
#   dplyr::select(code, secureURL)
# # 33 asset types

# check: voor ICEcat 33 asset types, zoals ook door Freek gevonden.

# channelDocTypes.df <-
#   docType.df %>%
#   dplyr::filter(XCProducts == "yes") %>%
#   dplyr::select(code) # , secureURL
#  # 3 asset types

### THIS WORKS !!!

###############################################################################
# create a function to loop over all channels
#
# documentation:
#   - https://stackoverflow.com/questions/49786597/r-dplyr-filter-with-a-dynamic-variable-name
#
###############################################################################
#var_ch <- "ICEcat"  # test-data

# select unique channels from doctype_attributes.xml
var_channels <-
  colnames(docTypeConfig.df)[10:length(colnames(docTypeConfig.df))]

# create generic funtion:
listChannelDocTypes <- 
  function(p_docTypes, p_channel) {
  channelDocTypes.df <-
    p_docTypes %>%
    dplyr::filter(!!rlang::sym(p_channel) == "yes") %>%
    dplyr::select(code, language, secureURL) %>%
    dplyr::mutate(channel = p_channel) %>%
    dplyr::select(channel, everything()) # move channel to first column position
  
  return(channelDocTypes.df)
}

# loop over channels
channelDocTypes.df <- 
  data.frame()

for (var_ch in var_channels) {

  channelDocTypes.df <-
    listChannelDocTypes(docTypeConfig.df, 
                        var_ch) %>%
    dplyr::bind_rows(channelDocTypes.df)
}

# remove inactive channels/keep active channels 
# (but also the syndication"-levels, which are virtual channels)
virtualChannels <-
  channelDocTypes.df %>%
  dplyr::select(channel) %>%
  dplyr::filter(grepl("Syndication", channel)) %>%
  dplyr::distinct(channel) %>%
  dplyr::arrange(channel)

activeChannels.df <-
  virtualChannels %>%
  dplyr::bind_rows(activeChannels.df)


# cleaned doctypes per channel:  
channelDocTypes.c.df <- 
  docTypeConfig.df %>%
  # remove unnecessary columns (keep code and name)
  dplyr::select(code, description) %>%
  # add asset name
  dplyr::left_join(channelDocTypes.df, by = "code") %>%
  # filter on active channels
  dplyr::right_join(activeChannels.df, by = "channel")

# convert from long to wide format
channelDocTypes.wide.df <-
  channelDocTypes.c.df %>%
  dplyr::select(-secureURL) %>%
  dplyr::mutate(inUse = TRUE) %>%       # value-colomn required for spreading
  tidyr::spread(key = "channel",        # spread
                value = "inUse") %>%
  dplyr::select(SyndicationL1:SyndicationL5Assets, everything()) %>% # move syndication-levels to first column position
  dplyr::select(code, description, everything()) %>% # move code to first column position
  dplyr::arrange(code)

# save this data for later use:
docTypesFile <-
  paste("./analyse/output","channelDocTypes.c.Rds", sep = "/")
saveRDS(channelDocTypes.c.df,
        file = docTypesFile)
docTypesFile <-
  paste("./analyse/output","channelDocTypes.wide.Rds", sep = "/")
saveRDS(channelDocTypes.wide.df,
        file = docTypesFile)

###############################################################################
# export processed data (in csv-format suitable for spreadsheet)
###############################################################################
channelDocTypes.wide.df %>%
  readr::write_excel_csv(path="./analyse/output/channelDocTypes.csv",
                         na = "")

