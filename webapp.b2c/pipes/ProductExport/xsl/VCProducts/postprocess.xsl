<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl cinclude">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="catalogreportfile"/>
  <xsl:param name="locale"/>
  <!-- -->
  <xsl:variable name="country" select="substring-after($locale,'_')"/>
  <xsl:variable name="transmittedproducts">
    <products>
      <xsl:for-each select="document(concat('../../',$catalogreportfile))/root/sql:rowset[@name='select']/sql:row/sql:ctn">
        <ctn><xsl:value-of select="."/></ctn>
      </xsl:for-each>
    </products>
  </xsl:variable>
  <xsl:variable name="yesterday" select="document(concat('../../',$catalogreportfile))/root/sql:rowset[@name='yesterday']/sql:row/sql:yesterday"/>
  <xsl:variable name="today" select="document(concat('../../',$catalogreportfile))/root/sql:rowset[@name='today']/sql:row/sql:today"/>
  <!-- -->
  <xsl:template match="Products">
    <xsl:variable name="thisexportsproducts">
      <products>
        <xsl:for-each select="Product/CTN">
          <ctn><xsl:value-of select="."/></ctn>
      </xsl:for-each>
     </products>
   </xsl:variable>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*"/>
      <xsl:for-each select="$transmittedproducts/products/ctn">
        <xsl:if test="not($thisexportsproducts/products[ctn=current()])">
          <xsl:call-template name="createFragmentForDeletedProduct">
            <xsl:with-param name="ctn" select="."/>
          </xsl:call-template>
        </xsl:if>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="Product/Catalog/EndOfPublication|Product/Catalog/StartOfPublication">
    <xsl:choose>
      <xsl:when test="../../RichTexts/RichText[@type='ProofPoint']/Item">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{local-name()}">
          <xsl:value-of select="concat($yesterday,'T00:00:00')"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- -->
  <xsl:template name="createFragmentForDeletedProduct">
    <xsl:param name="ctn"/>
    <Product Country="{$country}" IsAccessory="false" IsMaster="false" Locale="{$locale}" lastModified="{concat($yesterday,'T00:00:00')}" masterLastModified="{concat($yesterday,'T00:00:00')}">
      <CTN><xsl:value-of select="$ctn"/></CTN>
      <Catalog>
        <StartOfPublication>2008-01-01T00:00:00</StartOfPublication>
        <EndOfPublication><xsl:value-of select="concat($yesterday,'T00:00:00')"/></EndOfPublication>
        <StartOfSales>2008-01-01T00:00:00</StartOfSales>
        <EndOfSales><xsl:value-of select="concat($yesterday,'T00:00:00')"/></EndOfSales>
        <DummyPrice>0.00</DummyPrice>
        <Deleted>false</Deleted>
        <DeleteAfterDate/>
        <ProductRank>50</ProductRank>
      </Catalog>
    </Product>
  </xsl:template>
  <!-- -->
  <xsl:template match="node()|@*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>