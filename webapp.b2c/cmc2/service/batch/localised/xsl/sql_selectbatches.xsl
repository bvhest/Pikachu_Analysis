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

  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:param name="reload"/>
  <xsl:param name="runmode" select="''"/>
  
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  
  <!-- -->
  <xsl:template match="/">
    <root>
      <sql:execute-query>
        <sql:query>
          select distinct content_type, localisation, batch_number 
          from octl_control 
          where modus        = '<xsl:value-of select="$modus"/>'
            and content_type = '<xsl:value-of select="$ct"/>' 
            and localisation = '<xsl:value-of select="$l"/>' 
            and batch_number &gt; 0
          order by batch_number asc  
        </sql:query>
      </sql:execute-query>
    </root>
</xsl:template>
</xsl:stylesheet>