#
# list directories and put into alphabetical order
#
# BvH, 25/10/2018
#

library(tidyverse)

dirs <- 
  list.dirs(path = "./data", full.names = FALSE, recursive = FALSE) %>%
  as.data.frame() %>%
  dplyr::rename_at( 1, ~"dir" )
