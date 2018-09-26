<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes = "xs sql"
  >
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="/">
    <root> 
	    <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>      
    </root>
  </xsl:template>

  <xsl:template match="sql:row">
    <xsl:variable name="locale" select="sql:locale"/>
    <xsl:variable name="catalog_type" select="sql:catalog_type"/>
    <cinclude:include>
      <xsl:attribute name="src">cocoon:/processRanking.<xsl:value-of select="substring-after($locale,'_')"/>.<xsl:value-of select="$catalog_type"/></xsl:attribute>
    </cinclude:include>
  </xsl:template>

</xsl:stylesheet>