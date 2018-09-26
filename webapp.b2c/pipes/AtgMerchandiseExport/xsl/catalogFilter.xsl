<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:ph="http://www.philips.com/catalog/pdl">
	<xsl:param name="country"/>
	<xsl:param name="language"/>
	
	<xsl:key name="catalog-key" match="/root/root/sql:rowset[@name='get-catalog-data']/sql:row" use="concat(sql:object_id,'|',sql:catalogtype)"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
	
  <xsl:template match="/root">
    <xsl:apply-templates select="ph:products"/>
  </xsl:template>

	<!-- Filters -->
	<xsl:template match="ph:product">
    <xsl:variable name="id" select="concat(@id,'|',ph:catalogType)"/>
		<xsl:if test="exists(key('catalog-key',$id))">
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="ph:id|ph:catalog|ph:country|ph:language|ph:catalogType|ph:displayName"/>
				<ph:startDate><xsl:value-of select="key('catalog-key',$id)/sql:sop"/></ph:startDate>
				<ph:endDate><xsl:value-of select="key('catalog-key',$id)/sql:eop"/></ph:endDate>
				<xsl:apply-templates select="ph:parentCategoriesForCatalog"/>
				<xsl:apply-templates select="ph:NavigationGroup"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>
 
</xsl:stylesheet>
