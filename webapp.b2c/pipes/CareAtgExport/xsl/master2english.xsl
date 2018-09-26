<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="country">CH</xsl:param>
	<xsl:param name="language">en</xsl:param>
	<xsl:param name="catalogDocPath"/>
	
	<xsl:variable name="catalog" select="document($catalogDocPath)"/>
	
	
	<xsl:template name="copy-property">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:value-of select="replace(.,'_00',concat('_',$country))"/>
		</xsl:copy>
	</xsl:template>	

	
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="gsa-template">
		<gsa-template>
			<xsl:apply-templates select="@*|node()"/>
		</gsa-template>
	</xsl:template>
 
	<xsl:template match="@id" >
		<xsl:attribute name="id"><xsl:value-of select="replace(replace(.,'_00',concat('_',$country)),'\*00',concat('*',$country))"/></xsl:attribute>
	</xsl:template>
	
	<xsl:template match="set-property[@name=('catalogId','translations')]" >
		<xsl:call-template name="copy-property"/>
	</xsl:template>

</xsl:stylesheet>
