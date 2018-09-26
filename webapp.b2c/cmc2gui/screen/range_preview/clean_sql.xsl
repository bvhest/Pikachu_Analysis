<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xsl:exclude-result-prefixes="sql xs">

  <xsl:template match="referencedproducts">
    <xsl:variable name="filters-features">
      <features>
        <xsl:for-each select="distinct-values(../../Filters/Purpose/Features/Feature/@code)">
          <feature code="{.}" />
        </xsl:for-each>
      </features>
    </xsl:variable>
    <xsl:variable name="filters-csitems">
      <csitems>
        <xsl:for-each select="distinct-values(../../Filters/Purpose/CSItems/CSItem/@code)">
          <csitem code="{.}" />
        </xsl:for-each>
      </csitems>
    </xsl:variable>
    <xsl:copy>
      <xsl:apply-templates select="object/sql:rowset/sql:row/sql:data/Product" mode="referencedproduct">
        <xsl:with-param name="filters-features" select="$filters-features" />
        <xsl:with-param name="filters-csitems" select="$filters-csitems" />
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Product" mode="referencedproduct">
    <xsl:param name="filters-features" />
    <xsl:param name="filters-csitems" />
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:copy-of select="CTN" />
      <xsl:copy-of select="ProductName" />
      <xsl:copy-of select="KeyBenefitArea/Feature[FeatureCode=$filters-features/features/feature/@code]" />
      <xsl:copy-of select="CSChapter/CSItem[CSItemCode=$filters-csitems/csitems/csitem/@code]" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>

