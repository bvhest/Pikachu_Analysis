<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:strip-space elements="*" />

  <xsl:template match="@*|node()" mode="#all">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="root">
    <xsl:copy copy-namespaces="no">
      <delta>
        <xsl:apply-templates select="delta/ProductsMsg" mode="clean"/>
      </delta>
      <cache>
        <xsl:apply-templates select="cache/ProductsMsg" mode="clean"/>
      </cache>  
      <store>
        <xsl:apply-templates select="delta/ProductsMsg"/>
      </store>
    </xsl:copy>
  </xsl:template>
  
  <!-- filtered elements and attributes -->
  <xsl:template match="@version|@docTimestamp|Modified|Asset[Publisher='ProCoon']" mode="clean"/>
  <!-- Remove Obsolete Assets from inbox XML -->
  <xsl:template match="delta/ProductsMsg/Product/Asset[License='Obsolete']" mode="clean"/>
  
  <xsl:template match="Product" mode="clean">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="CTN" />
      <xsl:apply-templates select="Asset" mode="clean">
        <xsl:sort select="ResourceType" order="ascending" />
        <xsl:sort select="Language" order="ascending" />
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
