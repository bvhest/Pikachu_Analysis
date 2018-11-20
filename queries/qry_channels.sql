SELECT DISTINCT ch.*,
       cc.CATALOG_TYPE
    FROM CHANNELS ch
   INNER JOIN CHANNEL_CATALOGS cc
      ON cc.CUSTOMER_ID = ch.ID
   WHERE ch.MACHINEAFFINITY != 'deprecated' 
     AND ch.TYPE = 'export'