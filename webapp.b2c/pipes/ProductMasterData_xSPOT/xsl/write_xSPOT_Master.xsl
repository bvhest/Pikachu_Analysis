<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="dir"/>
  <xsl:param name="prefix"/>
  <xsl:param name="ts"/>
  <xsl:param name="locale"/>
  <xsl:param name="batch-num"/>
  
  <xsl:variable name="formatted-ts" select="concat(substring($ts,1,4),'-',substring($ts,5,2),'-',substring($ts,7,2),
      'T',substring($ts,9,2),':',substring($ts,11,2),':',substring($ts,13,2))"/>
  
  <xsl:template match="/">
    <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
      <source:source>
        <xsl:value-of select="concat($dir,'/',$prefix,$ts,'.',$locale,'.')"/>
        <xsl:number value="$batch-num" format="001"/>
        <xsl:text>.xml</xsl:text>
      </source:source>
      <source:fragment>
        <xsl:apply-templates select="node()"/>
      </source:fragment>
    </source:write>
  </xsl:template>
  
  <xsl:template match="Products">
    <ProductsMsg docSource="PikaChu" docTimestamp="{$formatted-ts}" version="2.0">
      <xsl:apply-templates select="sql:rowset/sql:row"/>
    </ProductsMsg>
  </xsl:template>
  
  <xsl:template match="sql:row">
    <xsl:variable name="product" select="sql:data/Product"/>
    <Product>
      <ObjectType>CTV</ObjectType> 
      <ObjectKey><xsl:value-of select="sql:ctn"/></ObjectKey> 
      <CTV_ID><xsl:value-of select="sql:ctn"/></CTV_ID> 
      <Sector><xsl:value-of select="$product/ProductDivision/ProductDivisionName"/></Sector> 
      <Description><xsl:value-of select="$product/Description"/></Description> 
      <ArticleGroupCode>9511</ArticleGroupCode> 
      <ObjectDeleted><xsl:value-of select="if (sql:action='delete') then 'true' else 'false'"/></ObjectDeleted> 
    </Product>
  </xsl:template>
  
</xsl:stylesheet>
