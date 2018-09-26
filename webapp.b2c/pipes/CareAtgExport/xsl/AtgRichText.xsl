<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://www.philips.com/pika" extension-element-prefixes="my xs">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
  
	<xsl:function name="my:normalized-id" as="xs:string">
		<xsl:param name="id"/>
		<xsl:value-of select="translate($id,'/-. ','___')"/>
	</xsl:function>

	<xsl:template name="product-translation">
		<xsl:param name="catalogLocale"/>
		<xsl:param name="atgCTN"/>
		<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="product-translation" id="{concat($atgCTN,'_',$catalogLocale)}">
      <xsl:copy-of select="RichTexts"/>
		</add-item>
	</xsl:template>
  
  <xsl:template match="node()" mode="escape">
    <xsl:value-of select="concat('&lt;',local-name())"/><xsl:apply-templates select="@*" mode="escape"/><xsl:value-of select="concat('&gt;',text())"/>
      <xsl:apply-templates select="child::node()[local-name() != '']" mode="escape"/>
    <xsl:value-of select="concat('&lt;/',local-name(),'&gt;')"/>    
  </xsl:template>	

  <xsl:template match="@*" mode="escape">
    <xsl:value-of select="concat(' ',local-name(),'=&quot;',.,'&quot;')"/>
    <xsl:apply-templates select="@*|node()" mode="escape"/>
  </xsl:template>	
   
	<xsl:template match="/Products">
		<gsa-template>
			<import-items>
				<xsl:for-each select="Product">
					<xsl:variable name="lastModified" select="@lastModified" as="xsl:dateTime"/>
					<xsl:variable name="lastExportDate"     select="@LastExportDate"     as="xsl:dateTime"/>
					<xsl:if test="$lastModified &gt; $lastExportDate">									
						<xsl:variable name="catalogLocale" select="concat(@Locale  ,'_',@Catalog)"/>
						<xsl:variable name="catalog" select="concat(@Country  ,'_',@Catalog)"/>
						<xsl:variable name="atgCTN" select="my:normalized-id(CTN)"/>
						<xsl:call-template name="product-translation">
							<xsl:with-param name="catalogLocale" select="$catalogLocale"/>
							<xsl:with-param name="atgCTN" select="$atgCTN"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</import-items>
		</gsa-template>
	</xsl:template>
</xsl:stylesheet>
