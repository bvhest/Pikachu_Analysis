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
oracle.JdbcDriver <- 
  RJDBC::JDBC(driverClass="oracle.jdbc.OracleDriver", 
              classPath="c:/Java/lib/ojdbc8.jar")

qa.jdbcConnection <- 
  DBI::dbConnect(drv = oracle.JdbcDriver,
                 url = "jdbc:oracle:thin:@130.139.136.68:1521:PCHU1Q",
                 user = "CMC2_QA1_SCHEMA", 
                 password = "CMC2_QA")

pr.jdbcConnection <- 
  DBI::dbConnect(drv = oracle.JdbcDriver,
                 url = "jdbc:oracle:thin:@130.139.136.69:1521:PCHU2P", 
                 user = "U1BATCH", 
                 password = "CMC2_QA")

# TEST with : 3110 # EloquaProducts
# ch_locales.r.df <- 
#   DBI::dbGetQuery(conn = qa.jdbcConnection, 
#                   statement = "SELECT CUSTOMER_ID, LOCALE, ENABLED, LOCALEENABLED FROM CMC2_QA1_SCHEMA.CHANNEL_CATALOGS WHERE CUSTOMER_ID = 3110 AND CATALOG_TYPE= 'CONSUMER'" )



# Query on the channels-table.
qry <- 
  "SELECT ch.* 
   FROM CHANNELS ch
   WHERE ch.MACHINEAFFINITY != 'deprecated' 
   AND ch.TYPE = 'export'"
  
channels.r.df <- 
  DBI::dbGetQuery(conn = qa.jdbcConnection, 
                  statement = qry )

# all channels
qry <- 
  "SELECT ch.NAME,
          cc.LOCALE, 
          cc.ENABLED, 
          cc.LOCALEENABLED,
          cc.DIVISION,
          cc.BRAND,
          cc.PRODUCT_TYPE
  FROM CHANNELS ch
  INNER JOIN CHANNEL_CATALOGS cc
     ON cc.CUSTOMER_ID = ch.ID
  WHERE ch.MACHINEAFFINITY != 'deprecated'
    AND ch.TYPE = 'export'
    AND cc.CATALOG_TYPE= 'CONSUMER'"

ch_locales.r.df <- 
  DBI::dbGetQuery(conn = qa.jdbcConnection, 
                  statement = qry)

# Close connection
dbDisconnect(qa.jdbcConnection)

save(channels.r.df,
     ch_locales.r.df,
     file = "./code/data/db_channel_config.RData")

###############################################################################
# data cleaning & manipulation
###############################################################################

#
# channel configuration
#

# check parameter-list
channels.params.df <-
  channels.r.df %>%
  # keep exports (remove other processes)
  dplyr::filter(TYPE == "export") %>%
  # remove irrelevant columns
  dplyr::select(NAME, PIPELINE, CATALOG, PUBLICATIONOFFSET_SOP, PUBLICATIONOFFSET_EOP) %>%
  # split process and parameters
  tidyr::separate(col = PIPELINE, 
                  into = c('BaseExport', 'Parameters'), 
                  sep = "\\?",
                  fill = "right",
                  remove = TRUE) %>%
  # get BaseExport from process triggering url:
  dplyr::mutate(BaseExport = stringr::str_remove(string = BaseExport,
                                                 pattern = "pipes/"),
                BaseExport = dplyr::if_else(stringr::str_detect(string = BaseExport, 
                                                                pattern = "\\."),
                                            stringr::str_remove(string = BaseExport,
                                                                pattern = paste0(".", NAME)),
                                            BaseExport)) %>%
  # split parameters
  tidyr::separate(col = Parameters, 
                  into = c('par1', 'par2', 'par3', 'par4','par5', 'par6', 'par7', 'par8'), 
                  sep = "&",
                  fill = "right",
                  remove = TRUE) %>%
  # from wide to long format
  tidyr::gather(key = remove,
                value = parameter, 
                na.rm = TRUE,
                par1:par8) %>%
  # remove unnecesarry columns
  dplyr::select(-remove) %>%
  # split parameter name and value
  tidyr::separate(col = parameter, 
                  into = c('parameter', 'value'), 
                  sep = "=",
                  fill = "right",
                  remove = TRUE) %>%
  # convert channel name to lower-case:
  dplyr::rename(Channel = NAME,
                Catalog = CATALOG,
                Offset_sop = PUBLICATIONOFFSET_SOP,
                Offset_eop = PUBLICATIONOFFSET_EOP) %>%
  # sort alphabetically
  dplyr::arrange(channel, parameter)

glimpse(channels.params.df)

# transpose into (wide) tabel/spreadsheet format
channels.params.wide.df <-
  channels.params.df %>%
  tidyr::spread(key = parameter,
                value = value)

# note: 
#   the same parameters ae present in both lower- and title-case !!
#   Pikachu is case-sensitive, so some of the parameters will be ignored...



#
# locales per channel configuration
#
channels.locales.df <-
  ch_locales.r.df %>%
  # remove all rows that are dsabled:
  dplyr::filter(LOCALEENABLED == 1) %>%
  # remove irrelevant columns
  dplyr::select(NAME, LOCALE, LOCALEENABLED, DIVISION, BRAND, PRODUCT_TYPE) %>%
  # convert column names:
  dplyr::rename(channel = NAME,
                locale = LOCALE,
                enabled = LOCALEENABLED,
                division = DIVISION,
                brand = BRAND,
                productType = PRODUCT_TYPE) %>%
  # remove duplicate entries(duplicate becasue??)
  dplyr::distinct(channel, locale, .keep_all = TRUE) %>%
  # order data
  dplyr::arrange(channel, locale)

glimpse(channels.locales.df)

# transpose into (wide) tabel/spreadsheet format
channels.locales.wide.df <-
  channels.locales.df %>%
  tidyr::spread(key = channel,
                value = enabled)

###############################################################################
# export processed data (in csv-format suitable for spreadsheet)
###############################################################################
channels.params.wide.df %>%
  readr::write_excel_csv(path="./analyse/output/channelParameters.csv",
                         na = "")

channels.locales.wide.df %>%
  readr::write_excel_csv(path="./analyse/output/channelLocales.csv",
                         na = "")

