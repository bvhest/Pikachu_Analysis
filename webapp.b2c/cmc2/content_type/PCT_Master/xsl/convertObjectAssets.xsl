<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="sql xsl cinclude">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <!--  -->
   <xsl:template match="@*|node()">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
  </xsl:template> 
  <xsl:template match="@*|node()" mode="product">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"  mode="product"/>
    </xsl:copy>
  </xsl:template>
  <!--  -->
  <xsl:template match="octl|sql:rowset|sql:row|sql:data" mode="product">
    <xsl:apply-templates select="@*|node()" mode="product"/>
  </xsl:template>    
  <!--  -->
  <xsl:template match="sql:*" mode="product"/>
  <!--  -->    
  <xsl:template match="Product">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"  mode="product"/>
    </xsl:copy>
   </xsl:template>   
       
      
  <xsl:template match="ObjectAssetList"  mode="product">      
   <xsl:copy>
	  <xsl:apply-templates select="Object"/>
    <xsl:for-each-group select="octl/sql:rowset/sql:row" group-by="sql:object_id">
      <Object>       
        <id><xsl:value-of select="current-grouping-key()"/></id>
        <xsl:for-each select="current-group()/sql:data/object/Asset">
          <xsl:sort select="ResourceType"/>
          <xsl:apply-templates select="." mode="product"/>
        </xsl:for-each>
      </Object>
    </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>      
  
</xsl:stylesheet>
