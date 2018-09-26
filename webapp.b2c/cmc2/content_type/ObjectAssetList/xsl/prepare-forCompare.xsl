<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <!--
    Convert the aggregated messages from the inbox and cache into a structure that is processed in the comparison.
  -->
  <xsl:template match="@*|node()" mode="#all">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="AssetsToCompare">
    <root>
      <delta>
        <xsl:apply-templates select="ObjectsMsg[1]"/>
      </delta>
      <cache>
        <xsl:apply-templates select="ObjectsMsg[2]"/>
      </cache>  
    </root>
  </xsl:template>
    
</xsl:stylesheet>
