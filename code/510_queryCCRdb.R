#
# read asset configuratoins from CCR database.
#
# BHE, 21-03-2019
#

sessionInfo()

#install.packages(c("tidyverse", "XML", "DBI", "rJava", "RJDBC"))

library(XML)
library(tidyverse)

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
