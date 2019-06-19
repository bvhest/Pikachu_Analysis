#
# prepare analysis environment.
#
# BHE, 18-06-2019
#

# define utility functions
create_directory <-
  function(mainDir, subDir) {
  if (!dir.exists(file.path(mainDir, subDir))) {
    dir.create(file.path(mainDir, subDir), 
               showWarnings = FALSE)
  }
}

# start with the negative scenario
succesfull <- FALSE
message <- "Preparation of analysis environment was not successful."

mainDir <- 
  getwd()

# create subdirectories for csv-files
for (env in c(env1 , env2)) {
  print(paste0("Preparation of analysis environment: ", env))
  subDir <-
    paste0("/data/csv/",env)
  create_directory(mainDir, subDir)
}

# if no errors, then 'return' TRUE
succesfull <- TRUE
message <- ""