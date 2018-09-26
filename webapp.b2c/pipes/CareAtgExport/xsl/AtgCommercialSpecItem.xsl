<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:template match="/">
		<gsa-template>
			<import-items>
  				<xsl:for-each-group select="/Products/Product/CSChapter/CSItem" group-by="CSItemCode">
  					<xsl:for-each select="current-group()">
  						<xsl:sort select="../../@masterLastModified" order="descending"/>
  						<xsl:variable name="lastModified" select="../../@lastModified" as="xsl:dateTime"/>
  						<xsl:variable name="lastExportDate"     select="../../@LastExportDate"     as="xsl:dateTime"/>
  						<xsl:if test="position() = 1 and $lastModified &gt; $lastExportDate">
  							<xsl:variable name="locale" select="../../@Locale"/>
  							<xsl:variable name="itemCode" select="concat(CSItemCode,'_',$locale)"/>
  							<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="comm-spec-item-translation" id="{$itemCode}">
  								<set-property name="name">
  									<xsl:value-of select="CSItemName"/>
  								</set-property>
  							</add-item>
  							<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="comm-spec-item" id="{CSItemCode}">
  								<set-property name="translations" add="true">
  									<xsl:value-of select="concat($locale,'=',$itemCode)"/>
  								</set-property>
  							<xsl:choose>
  								<xsl:when test="UnitOfMeasure/UnitOfMeasureCode">
  								<set-property name="unitOfMeasure"><xsl:value-of select="UnitOfMeasure/UnitOfMeasureCode"/></set-property>
  								</xsl:when>
  								<xsl:otherwise>
  								<set-property name="unitOfMeasure"><![CDATA[__NULL__]]></set-property>
  								</xsl:otherwise>
  							</xsl:choose>
  							</add-item>
  						</xsl:if>
  					</xsl:for-each>
  				</xsl:for-each-group>
			</import-items>
		</gsa-template>
	</xsl:template>
</xsl:stylesheet>
