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
library(tiff)
library(jpeg)
library(png)

###############################################################################
# define data
###############################################################################
# data from XML
KA1_image <- 
  "http://download.p4c.philips.com/files/b/bg105_10/bg105_10_ka1_nldnl.tif"
KA1_ccrmd5 <- 
  "28ebe7b76712f9ffebc42c87f68c6f06"

GAL_image <- 
  "http://pww.pcc.philips.com/mprdata/160511/1605110321_gal.jpg"
GAL_ccrmd5 <- 
  "dc6eae3c7e1f2bae83132d7af3e57436"
GAP_image <- 
  "http://pww.pcc.philips.com/mprdata/160511/1605110322_gap.tif"
GAP_ccrmd5 <- 
  "67430fd90ef639b83a5c77d89328cb72"
GAW_image <- 
  "http://pww.pcc.philips.com/mprdata/160511/1605110323_gaw.jpg"
GAW_ccrmd5 <- 
  "92711a06efedb448460cf67443306c13"
GAZ_image <- 
  "http://pww.pcc.philips.com/mprdata/171128/17112801vt_gaz.png"
GAZ_ccrmd5 <- 
  "40c6e9a37e64c8db1b8e47a7dfb86fba"

assets <-
  data.frame(type="KA1", url=KA1_image, ccrmd5=KA1_ccrmd5) %>%
  dplyr::bind_rows(data.frame(type="GAL", url=GAL_image, ccrmd5=GAL_ccrmd5)) %>%
  dplyr::bind_rows(data.frame(type="GAP", url=GAP_image, ccrmd5=GAP_ccrmd5)) %>%
  dplyr::bind_rows(data.frame(type="GAW", url=GAW_image, ccrmd5=GAW_ccrmd5)) %>%
  dplyr::bind_rows(data.frame(type="GAZ", url=GAZ_image, ccrmd5=GAZ_ccrmd5))

awards <- assets; awards$md5 <- NA
z <- tempfile()
for (i in 1:nrow(awards)) {
  # check: https://stat.ethz.ch/R-manual/R-devel/library/utils/html/download.file.html
  url <- awards$url[i]
  download.file(url, destfile=z, mode="wb")
  tryCatch({
    if (grepl(pattern = "jpg", x = url, ignore.case = TRUE)) {
      pic <- jpeg::readJPEG(z)
    } else if (grepl(pattern = "tif", x = url, ignore.case = TRUE)) {
      pic <- tiff::readTIFF(z)
    } else {
      pic <- png::readPNG(z)
    }
    md5 <- digest::digest(pic, algo="md5", serialize=TRUE)
  }, error = function(err) {
    return(md5 <- 0)
  })
  awards$md5[i] <- md5
}
file.remove(z)
