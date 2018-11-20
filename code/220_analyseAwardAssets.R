#
# read & list channel custom code.
#
# BHE, 26-09-2018
#

#library(XML)
library(tidyverse)
library(readr)
library(httr)
library(purrr)
library(digest)
library(tiff)
library(jpeg)
library(digest)

###############################################################################
# read data
###############################################################################
awards.r <-
  readr::read_csv(file = "./data/awardAssets_nl_NL.csv")

###############################################################################
# munge into desired format:
###############################################################################



###############################################################################
# query the data:
###############################################################################
# 1. how many locales per asset type?
awards.r %>%
  dplyr::group_by(type,locale) %>%
  dplyr::summarise()


# 2. how many unique assets (based on ID) and how many occurances of each asset?
awards.r %>%
  dplyr::group_by(id) %>%
  dplyr::summarise(asset.count = n()) %>%
  dplyr::arrange(desc(asset.count))


# 3. how many unique assets (based on url)?
# a) determine the unique url's
awards.c <-
  awards.r %>%
  dplyr::distinct(url, .keep_all = TRUE)

awards.c <-
  awards.c[1:5,]

glimpse(awards.c)

url <- awards.c$url[1]
id <- awards.c$id[1]
extension <- awards.c$extension[1]

httr::GET(url, write_disk(paste0("./data/assets/", id, ".", extension)))

# b) download the images
purrr::map(awards.c, possibly(httr::GET(url, write_disk(paste0("./data/assets/", id, ".", extension)))[[1]], 
                              NA_real_), 
           url <- awards.c$url,
           id <- awards.c$id,
           extension <- awards.c$extension)

purrr::map(awards.c, httr::GET(url, write_disk(paste0("./data/assets/", id, ".", extension)))[1])

awards.c$md5 <- NA
z <- tempfile()
for (url in awards.c$url) {
  # check: https://stat.ethz.ch/R-manual/R-devel/library/utils/html/download.file.html
  download.file(url, z, mode="wb")
#  pic <- tiff::readTIFF(z)
  pic <- jpeg::readJPEG(z)
  md5 <- digest::digest(pic, algo="md5", serialize=TRUE)
  awards.c$md5[awards.c$url == url] <- md5
}
file.remove(z)

# c) calculate and store the checksum



# 4. how many (unique) assets per asset type?


