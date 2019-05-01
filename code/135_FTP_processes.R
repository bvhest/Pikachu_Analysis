## Missing SIM-tool FTP-processes for active exports
#
# BHE 2018-12-05
#

library(tidyverse)

# load ftp-processes
ftpProcesses.r <-
  readr::read_delim(file = "./data/simtool/processes.txt", delim = "|", col_names = TRUE)

activeExports <-
  readRDS(file = "./analyse/output/activeChannels.Rds")

# munge
ftpProcesses.c <-
  ftpProcesses.r %>%
  dplyr::left_join(activeExports, by = c("channel" = "job"))
