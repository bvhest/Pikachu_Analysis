#
# list restricted doctypes.
#
# BHE, 19-12-2018
#

library(XML)
library(tidyverse)
library(rvest)

###############################################################################
# read data from file
###############################################################################

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

colnames(docTypes.df)
glimpse(docTypes.df)

###############################################################################
# list restricted and public doctypes
###############################################################################

# correct column names (wrong in source)
docTypes.r.df <-
  docTypes.df %>%
  dplyr::rename(Restricted = Version,
                unknown = Doctype,
                MasterDoctype = 'Doc class',
                Doctype = Derivation,
                unknown2 = '',
                Format = Restricted)

glimpse(docTypes.r.df)

docTypes.c.df <-
  docTypes.r.df %>%
  # only keep master doctypes
  dplyr::filter(MasterDoctype == "") %>%
  # remove columns
  dplyr::select(Restricted, Doctype, `Long Description`, Format) %>%
  # sort by public y/n, doctype
  dplyr::arrange(Restricted, Doctype)


###############################################################################
# save results
###############################################################################
docTypesFile <-
  paste("./analyse/output","docTypes.conf.Rds", sep = "/")

saveRDS(docTypes.c.df, file = docTypesFile)
