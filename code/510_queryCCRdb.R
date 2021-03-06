#
# check CCR database connection.
#
# BHE, 2019-03-21
#

sessionInfo()

#install.packages(c("tidyverse", "XML", "DBI", "rJava", "RJDBC"))

library(XML)
library(tidyverse)

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
                 url = Sys.getenv("ccr_prd_url"), 
                 user = Sys.getenv("ccr_prd_user"), 
                 password = Sys.getenv("ccr_prd_pwd"))

# Select all F02 (IPL) related products
qry <- 
  "select m.pm_name 
from m_product_model m, m_article_group ag
where m.ag_cd = ag.ag_cd
and ag.mag_cd = 'F02'"
  
products.r.df <- 
  DBI::dbGetQuery(conn = pr.jdbcConnection, 
                  statement = qry )

# Close connection
dbDisconnect(pr.jdbcConnection)

save(products.r.df,
     file = "./code/data/db_channel_config.RData")

###############################################################################
# data cleaning & manipulation
###############################################################################
