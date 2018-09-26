<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:my="http://www.philips.com/pika"
                >
   <!-- -->
  <xsl:template match="/">
   <root>
      <sql:execute-query name="PMS.analyse_tables">
         <sql:query isstoredprocedure="true">
BEGIN
   IF PCK_PCU.get_runmode = 'BATCH'
   THEN
      -- removes products with status 'deleted' from the pms_products. 
      pms.purge_deleted_products;

      -- analyse PMS-tables to increase responsiveness of queries.
      pms.analyse_tables;
   
      -- rebuild Oracle Text index so that Empower.ME search returns results.
      -- Note: this procedure is called from within the pms.create_alerts procedure
      --       when the user is FASTLANE.
      pms.analyse_search_index;
   END IF;   
EXCEPTION 
   WHEN OTHERS THEN 
      RAISE_APPLICATION_ERROR(-20012, 'Call to PMS.analyse_tables failed with '||SUBSTR(sqlerrm,1,2016));   
END;
         </sql:query>
      </sql:execute-query>
   </root>
   </xsl:template>
	<!-- -->
</xsl:stylesheet>
