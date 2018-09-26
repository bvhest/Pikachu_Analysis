<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel"></xsl:param>
  <xsl:param name="locale"></xsl:param>  
  <!-- -->
  <xsl:template match="/">
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
SELECT   locale, batch,
         (SELECT MAX (batch)
            FROM customer_locale_export
           WHERE customer_id = '<xsl:value-of select="$channel"/>' 
             AND locale =  '<xsl:value-of select="$locale"/>'
             AND batch IS NOT NULL) maxbatchnumber
    FROM customer_locale_export
   WHERE customer_id = '<xsl:value-of select="$channel"/>' 
     AND locale = '<xsl:value-of select="$locale"/>'
     AND batch IS NOT NULL
GROUP BY locale, batch
ORDER BY batch               
      </sql:query>
    </sql:execute-query>    
</xsl:template>
</xsl:stylesheet>