#
# Investigative analysis of the consistency of STEP asset (relation) type 
#   definitions between the different STEP environments.
#
# BHE, 12-06-2019
#


library(tidyverse)
library(readr)
library(compareDF)

# start with the negative scenario
succesfull <- FALSE
message <- "Creating differences between environments was not successful."

################################################################################
# import the data exported from the different STEP environments:
################################################################################
i <- 0
for (env in c(env1, env2)) {
  i <- i+1
  # show selected environment
  print(env)

  # load data into dynamically defined variables (using base::assign)
  filename <- 
    paste0("./data/STEP/assets/",env,"/step_asset_metadata.rds")
  var_name <-
    paste0("asset.metdata.impl.",env)
  assign(x = var_name, 
         value = readRDS(file = filename))
  
  # some quick counts per environment referencing the dynamically defined 
  #    variables (using base::as.name):
  # how many unique assets?
  # implemented
  count <-
    eval(as.name(var_name)) %>%
    dplyr::filter(type == "asset") %>%
    dplyr::distinct(id) %>%
    dplyr::count()
  print(paste("unique assets based on id:", count))

  # implemented relations (= number of doctypes)
  count <-
    eval(as.name(var_name)) %>%
    dplyr::filter(type == "asset") %>%
    dplyr::distinct(doctype) %>%
    dplyr::count()
  print(paste("unique assets based on doctype:", count))
  
  # 1. metadata (so without asset specs/attributes)
  asset.metdata <-
    eval(as.name(var_name)) %>%
    dplyr::distinct(id, name, doctype, assetref_name, locale, dimension, optional, multiValued) %>%
    dplyr::filter(!is.na(doctype))

  var_name <-
    paste0("asset.metdata.env",i)
  assign(x = var_name, 
         value = asset.metdata)

}  

print("data loaded, start comparison...")

################################################################################
# create merged data-set
################################################################################

diff <-
  asset.metdata.env1 %>%
  dplyr::right_join(asset.metdata.env2,
                    by = c("id", "doctype"),
                    suffix = c(".env1", ".env2"))

################################################################################
# check on differences between implementations II : occurances and specifications.
#   based on https://alexsanjoseph.github.io/r/2018/10/03/comparing-dataframes-in-r-using-comparedf
################################################################################

doctypes <-
  eval(as.name(var_name)) %>%
  dplyr::filter(!is.na(doctype)) %>%
  dplyr::distinct(doctype) %>%
  dplyr::pull()

for (type in doctypes) {
  asset <-
    diff %>%
    dplyr::filter(doctype == type)
  
  # diff_crossreferences <-
  #   asset %>%
  #   dplyr::filter(is.na(name.env1)) %>%
  #   dplyr::select(id, name.env2, doctype, assetref_name.env2)
  # 
  # diff_metadata <-
  #   asset %>%
  #   dplyr::filter(!is.na(name.env1)) %>%
  #   dplyr::select(id, name.env2, doctype, assetref_name.env2)
  
  set.env1 <-
    asset.metdata.env1 %>%
    dplyr::filter(doctype == type) 

  set.env2 <-
    asset.metdata.env2 %>%
    dplyr::filter(doctype == type) 
  
  ctable_environment <-
    compareDF::compare_df(set.env1, set.env2, c("doctype"), 
                          limit_html = 200,
                          stop_on_error = FALSE)
  
  print(ctable_environment$html_output)
  html <-
    paste0("<html><body>",as.character(ctable_environment$html_output[1]),"</body></html>", 
           collapse = "\n")
  write.table(html, 
              file = paste0("./data/STEP/assets/diff/asset_definition_diff_",env1,"_",env2,"_",type,".html"), 
              quote = FALSE,
              col.names = FALSE,
              row.names = FALSE)  
}

# if no errors, then 'return' TRUE
succesfull <- TRUE
message <- ""