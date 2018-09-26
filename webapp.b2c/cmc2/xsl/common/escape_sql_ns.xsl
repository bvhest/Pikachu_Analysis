<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="sql xsl cinclude">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- 
    Remove the sql: namespace in order to be able to use multiple SQL transformations on the same XML.
    SQLTransformer doesn't like sql: result elements. 
  -->
  <xsl:template match="sql:*">
    <!-- strip sql namespace -->
    <xsl:element name="{concat('sql-',local-name())}">
      <xsl:apply-templates select="@*|node()"/>        
    </xsl:element>
  </xsl:template>  
  
</xsl:stylesheet>
