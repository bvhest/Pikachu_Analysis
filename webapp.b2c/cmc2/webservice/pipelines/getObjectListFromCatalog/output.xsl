<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                >
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="/">
    <xsl:variable name="products" select="tns:Catalogs/tns:Catalog/tns:CatalogProduct"/>
    <tns:Objects totalAmountAvailable="{count($products)}">
      <xsl:apply-templates select="$products">
        <xsl:sort select="@CTN"/>
      </xsl:apply-templates>
    </tns:Objects>
  </xsl:template>
  
  <xsl:template match="tns:CatalogProduct">
    <tns:Object>
      <xsl:attribute name="objectID">
        <xsl:value-of select="@CTN"/>
      </xsl:attribute>
      <xsl:attribute name="type">
        <xsl:text>Product</xsl:text>
      </xsl:attribute>
    </tns:Object>
  </xsl:template>  
  
</xsl:stylesheet>
