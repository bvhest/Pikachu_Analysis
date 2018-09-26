<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	<xsl:strip-space elements="*"/>
	<xsl:template match="/">
		<gsa-template>
			<import-items>
        <xsl:for-each-group select="/Products/Product" group-by="@Catalog">
          <xsl:variable name="currentcatalog" select="current-grouping-key()"/>     
  				<xsl:for-each-group select="/Products/Product[@Catalog=$currentcatalog]/Disclaimer[DisclaimerName!='']" group-by="DisclaimerCode">
  					<xsl:for-each select="current-group()">
  						<xsl:sort select="../@masterLastModified" order="descending"/>
  						<xsl:variable name="lastModified" select="../@lastModified" as="xsl:dateTime"/>
  						<xsl:variable name="lastExportDate"     select="../@LastExportDate"     as="xsl:dateTime"/>
  						<xsl:if test="position() = 1 and $lastModified &gt; $lastExportDate">
  							<xsl:variable name="catalogLocale" select="concat(../@Locale,'_',$currentcatalog)"/>
  							<xsl:variable name="itemCode" select="concat(DisclaimerCode,'_',$catalogLocale)"/>
  							<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="disclaimer-translation" id="{$itemCode}">
  								<set-property name="description"><xsl:value-of  select="normalize-space(DisclaimerName)"/></set-property>
  							</add-item>
  							<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="disclaimer" id="{DisclaimerCode}">
								<set-property name="reference"><xsl:value-of select="DisclaimerCode"/></set-property>
								<set-property name="masterDescription"><xsl:value-of select="normalize-space(DisclaimerName)"/></set-property>
  								<set-property name="translations" add="true"><xsl:value-of select="concat($catalogLocale,'=',$itemCode)"/></set-property>
  							</add-item>
  						</xsl:if>
  					</xsl:for-each>
  				</xsl:for-each-group>
        </xsl:for-each-group>           
			</import-items>
		</gsa-template>
	</xsl:template>
</xsl:stylesheet>
