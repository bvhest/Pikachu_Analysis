/* complete query */
SELECT ch.ID,
       ch.NAME,
       ch.TYPE,
       ch.CATALOG,
       ch.PIPELINE,
       cc.CUSTOMER_ID, 
       cc.LOCALE, 
       cc.ENABLED, 
       cc.LOCALEENABLED
FROM CMC2_QA1_SCHEMA.CHANNELS ch
INNER JOIN CMC2_QA1_SCHEMA.CHANNEL_CATALOGS cc
   ON cc.CUSTOMER_ID = ch.ID
WHERE ch.MACHINEAFFINITY != 'deprecated'
  AND ch.TYPE = 'export'
  AND cc.CATALOG_TYPE= 'CONSUMER'

/* select locales per channel */
SELECT ch.NAME,
       cc.LOCALE, 
       cc.ENABLED, 
       cc.LOCALEENABLED
FROM CMC2_QA1_SCHEMA.CHANNELS ch
INNER JOIN CMC2_QA1_SCHEMA.CHANNEL_CATALOGS cc
   ON cc.CUSTOMER_ID = ch.ID
WHERE ch.MACHINEAFFINITY != 'deprecated'
  AND ch.TYPE = 'export'
  AND cc.CATALOG_TYPE= 'CONSUMER'