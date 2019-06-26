#
# Determine distribution of rank-values in STEP_cross_country_catalog.
#
# BHE, 17-05-2019
#

library(tidyverse)

###############################################################################
# create required directories
###############################################################################
# define utility functions
create_directory <-
  function(mainDir, subDir) {
    if (!dir.exists(file.path(mainDir, subDir))) {
      dir.create(file.path(mainDir, subDir), 
                 showWarnings = TRUE)
    }
  }

mainDir <- 
  getwd()

subDirs <-
  c("data", "data/csv", "images", "images/STEP_classifications", "analyse", "analyse/output")

for (subDir in subDirs) {
  create_directory(mainDir, subDir)
}

###############################################################################
# read XML (transformed to csv-format)
###############################################################################

system2(command = "./code/600_catalog_rank.bat", 
        args = getwd())

catalog.r <-
  readr::read_csv("./data/csv/600_catalog_rank.csv")

###############################################################################
# clean data
###############################################################################
catalog.c <-
  catalog.r

remove(catalog.r, mainDir, subDir, subDirs, create_directory)
###############################################################################
# export processed data (in csv-format suitable for spreadsheet)
###############################################################################

###############################################################################
# continue analysis
###############################################################################
# rank-count
nrow(catalog.c)

# classification-locale combinations where the rank > 99
classification_locales_with_high_rank <-
  catalog.c %>%
  dplyr::filter(rank > 99)

# all extremes
catalog.c %>%
  dplyr::summarise(minRank = min(rank),
                   maxRank = max(rank))

# extremes for rank > 99
catalog.c %>%
  dplyr::filter(rank > 99) %>%
  dplyr::summarise(minRank = min(rank),
                   maxRank = max(rank))

# unique ranks with rank > 99
catalog.c %>%
  dplyr::filter(rank > 99) %>%
  dplyr::distinct(rank) %>%
  dplyr::arrange(rank)
  
# extremes per classification for all ranks
extremes_per_classification <-
  catalog.c %>%
  dplyr::group_by(id) %>%
  dplyr::summarise(minRank = min(rank),
                   maxRank = max(rank)) %>%
  dplyr::ungroup()

# extremes per classification-locale combination for rank > 99
classifications_all_data <-
  catalog.c %>%
  dplyr::left_join(extremes_per_classification, by = "id") %>%
  dplyr::mutate(classification = as.factor(id),
                minLocale = dplyr::if_else(rank == minRank, locale, ""),
                maxLocale = dplyr::if_else(rank == maxRank, locale, ""))

# conclusion based on count of classification_locales_with_high_rank and extremes_per_classification 
# is that each group of locale-ranks within a classification has only one (1!) rank > 99.

###############################################################################
# plots with distributions
###############################################################################
classifications_high <-
  catalog.c %>%
  dplyr::filter(rank > 99) %>%
  dplyr::rename(classification = id) %>%
  dplyr::distinct(classification)
  
# extremes per classification for rank > 99
extremes_per_classification <-
  catalog.c %>%
  dplyr::filter(rank > 99) %>%
  dplyr::group_by(id) %>%
  dplyr::summarise(minRank = min(rank),
                   maxRank = max(rank)) %>%
  dplyr::ungroup()

classifications_high_all_data <-
  catalog.c %>%
  dplyr::filter(id %in% classifications_high$classification) %>%
  dplyr::left_join(extremes_per_classification, by = "id") %>%
  dplyr::mutate(classification = as.factor(id),
                minLocale = dplyr::if_else(rank == minRank, locale, ""),
                maxLocale = dplyr::if_else(rank == maxRank, locale, ""))

# too many classifications, so 'batching' them for clearer plots:
max_cols <- 5
max_rows <- 4
for (i in 0:(round(nrow(classifications_high) / (max_cols*max_rows), digits = 0)-1) ){
  classifications_high_all_data %>%
    dplyr::filter(id %in% classifications_high$classification[(1+i*(max_cols*max_rows)):((i+1)*(max_cols*max_rows))]
                  ) %>%
    ggplot(aes(x = classification,
               y = rank)) +
    geom_violin() + 
    facet_wrap( ~ classification, ncol = max_cols) +
    theme(axis.text.x=element_blank(),
          axis.ticks.x=element_blank())
  
  ggsave(paste0("./images/STEP_classifications/classifications_plot", i, ".png"))
}
###############################################################################
# export processed data (in csv-format suitable for spreadsheet)
###############################################################################
channels.params.wide.df %>%
  readr::write_excel_csv(path="./analyse/output/channelParameters_fromOverview.csv",
                         na = "")

