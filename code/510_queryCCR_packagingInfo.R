#
# read asset configuratoins from CCR database.
#
# BHE, 21-03-2019
#

sessionInfo()

#install.packages(c("tidyverse", "XML", "DBI", "rJava", "RJDBC"))

library(tidyverse)
library(XML)
library(readxl)

library(DBI)
# Set JAVA_HOME, set max. memory, and load rJava library
Sys.setenv(JAVA_HOME='c:/java')
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


# Select packaging information for a specific product (and country):
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
WHERE lp.pm_name = 'SC2006/11'
AND lp.country_cd = 'NL'"
  
products.r.df <- 
  DBI::dbGetQuery(conn = pr.jdbcConnection, 
                  statement = qry )

# works! no do the same for all unique products in the spreadsheet:
LogisticProductList.r <-
  readxl::read_xlsx(path = "./analyse/packaging/LogisticProductList_IPL.xlsx",
                    sheet = 3, 
                    skip = 0)

# use spreadsheet to create parametrised query:
#
# spreadsheet CalcCTN --> lp.pm_name
# spreadsheet GLOBAL_TRADE_ITEM_NUM --> p.PKG_GTIN

# based on https://stackoverflow.com/questions/45804290/how-to-use-parameterized-sql-with-dplyr
# DOESN'T WORK BECAUSE I NEED A JOIN OVER MULTIPLE TABLES...
products.r.df <- 
  tbl(con, "TABLE_NAME") %>%    #create ref tibble
  filter( a == my_param ) %>%   # filter by param
  collect()                     # execute query


# based on https://db.rstudio.com/best-practices/run-queries-safely/#parameterized-queries
# DOESN'T WORK BECAUSE I NEED MULTIPLE PARAMETERS...
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
WHERE lp.pm_name = ?
AND lp.country_cd = ?"

products.r.df <- 
  dbSendQuery(con, "SELECT * FROM airports WHERE faa = ?")
dbBind(products.r.df, list("GPT"))
dbFetch(products.r.df)



# 255041 total rows in result-set: managable to perform filtering post-query...

qry <- 
  "SELECT lp.pm_name, lp.lp_commercial_code, lp.country_cd, lp.lp_gtin
     , p.PKG_GTIN
, pt.pkgt_cd, pt.pkgt_name
, p.PKG_NR_OF_ITEMS 
FROM ORAP.M_LOGISTIC_PASSPORT lp
INNER JOIN ORAP.M_PACKAGING p
ON p.lp_id = lp.lp_id
INNER JOIN ORAP.M_PACKAGING_TYPE pt
ON pt.pkgt_cd = p.pkgt_cd"

products.r.df <- 
  DBI::dbGetQuery(conn = pr.jdbcConnection, 
                  statement = qry )


# Close connection
dbDisconnect(pr.jdbcConnection)

save(products.r.df,
     file = "./code/data/db_ccr_logistic_data.RData")

###############################################################################
# data cleaning & manipulation
###############################################################################
