#
# count movie types per Pikachu import
#
# BHE, 2019-05-01
#

#library(XML)
library(tidyverse)
library(readr)

###############################################################################
# read data
###############################################################################
al_movies.r <-
  readr::read_csv(file = "./data/csv/AL_MoviesList.csv",
                  col_types = "ccccccccc")
oal_movies.r <-
  readr::read_csv(file = "./data/csv/OAL_MoviesList.csv",
                  col_types = "ccccccccc")

glimpse(al_movies.r)
glimpse(oal_movies.r)

###############################################################################
# munge into desired format:
###############################################################################

al_movies.c <-
  al_movies.r %>%
  dplyr::mutate(source = "AL")
  
movies.c <-
  oal_movies.r %>%
  dplyr::mutate(source = "OAL") %>%
  dplyr::bind_rows(al_movies.c)

remove(al_movies.c, al_movies.r, oal_movies.r)

###############################################################################
# query the data:
###############################################################################

movies.summary <-
  movies.c %>%
#  mutate_all(funs(type.convert(as.character(.), as.is = TRUE))) %>%
  dplyr::group_by(source, type) %>%
  dplyr::summarise(asset_count = n_distinct(md5))

# pub_url_count = dplyr::count(url),
# sec_url_count = dplyr::count(sec_url),
# int_url_count = dplyr::count(int_url)) %>%


###############################################################################
# store the data:
###############################################################################
file_name <-
  paste("./analyse/output","movies.c.Rds", sep = "/")
saveRDS(movies.c,
        file = file_name)
