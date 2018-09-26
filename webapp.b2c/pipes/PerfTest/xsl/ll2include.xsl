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
  <!-- -->
  <xsl:param name="master"/>
  <!-- -->
  <xsl:variable name="now" select="current-dateTime()"/>
  <xsl:variable name="rundate" select="replace(replace(substring(xs:string(current-dateTime()),1,16),':',''),'-','')"/>
  <!-- -->

  <xsl:template match="/">
    <root>
      <xsl:for-each select="/root/sql:rowset/sql:row/sql:locale">
        <cinclude:include>
          <xsl:attribute name="src">cocoon:/exportDataForLocale.<xsl:value-of select="."/>.<xsl:value-of select="$rundate"/></xsl:attribute>
        </cinclude:include>  
      </xsl:for-each>
    </root>
  </xsl:template>

</xsl:stylesheet>