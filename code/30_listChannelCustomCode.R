#
# read & list channel custom code.
#
# BHE, 26-09-2018
#

#library(XML)
library(tidyverse)
library(digest)

###############################################################################
# read data
###############################################################################

code.r <-
  list.files(path = "./webapp.b2c/pipes/ProductExport/xsl",
             pattern = "*.xsl",
             full.names = TRUE,
             recursive = TRUE,
             include.dirs = FALSE)

activeChannels.df <-
  readRDS(file = "./analyse/output/activeChannels.Rds")

###############################################################################
# munge into desired format:
#   - list of channels, including custom-code (files) per channel
#   - sorted alphabetically
###############################################################################

code.df <-
  code.r %>%
  # map to data-frame and provide name for nameless column:
  as.data.frame(stringsAsFactors = FALSE) %>%
  dplyr::select(files = 1)  

# add md5 checksum for the files
code.df$hash <-
  lapply(code.df$files, 
         function(x) {digest(x, 
                             algo="md5", 
                             serialize = FALSE, 
                             file = TRUE)})

head(code.df, 3)

code.c.df <-
  code.df %>%
  # remove common part of path:
  dplyr::mutate(files = stringr::str_remove(string = files, 
                                            pattern = "./webapp.b2c/pipes/ProductExport/xsl/")) %>%
  # split into export channel (= directory) and filename:
  tidyr::separate(col = files, 
                  into = c('channel', 'file'), 
                  sep = "/",
                  fill = "left",
                  remove = TRUE)

head(code.c.df, 3)

base_code.df <-
  code.c.df %>%
  # filter out the channel specific code:
  dplyr::filter(is.na(channel)) %>%
  # sort alphabetically
  dplyr::arrange(channel, file)

custom_code.df <-
  code.c.df %>%
  # filter out the process base stylesheets, keeping only the channel specific code:
  dplyr::filter(!is.na(channel)) %>%
  # sort alphabetically
  dplyr::arrange(channel, file) %>%
  # clean-up data: remove backup files (funny that these have been created while using a version-repository)
  dplyr::filter(!stringr::str_detect(string = tolower(file),
                                     pattern = "backup")) %>%
  # remove inactive channels/keep active channels
  dplyr::right_join(activeChannels.df, by = "channel")

# convert from long to wide format
custom_code.wide.df <-
  custom_code.df %>%
  dplyr::mutate(inUse = TRUE) %>%       # value-colomn required for spreading
  tidyr::spread(key = "channel",        # spread
                value = "inUse")

#
# list custom-code for incactive channels: can be deleted from Pikachu code repo.
#
# example: AtgGifting
#
obsolete_code.df <-
  code.df %>%
  # filter out the process base stylesheets, keeping only the channel specific code:
  dplyr::filter(!is.na(channel)) %>%
  # only keep unique channels/directories (files are not important)
  dplyr::distinct(channel) %>%
  # sort alphabetically
  dplyr::arrange(channel) %>%
  # remove inactive channels/keep active channels
  dplyr::anti_join(activeChannels.df, by = "channel")

# code that can be deleted:
glimpse(obsolete_code.df)

###############################################################################
# export processed data (in csv-format suitable for spreadsheet)
###############################################################################
custom_code.wide.df %>%
  readr::write_excel_csv(path = "./analyse/output/channelCustomCode.csv",
                         na = "")

obsolete_code.df %>%
  readr::write_excel_csv(path = "./analyse/output/obsoleteChannels_deleteCode.csv",
                         na = "")

###############################################################################
# perform an automated diff between the base code and the channel custom code.
#
# see 
#   - https://stackoverflow.com/questions/43081791/in-r-find-whether-two-files-differ
#   - https://community.rstudio.com/t/comparing-files/2323/7
#   - https://stackoverflow.com/questions/7811878/show-difference-between-files-or-objects
###############################################################################
library(diffobj)

base_dir <- 
  "./webapp.b2c/pipes/ProductExport/xsl"
out_dir <- 
  "./code/data/diff"

# create output-dir (if non-existent)
if (!dir.exists(out_dir)) {
  dir.create(out_dir, 
             showWarnings = FALSE)
}
  
i <- 0
# loop over channels
for (v_channel in custom_code.df %>%
     dplyr::select(channel) %>%
     dplyr::distinct(channel) %>%
     unlist()) {

# v_channel <- "EloquaProducts" # test-data
  i <- i+1
  print(paste(i, v_channel, sep = "; "))

  # loop over custom code per channel
  for (v_file in custom_code.df %>%
                 dplyr::filter(channel == v_channel) %>%
                 dplyr::select(file) %>%
                 dplyr::distinct(channel) %>%
                 unlist()) {

    if (!is.na(v_file)) {
      # v_file <- "convertProducts.xsl" # test-data
      print(v_file)

      base_file <-
        base_code.df %>%
        dplyr::filter(file == v_file) %>%
        dplyr::select(file) %>%
        dplyr::pull()

      if (length(base_file) == 0 || is.na(base_file)) {
        base_file <- "dummy.xsl"
      }

      print(base_file)

      # compare the custom-code with the base-code
      v_customCode <-
        paste(base_dir, v_channel, v_file,
              sep = "/")
      v_baseCode <-
        paste(base_dir, base_file,
              sep = "/")

      filediff <-
        diffobj::diffFile(current = v_customCode,
                          target = v_baseCode,
                          ignore.white.space = TRUE)

      # store the diff on the file-system:
      v_output_dir <-
        paste(out_dir, v_channel,
              sep = "/")

      # create subdirectory, if required
      if (!dir.exists(v_output_dir)) {
        dir.create(v_output_dir,
                   showWarnings = FALSE)
      }
      # write file
      v_output_file <-
        paste(v_output_dir, stringr::str_replace(v_file,
                                                 pattern = ".xsl",
                                                 replace = ".html"),
              sep = "/")

      # readr::write_lines(x = as.character(filediff),
      #                    path = v_output_file,
      #                    append = FALSE)
      write(x = as.character(filediff),
            file = v_output_file,
            append = FALSE)
    }
  } # END loop over custom code per channel

} # END loop over channels

###############################################################################
# perform a correlation between the hash-es: 
#    check which files are identical (if any).
#
# see:
#   - https://rpubs.com/HaroldNelsonJr43/260932
#   - https://stackoverflow.com/questions/39338293/how-can-i-use-summarise-each-for-correlations-in-dplyr
#   - https://stackoverflow.com/questions/50458635/correlation-matrix-with-dplyr-tidyverse-and-broom-p-value-matrix
#
###############################################################################

# create result-directory
out_dir <- 
  "./code/data/identicalCode"

# create output-dir (if non-existent)
if (!dir.exists(out_dir)) {
  dir.create(out_dir, 
             showWarnings = FALSE)
}

# compare all (base and custom) code:
all_code.df <-
  base_code.df %>%
  dplyr::bind_rows(custom_code.df)


for (v_file in all_code.df %>%
               dplyr::select(file) %>%
                   dplyr::distinct(file) %>%
                   unlist()) {

  # v_file <- "convertProducts.xsl" # test-data
  
  temp <-
    all_code.df %>%
    dplyr::filter(file == v_file) %>%
    dplyr::select(channel, hash) %>%
    dplyr::mutate(channel = dplyr::if_else(is.na(channel), "base.Export", channel))

  channel.cor <-
    data.frame(matrix(NA, 
                      nrow = nrow(temp), 
                      ncol = nrow(temp)),
               row.names = temp$channel)
  colnames(channel.cor) <- 
    temp$channel

  # create matrix with identical hash-codes:
  for (i in 1:nrow(temp)) {  
    indices <- 
      which(unlist(temp$hash[i]) == unlist(temp$hash))
    
    channel.cor[i,indices] <- "x"
  }
  
  # move row-names to first column
  channel.cor <-
    channel.cor %>%
    tibble::rownames_to_column()
  
  # save results to file
  file <-
    paste0(out_dir,
           "/", # identicalCode_
           stringr::str_remove(v_file, ".xsl"),
           ".csv")
  
  channel.cor %>%
    readr::write_excel_csv(path = file,
                           na = "")
  
}
