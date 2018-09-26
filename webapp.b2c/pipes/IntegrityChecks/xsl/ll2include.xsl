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
  <xsl:variable name="gnow" select="current-dateTime()"/>
  <xsl:variable name="timestamp" select="replace(replace(replace(substring(xs:string($gnow),1,16),':',''),'-',''),'T','')"/>

  <xsl:template match="/">
    <root>
      <!-- Check statuses of OCTLs -->
      <cinclude:include>
        <xsl:attribute name="src">cocoon:/octlStatusCheck.<xsl:value-of select="$timestamp"/></xsl:attribute>
      </cinclude:include>
      <!-- Check for products in derived categorization catalogs that are not assigned to a subcat -->
      <cinclude:include>
        <xsl:attribute name="src">cocoon:/unCategorizedProducts_DerivedCat.<xsl:value-of select="$timestamp"/></xsl:attribute>
      </cinclude:include>
      <!-- Check for products that are not assigne to a master subcat -->
      <cinclude:include>
        <xsl:attribute name="src">cocoon:/unCategorizedProducts_MasterCat.<xsl:value-of select="$timestamp"/></xsl:attribute>
      </cinclude:include>
      
    </root>
  </xsl:template>
</xsl:stylesheet>