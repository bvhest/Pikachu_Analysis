<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:param name="productsdir" />
  <xsl:param name="pctproductsdir" />
  <xsl:param name="source-sub-dir" select="''"/>
  <xsl:param name="runmode" select="''"/>

  <xsl:variable name="gnow" select="current-dateTime()" />
  <xsl:variable name="timestamp" select="replace(replace(replace(substring(xs:string($gnow),1,16),':',''),'-',''),'T','')" />
  <xsl:variable name="l-source-sub-dir" select="if ($source-sub-dir != '') then $source-sub-dir else 'inbox'"/>

  <xsl:template match="/">
    <root>
      <cinclude:include>
        <xsl:attribute name="src">cocoon:/createProductMasterDataCatalogDefSub.ProductMasterDataCatalog.<xsl:value-of select="concat($productsdir,$l-source-sub-dir)" /></xsl:attribute>
      </cinclude:include>
      <xsl:if test="$runmode != 'FASTLANE'">
        <cinclude:include>
          <xsl:attribute name="src">cocoon:/createProductMasterDataCatalogDefSub.CARE_Master_Catalog.<xsl:value-of select="concat($pctproductsdir,$l-source-sub-dir)" /></xsl:attribute>
        </cinclude:include>
      </xsl:if>
    </root>
  </xsl:template>
</xsl:stylesheet>