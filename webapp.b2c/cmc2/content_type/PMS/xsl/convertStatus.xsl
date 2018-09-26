<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    exclude-result-prefixes="sql">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="sql:rowset" />
  
  <!-- Add an attribute to see if this product should be marked for delete -->
  <xsl:template match="content/Product">
    <xsl:variable name="master-data" select="ancestor::content/sql:rowset[@name='ProductMarketingStatus']/sql:row/sql:data/Product/MasterData"/>
    <xsl:copy copy-namespaces="no">
      <xsl:attribute name="is-deleted" select="$master-data/ProductStatus='Deleted' or $master-data/PMTStatus='Not for Marketing Communication'"/>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="content/Product/MasterData">
    <xsl:variable name="master-data" select="ancestor::content/sql:rowset[@name='ProductMarketingStatus']/sql:row/sql:data/Product/MasterData"/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="$master-data/*"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="EvaluationData/MasterData">
    <xsl:variable name="master-data" select="ancestor::content/sql:rowset[@name='ProductMarketingStatus']/sql:row/sql:data/Product/MasterData"/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="$master-data/*"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
