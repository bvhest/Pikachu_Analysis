#
# list download of doctypes from P4C.
#
# note: real usage can/will be larger as Akamai requests these documents when it 
# can't find them in its local cache (with 12 hours retention).
#
# BHE, 19-12-2018
#

library(XML)
library(tidyverse)

#
# he log-file contains the download requests for one day.
#
# FORMAAT: pipe-seaparated
# 3 product
# 4 taal 
# 5 land

# file contains 271 unique doctypes (691000 requests)

###############################################################################
# read data from file
###############################################################################
docTypeDownloads.r.df <- 
  readr::read_delim(file = "./code/data/p4c_downloads/downloads_log.20181218", 
                    delim = "|",
                    col_names = c("ip","user","product","doctype","language","country","url",
                                  "c8","c9","c10","c11","c12","c13","c14","c15","c16","c17","c18"))

colnames(docTypeDownloads.r.df)
glimpse(docTypeDownloads.r.df)

###############################################################################
# check most-frequently requested downloads from P4C
###############################################################################

docTypeDownloads.c.df <- 
  docTypeDownloads.r.df %>%
  dplyr::select(ip,user,product,doctype,language,country,url,c14,c16)

# download summary:
docTypeDownloads.c.df %>%
  dplyr::summarise(count_uniqueDoctypes = length(unique(doctype)),
                   count_languages = length(unique(language)),
                   count_countries = length(unique(country)),
                   count_products = length(unique(product)),
                   count_ip_addresses = length(unique(ip)),
                   count_urls = length(unique(url)))
# # A tibble: 1 x 5
# count_uniqueDoctypes count_languages count_countries count_products count_ip_addresses count_urls
#                <int>           <int>           <int>          <int>              <int>      <int>
# 1                271             105              59          86910                103        477

# downloads per doctype:
docTypeDownloads.c.df %>%
  dplyr::count(doctype, sort = TRUE) %>%
  head(20)

###############################################################################
# save results
###############################################################################

docTypesFile <-
  paste("./analyse/output","docType_P4Cdownloads.Rds", sep = "/")

saveRDS(docTypeDownloads.c.df, file = docTypesFile)

###############################################################################
# merge results with info on restricted documents
###############################################################################
docTypesFile <-
  paste("./analyse/output","docTypes.conf.Rds", sep = "/")

docTypes.c.df <-
  readRDS(file = docTypesFile)

remove(docTypesFile, docTypeDownloads.r.df)

colnames(docTypes.c.df) <-
  tolower(colnames(docTypes.c.df))

# make data readible/presentable
docTypes.c.df <-
  docTypes.c.df %>%
  dplyr::mutate(restricted = dplyr::if_else(restricted == 0, 'true', 'false'))

# merge data
docTypeDownloads.m.df <-
  docTypeDownloads.c.df %>%
  dplyr::left_join(docTypes.c.df, by = "doctype") %>%
  dplyr::rename(longDescription = `long description`)


# and analyse restricted document usage
docTypeDownloads.m.df %>%
  dplyr::count(restricted, sort = TRUE)
# # A tibble: 3 x 2
# restricted       n
#      <chr>   <int>
# 1     true  468226
# 2    false  161327
# 3       NA    1389


# top downloaded doctypes with restriction-indicator:
docTypeDownloads.m.df %>%
  dplyr::count(restricted, doctype, longDescription, sort = TRUE) %>%
#  dplyr::top_n(n = 20)
  head(20)


# downloads without doctype:
docTypeDownloads.m.df %>%
  dplyr::filter(is.na(doctype)) %>%
  head(20)

# top (requesting-context) urls
docTypeDownloads.m.df %>%
  dplyr::filter(!(is.na(url))) %>%
  dplyr::count(url, sort = TRUE) %>%
  head(20)


# query for Signify: top (requesting-context) urls with lighting in domain-name
docTypeDownloads.m.df %>%
  dplyr::filter(!(is.na(url))) %>%
  dplyr::filter(grepl("lighting", url)) %>%
  dplyr::count(url, sort = TRUE)  %>%
  kableExtra::kable(caption="Lighting domain requests to P4C") %>%
  kableExtra::kable_styling()

docTypeDownloads.m.df %>%
  dplyr::filter(!(is.na(url))) %>%
  dplyr::filter(grepl("lighting", url)) %>%
  dplyr::count(doctype, longDescription, sort = TRUE)  %>%
  kableExtra::kable(caption="Lighting domain requests to P4C: top doctypes") %>%
  kableExtra::kable_styling()

docTypeDownloads.m.df %>%
  dplyr::filter(!(is.na(url))) %>%
  dplyr::filter(grepl("lighting", url)) %>%
  dplyr::count(doctype, longDescription, product, sort = TRUE)  %>%
  kableExtra::kable(caption="Lighting domain requests to P4C: top doctypes and products") %>%
  kableExtra::kable_styling()

# top (requesting-context) urls and doctypes
docTypeDownloads.m.df %>%
  dplyr::filter(!(is.na(url))) %>%
  dplyr::count(url, doctype, longDescription, sort = TRUE) %>%
  head(20)
