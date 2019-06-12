#
# Investigative analysis of the consistency of STEP asset (relation) type 
#   definitions between the different STEP environments.
#
# BHE, 12-06-2019
#


library(tidyverse)
library(readr)

################################################################################
# import the data exported from the different STEP environments:
################################################################################
for (env in c("dev" , "tst")) {
  # show selected environment
  print(env)

  # load data into dynamically defined variables (using base::assign)
  filename <- 
    paste0("./data/STEP_assets/",env,"/asset.meta.step.rds")
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

readr::write_excel_csv(pbp, path = "./data/diff_dev_tst_pbp.csv")

app <-
  diff %>%
  # select product beauty shot
  dplyr::filter(id == "Alternativeproductphotograph") %>% 
  dplyr::arrange(id)

readr::write_excel_csv(app, path = "./data/diff_dev_tst_app.csv")
