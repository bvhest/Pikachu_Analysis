#
# prepare STEP metadata for further analysis by converting the data from STEP
#    XML format to csv.
#
# BHE, 18-06-2019
#

# start with the negative scenario
succesfull <- FALSE
message <- "Transformation of STEP XML into (temporary) csv-format was not successful."

###############################################################################
# convert data
###############################################################################
mainDir <- 
  getwd()

# run system command that performs the transformation (assume present in same 
#    directory)
cmd <-
  "./code/620_STEP_asset_xml2csv.bat"

for (env in c(env1 , env2)) {
  print(paste0("Transformation of STEP XML for environment: ", env))
  system2(command = cmd, 
        args =  c(mainDir, env))
}

# if no errors, then 'return' TRUE
succesfull <- TRUE
message <- ""