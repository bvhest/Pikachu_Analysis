<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
  xmlns:dir="http://apache.org/cocoon/directory/2.0" 
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="channel">test</xsl:param>
  <!-- -->
  <xsl:template match="/">
  <root>
    <xsl:variable name="now" select="current-dateTime()"/>
    <xsl:variable name="report" select="document(sourceResult/source)"/>
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
UPDATE Channels c
set 
  EndExec=to_date('<xsl:value-of select="substring($now,1,19)"/>','yyyy-mm-dd"T"hh24:mi:ss'),
  resultcode = <xsl:value-of select="if(  $report/report/integritycheck/catalog/uncategorized-products/ctn 
                                       or $report/report/integritycheck/nullstatuscheck/localisation) 
                                     then 2 else 0"/>  
where c.name='<xsl:value-of select="$channel"/>'
      </sql:query>
    </sql:execute-query>
  </root>
</xsl:template>
</xsl:stylesheet>