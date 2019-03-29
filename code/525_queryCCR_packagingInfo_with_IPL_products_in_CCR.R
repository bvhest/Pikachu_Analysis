#
# Query GTIN corresponding to piece-packaging-type for all IPL-products in CCR 
# database.
#
# BHE, 2019-03-29
#

sessionInfo()

#install.packages(c("tidyverse", "XML", "DBI", "rJava", "RJDBC"))

library(tidyverse)
library(XML)
library(readxl)

library(DBI)
# Set JAVA_HOME, set max. memory, and load rJava library
Sys.setenv(JAVA_HOME='c:/Java/jdk1.8.0_191')
options(java.parameters="-Xmx2g")
library(rJava)

# Output Java version
.jinit()
print(.jcall("java/lang/System", "S", "getProperty", "java.version"))

# Load RJDBC library
library(RJDBC)

###############################################################################
# read data from database
#
# documentation:
#   - https://bommaritollc.com/2012/11/22/connecting-r-to-an-oracle-database-with-rjdbc/
#   - http://www.rforge.net/RJDBC/
###############################################################################

# Create connection driver and open connection (define full path on Windows...)
oracle.JdbcDriver <- 
  RJDBC::JDBC(driverClass="oracle.jdbc.OracleDriver", 
              classPath="c:/Java/Oracle/ojdbc8.jar")

pr.jdbcConnection <- 
  DBI::dbConnect(drv = oracle.JdbcDriver,
                 url = "jdbc:oracle:thin:@130.139.136.60:1521:CCR1P", 
                 user = "bvanhest", 
                 password = "Philips@123")


# Select packaging information for IPL-products in CCR database:
qry <- 
  "SELECT lp.pm_name, lp.lp_commercial_code, lp.country_cd, lp.lp_gtin
, p.PKG_GTIN
, pt.pkgt_cd, pt.pkgt_name
, p.PKG_NR_OF_ITEMS 
FROM ORAP.M_LOGISTIC_PASSPORT lp
INNER JOIN ORAP.M_PACKAGING p
   ON p.lp_id = lp.lp_id
INNER JOIN ORAP.M_PACKAGING_TYPE pt
   ON pt.pkgt_cd = p.pkgt_cd
WHERE lp.pm_name in (select m.pm_name 
from m_product_model m
   , m_article_group ag
where m.ag_cd = ag.ag_cd
  and ag.mag_cd = 'F02')" # selection of IPL-products
  
products.r.df <- 
  DBI::dbGetQuery(conn = pr.jdbcConnection, 
                  statement = qry )

# 1730 total rows in result-set: managable to perform filtering post-query...


# Close connection
dbDisconnect(pr.jdbcConnection)

save(products.r.df,
     file = "./code/data/db_ccr_logistic_data_IPL_products.RData")

###############################################################################
# data cleaning & manipulation
###############################################################################
glimpse(products.r.df)

## ToDo (2019-03-21): filter db result set and join with source-data!
ccr_logistic_data.c <-
  products.r.df %>%
  # make join easier to perform by renaming columns ot target name
  dplyr::rename(CalcCTN = PM_NAME,
                GLOBAL_TRADE_ITEM_NUM = PKG_GTIN) %>%
  # cast numeric to integer type (easier sorting)
  #dplyr::mutate(GLOBAL_TRADE_ITEM_NUM = as.integer(GLOBAL_TRADE_ITEM_NUM)) %>%
  # keep unique combinations of ctn and gtin (remove country info)
  dplyr::select(-COUNTRY_CD) %>% # remove unnecessary columns
  dplyr::distinct(CalcCTN, LP_GTIN, GLOBAL_TRADE_ITEM_NUM, 
                  .keep_all = TRUE)

glimpse(ccr_logistic_data.c)

logisticProductList.c <-
  ccr_logistic_data.c %>%
  dplyr::filter(PKG_NR_OF_ITEMS == 1)

# write results to file
readr::write_csv(logisticProductList.c,
                 path = "./analyse/packaging/LogisticProductList_IPL_from_CCR_enriched.csv")


save(ccr_logistic_data.c,
     logisticProductList.c,
     file = "./code/data/logistic_data_from_ccr_cleaned.RData")

