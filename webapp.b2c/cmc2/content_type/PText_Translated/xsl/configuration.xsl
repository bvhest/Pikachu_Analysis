<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
 <!-- -->      
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
 <xsl:template match="PackagingText">
    <xsl:copy copy-namespaces="no">
      <xsl:variable name="groupCode">
        <xsl:value-of select="substring-before(ancestor::content/configuration/octl/sql:rowset/sql:row/sql:data/PackagingProjectConfiguration/@categorizationcodepath,'\')"/>
      </xsl:variable>
      <xsl:variable name="categoryCode">
        <xsl:value-of select="substring-before(substring-after(ancestor::content/configuration/octl/sql:rowset/sql:row/sql:data/PackagingProjectConfiguration/@categorizationcodepath,concat($groupCode,'\')),'\')"/>
      </xsl:variable>    
      <xsl:variable name="groupName">
        <xsl:value-of select="substring-before(ancestor::content/configuration/octl/sql:rowset/sql:row/sql:data/PackagingProjectConfiguration/@categorizationnamepath,'\')"/>
      </xsl:variable>
      <xsl:variable name="categoryName">
        <xsl:value-of select="substring-before(substring-after(ancestor::content/configuration/octl/sql:rowset/sql:row/sql:data/PackagingProjectConfiguration/@categorizationnamepath,concat($groupName,'\')),'\')"/>
      </xsl:variable> 
      
      <xsl:attribute name="division"><xsl:value-of select="ancestor::content/configuration/octl/sql:rowset/sql:row/sql:data/PackagingProjectConfiguration/@division"/></xsl:attribute>
      <xsl:attribute name="category"><xsl:value-of select="$categoryCode"/></xsl:attribute>
      <xsl:attribute name="routingCode"><xsl:value-of select="concat($groupCode,'/',$categoryCode)"/></xsl:attribute>
      <xsl:attribute name="routingName"><xsl:value-of select="concat($groupName,'/',$categoryName)"/></xsl:attribute>

      <xsl:apply-templates select="@*[not(local-name()='categorizationcodepath' or local-name()='categorizationnamepath' or local-name()='category')]"/>
      <xsl:copy-of select="ancestor::content/configuration/octl/sql:rowset/sql:row/sql:data/PackagingProjectConfiguration/ProductReferences" copy-namespaces="no"/>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>  
  <!-- -->
  <xsl:template match="configuration"/>  
  <!-- -->
</xsl:stylesheet>
