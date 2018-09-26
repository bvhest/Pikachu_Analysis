<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:my="http://www.philips.com/pika"
                >
   <!-- -->
  <xsl:template match="/">
   <root>
      <sql:execute-query name="PMS.prepare_temp_tables">
         <sql:query isstoredprocedure="true">
BEGIN
   IF PCK_PCU.get_runmode = 'BATCH'
   THEN
      -- prepare temporary tables to increase responsiveness of queries in PMS alert processing.
      -- performed once at the start of the PMS content type.
      pms.prepare_temp_tables;
   END IF;      
EXCEPTION 
   WHEN OTHERS THEN 
      RAISE_APPLICATION_ERROR(-20012, 'Call to PMS.prepare_temp_tables failed with '||SUBSTR(sqlerrm,1,2016));   
END;
         </sql:query>
      </sql:execute-query>
   </root>
   </xsl:template>
	<!-- -->
</xsl:stylesheet>
