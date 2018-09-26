<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
  xmlns:dir="http://apache.org/cocoon/directory/2.0" 
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="channel"/>
  <xsl:param name="exportdate"/>
  <!-- -->
  <xsl:template match="/">
  <root>
    <!-- set flag to 1 if the export was before the last modified date -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        UPDATE CUSTOMER_LOCALE_EXPORT
        set 
          FLAG=0,
          BATCH=null,
          LASTTRANSMIT=to_date('<xsl:value-of select="$exportdate"/>','yyyymmddhh24miss')
        where CUSTOMER_ID='<xsl:value-of select="$channel"/>'
          and FLAG=1
          and batch is not null
      </sql:query>
    </sql:execute-query>
  </root>
</xsl:template>
</xsl:stylesheet>