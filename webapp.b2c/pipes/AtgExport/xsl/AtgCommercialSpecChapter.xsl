<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:template match="/">
		<gsa-template>
			<import-items>
        <xsl:for-each-group select="/Products/Product" group-by="@Catalog">
          <xsl:variable name="currentcatalog" select="current-grouping-key()"/>
      
  				<xsl:for-each-group select="/Products/Product[@Catalog=$currentcatalog]/CSChapter" group-by="CSChapterCode">
  					<xsl:for-each select="current-group()">
  						<xsl:sort select="../@masterLastModified" order="descending"/>
  						<xsl:variable name="lastModified" select="../@lastModified" as="xsl:dateTime"/>
  						<xsl:variable name="lastExportDate"     select="../@LastExportDate"     as="xsl:dateTime"/>
  						<xsl:if test="position() = 1 and $lastModified &gt; $lastExportDate">
  							<xsl:variable name="catalogLocale" select="concat(../@Locale,'_',../@Catalog)"/>
  							<xsl:variable name="itemCode" select="concat(CSChapterCode,'_',$catalogLocale)"/>
  							<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="comm-spec-chapter-translation" id="{$itemCode}">
  								<set-property name="name">
  									<xsl:value-of select="CSChapterName"/>
  								</set-property>
  							</add-item>
  							<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="comm-spec-chapter" id="{CSChapterCode}">
  								<set-property name="translations" add="true">
  									<xsl:value-of select="concat($catalogLocale,'=',$itemCode)"/>
  								</set-property>
  							</add-item>
  						</xsl:if>
  					</xsl:for-each>
  				</xsl:for-each-group>

  				<xsl:for-each-group select="/Products/Product[@Catalog=$currentcatalog]/NavigationGroup" group-by="NavigationGroupCode">
  					<xsl:for-each select="current-group()">
  						<xsl:sort select="../@masterLastModified" order="descending"/>
  						<xsl:variable name="lastModified" select="../@lastModified" as="xsl:dateTime"/>
  						<xsl:variable name="lastExportDate"     select="../@LastExportDate"     as="xsl:dateTime"/>
  						<xsl:if test="position() = 1 and $lastModified &gt; $lastExportDate">
  							<xsl:variable name="catalogLocale" select="concat(../@Locale,'_',../@Catalog)"/>
  							<xsl:variable name="itemCode" select="concat(NavigationGroupCode,'_',$catalogLocale)"/>
  							<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="comm-spec-chapter-translation" id="{$itemCode}">
  								<set-property name="name">
  									<xsl:value-of select="NavigationGroupName"/>
  								</set-property>
  							</add-item>
  							<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="comm-spec-chapter" id="{NavigationGroupCode}">
  								<set-property name="translations" add="true">
  									<xsl:value-of select="concat($catalogLocale,'=',$itemCode)"/>
  								</set-property>
  							</add-item>
  						</xsl:if>
  					</xsl:for-each>
  				</xsl:for-each-group>				
        </xsl:for-each-group>        
			</import-items>
		</gsa-template>
	</xsl:template>
</xsl:stylesheet>
