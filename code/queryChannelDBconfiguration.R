#
# read process configuration from the Pikachu database.
#
# BHE, 27-09-2018
#

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
  # <!-- B2C QA1 BATCH -->
  # <jdbc name="oracleDbCMC">
  # <driver>oracle.jdbc.driver.OracleDriver</driver>
  # <pool-controller min="50" max="100" oradb="true"/>
  # <dburl>jdbc:oracle:thin:@gdcocl.gdc1.ce.philips.com:5323:PCHU1Q</dburl>
  # <user>BATCH</user>
  # <password>hbakip</password>
  # </jdbc>
  # 
  # <!-- B2C PRD1 SCHEMA -->
  # <jdbc name="oracleDbCMC">
  # <driver>oracle.jdbc.driver.OracleDriver</driver>
  # <pool-controller min="50" max="100" oradb="true"/>
  # <dburl>jdbc:oracle:thin:@gdcocl.gdc1.ce.philips.com:5334:PCHU1P</dburl>
  # <user>cmcprd1</user>
  # <password>1drpcmc</password>
  # </jdbc>

  
  
# Create connection driver and open connection (define full path on Windows...)
jdbcDriver <- 
  JDBC(driverClass="oracle.jdbc.OracleDriver", 
       classPath="c:/Java/lib/ojdbc8.jar")

jdbcConnection <- 
  dbConnect(jdbcDriver, 
            "jdbc:oracle:thin:@gdcocl.gdc1.ce.philips.com:5323:PCHU1Q", 
            "BATCH", 
            "hbakip")

jdbcConnection <- 
  dbConnect(jdbcDriver, 
            "jdbc:oracle:thin:@gdcocl.gdc1.ce.philips.com:5334:PCHU1P", 
            "cmcprd1", 
            "1drpcmc")

# Query on the Oracle instance name.
instanceName <- 
  dbGetQuery(jdbcConnection, "SELECT instance_name FROM v$instance")
print(instanceName)

# Close connection
dbDisconnect(jdbcConnection)

con <- DBI::dbConnect(odbc::odbc(),
                      Driver = "[your driver's name]",
                      Host   = "[your server's path]",
                      SVC    = "[your schema's name]",
                      UID    = rstudioapi::askForPassword("Database user"),
                      PWD    = rstudioapi::askForPassword("Database password"),
                      Port   = 1521)

