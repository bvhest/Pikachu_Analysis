#
# read & list channel custom code.
#
# BHE, 26-09-2018
#

#library(XML)
library(tidyverse)
library(readr)
library(httr)
#library(purrr)
library(digest)
#library(tiff)
library(jpeg)

###############################################################################
# read data
###############################################################################
awards.r <-
  readr::read_csv(file = "./data/csv/awardAssets_nl_NL.csv")

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

# # A tibble: 9 x 2
# # Groups:   type [?]
# type  locale
# <chr> <chr> 
#   1 GAP   global
# 2 KA1   nl_NL 
# 3 KA2   nl_NL 
# 4 KA3   nl_NL 
# 5 KA4   nl_NL 
# 6 KA5   nl_NL 
# 7 KA6   nl_NL 
# 8 KA7   nl_NL 
# 9 KA8   nl_NL 

# 2. how many unique assets (based on ID) and how many occurances of each asset?
awards.r %>%
  dplyr::group_by(id) %>%
  dplyr::summarise(asset.count = n()) %>%
  dplyr::arrange(desc(asset.count))

# # A tibble: 112 x 2
# id           asset.count
# <chr>              <int>
#   1 GA_GREEN             141
# 2 65OLED873_12           8
# 3 FC8377_09              4
# 4 FC8942_09              4
# 5 55OLED803_12           3
# 6 65OLED903_12           3
# 7 HR2355_12              3
# 8 SW7700_67              3
# 9 55OLED903_12           2
# 10 65OLED803_12           2
# # ... with 102 more rows

# 3. how many unique assets (based on url)?
# a) determine the unique url's
awards.c <-
  awards.r %>%
  dplyr::distinct(url, .keep_all = TRUE)

# awards.c <-
#   awards.c[1:5,]

glimpse(awards.c)

# url <- awards.c$url[1]
# id <- awards.c$id[1]
# extension <- awards.c$extension[1]
# 
# httr::GET(url, write_disk(paste0("./data/assets/", id, ".", extension)))
# 
# purrr::map(awards.c, possibly(httr::GET(url, write_disk(paste0("./data/assets/", id, ".", extension)))[[1]], 
#                               NA_real_), 
#            url <- awards.c$url,
#            id <- awards.c$id,
#            extension <- awards.c$extension)
# purrr::map(awards.c, httr::GET(url, write_disk(paste0("./data/assets/", id, ".", extension)))[1])

# b) download the images
# c) calculate and store the checksum
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

# 3. how many unique assets (based on checksum) per asset-type and how many occurances of each asset?
awards.c %>%
  dplyr::group_by(type, md5) %>%
  dplyr::summarise(asset.count = n()) %>%
  dplyr::arrange(desc(asset.count))

# # A tibble: 80 x 3
# # Groups:   type [9]
# type  md5                              asset.count
# <chr> <chr>                                  <int>
# 1 GAP   ba3eabb4e22523d8e90cef4533a3905b          12
# 2 GAP   a62e920776efa6eaca73d2d9e8ef76b5          11
# 3 KA1   37ca4e43cfdcd7ac2d28ea596867ad03           8
# 4 GAP   5d521b959dd6d11bf0d29ea4a87ee27b           6
# 5 GAP   90ac01e97a7488432c4223d185c8963c           6
# 6 GAP   a86863a30b8dbe82baddd10672a3af46           5
# 7 GAP   acb2c460e0a0fdaf6210bb3e8d3a6c6e           5
# 8 GAP   c67daf75b586757c6e632ec9fdfd6cc7           4
# 9 KA1   f2d5f7f02f02ee07744f09055e470a15           3
# 10 KA2   496543d5b5cbce0f2cf4c301ed7a6183           3
# # ... with 70 more rows

awards.c %>%
  dplyr::group_by(md5) %>%
  dplyr::summarise(asset.count = n()) %>%
  dplyr::arrange(desc(asset.count))

# # A tibble: 68 x 2
# md5                              asset.count
# <chr>                                  <int>
# 1 ba3eabb4e22523d8e90cef4533a3905b          13
# 2 a62e920776efa6eaca73d2d9e8ef76b5          11
# 3 37ca4e43cfdcd7ac2d28ea596867ad03           8
# 4 5d521b959dd6d11bf0d29ea4a87ee27b           6
# 5 90ac01e97a7488432c4223d185c8963c           6
# 6 a86863a30b8dbe82baddd10672a3af46           5
# 7 acb2c460e0a0fdaf6210bb3e8d3a6c6e           5
# 8 c67daf75b586757c6e632ec9fdfd6cc7           5
# 9 496543d5b5cbce0f2cf4c301ed7a6183           4
# 10 b2a3816bd00372242ae6151723c0b613           4
# # ... with 58 more rows

# --> sommige assets worden onder twee asset-typen opgevoerd!
#   voorbeeld: asset met md5="ba3eabb4e22523d8e90cef4533a3905b"

awards.c %>%
  filter(md5 == "ba3eabb4e22523d8e90cef4533a3905b")


# 4. how many (unique) assets per asset type?
awards.c %>%
  dplyr::group_by(type) %>%
  dplyr::summarise(count = n_distinct(md5))

# # A tibble: 9 x 2
# type  count
# <chr> <int>
# 1 GAP      21
# 2 KA1      34
# 3 KA2      11
# 4 KA3       7
# 5 KA4       3
# 6 KA5       1
# 7 KA6       1
# 8 KA7       1
# 9 KA8       1
#
# totaal: 80 assets

save(awards.r, awards.c, file = "./data/awards/awards.RData")
