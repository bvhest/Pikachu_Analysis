<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="timestamp"/>
  <xsl:param name="destination"/>
  <!-- -->
  <xsl:template match="/">
    <root step="selectUpdates" destination="{$destination}">
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="sql_selectUpdates">
           select catalog_id
                 ,object_id
                 ,customer_id
                 ,country
                 ,division
                 ,gtin
                 ,sop
                 ,somp
                 ,eop
                 ,sos
                 ,eos
                 ,buy_online
                 ,local_going_price
                 ,deleted
                 ,delete_after_date
                 ,priority
                 ,to_char(lastModified, 'yyyy-MM-dd"T"hh24:mi:ss') lastmodified
             from catalog_objects                       
            where lastModified = to_date('<xsl:value-of select="$timestamp"/>', 'yyyy-MM-dd"T"hh24:mi:ss')
            order by 1,2,3
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>