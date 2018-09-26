<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
    
  <xsl:template match="ObjectAssetList">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="octl/sql:rowset/sql:row/sql:data/object">
        <xsl:sort select="id"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sql:data/object">
    <Object>
      <xsl:apply-templates select="@*|node()" />
    </Object>
  </xsl:template>
  
</xsl:stylesheet>