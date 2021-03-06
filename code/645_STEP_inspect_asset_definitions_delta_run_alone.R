#
# Investigative analysis of the consistency of STEP asset (relation) type 
#   definitions between the different STEP environments.
#
# Test-script for inspecting the differences between the environments.
#   640_*.R is meant for the process pipeline, this script is for testing.
#
# BHE, 19-06-2019
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
for (env in c(env1, env2)) {
  # show selected environment
  print(env)

  # load data into dynamically defined variables (using base::assign)
  filename <- 
    paste0("./data/STEP/assets/",env,"/step_asset_metadata.rds")
  var_name <-
    paste0("asset.metdata.impl.",env)
  assign(x = var_name, 
         value = readRDS(file = filename))
  
  # some quick counts per environment referencing the dynamically defined variables (using base::as.name):
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
  
}  

################################################################################
# check on differences between implementations
################################################################################

# 1. metadata (so without asset specs/attributes)
asset.metdata.dev <-
  asset.metdata.impl.dev %>%
  dplyr::distinct(id, name, doctype, assetref_name, locale, dimension, optional, multiValued) %>%
  dplyr::filter(!is.na(doctype))

asset.metdata.tst <-
  asset.metdata.impl.tst %>%
  dplyr::distinct(id, name, doctype, assetref_name, locale, dimension, optional, multiValued) %>%
  dplyr::filter(!is.na(doctype))

  
diff <-
  asset.metdata.dev %>%
  dplyr::right_join(asset.metdata.tst,
                    by = c("id", "doctype"),
                    suffix = c(".dev", ".tst"))

# Ouch... on STEP Test many asset cross-references are valid for (almost?!) all asset-types..
pbp <-
  diff %>%
  # select product beauty shot
  dplyr::filter(doctype == "PBP") %>% 
  dplyr::arrange(id)

readr::write_excel_csv(pbp, 
                       path = paste0("./data/diff_",env1, "_", env2,"_pbp.csv"))

app <-
  diff %>%
  # select product beauty shot
  dplyr::filter(id == "Alternativeproductphotograph") %>% 
  dplyr::arrange(id)

readr::write_excel_csv(app, 
                       path = paste0("./data/diff_",env1, "_", env2,"_app.csv"))

################################################################################
# check on differences between implementations II : occurances and specifications.
#   based on https://alexsanjoseph.github.io/r/2018/10/03/comparing-dataframes-in-r-using-comparedf
################################################################################

doctypes <-
  eval(as.name(var_name)) %>%
  dplyr::filter(type == "asset") %>%
  dplyr::filter(!is.na(doctype)) %>%
  dplyr::distinct(doctype) %>%
  dplyr::pull()

for (type in doctypes) {
  asset <-
    diff %>%
    dplyr::filter(doctype == type)
  
  diff_crossreferences <-
    asset %>%
    dplyr::filter(is.na(name.dev)) %>%
    dplyr::select(id, name.tst, doctype, assetref_name.tst)
  
  diff_metadata <-
    asset %>%
    dplyr::filter(!is.na(name.dev)) %>%
    dplyr::select(id, name.tst, doctype, assetref_name.tst)
  
  set.dev <-
    asset.metdata.dev %>%
    dplyr::filter(doctype == type) 

  set.tst <-
    asset.metdata.tst %>%
    dplyr::filter(doctype == type) 
  
  ctable_environment <-
    compareDF::compare_df(set.dev, set.tst, c("doctype"), 
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
