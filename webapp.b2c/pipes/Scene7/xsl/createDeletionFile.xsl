<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
    xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2" 
    extension-element-prefixes="asset-f">

  <xsl:import href="../../common/xsl/xUCDM-external-assets.xsl" />

	<xsl:param name="locale"/>

	<xsl:variable name="doctypes" select="/root/doctypes"/>

	<xsl:template match="/">
		<root>
			<xsl:apply-templates select="root/sql:rowset/sql:row"/>
		</root>
	</xsl:template>

	<xsl:template match="/root/sql:rowset/sql:row">
		<xsl:variable name="id" select="asset-f:escape-scene7-id(sql:object_id)"/>
		<xsl:call-template name="createdelete">
			<xsl:with-param name="doctype" select="."/>
			<xsl:with-param name="id" select="$id"/>
		</xsl:call-template>
	</xsl:template>
		
	<xsl:template name="createdelete">
		<xsl:param name="id"/>
		<xsl:param name="doctype"/>
		<xsl:for-each select="tokenize($doctype/@suffix,',')">
			<xsl:variable name="filename">
				<xsl:choose>
					<xsl:when test="starts-with($doctype,'PMT')">
						<!-- Assume CTN -->
						<xsl:value-of select="concat($id,'.xml')"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- Assume 001 -->
						<xsl:value-of select="concat('001.',.)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<i:include xmlns:i="http://apache.org/cocoon/include/1.0">
				<xsl:attribute name="src">cocoon:/deleteResource.<xsl:value-of select="$doctype/@code"/>.<xsl:value-of select="if ($doctype/@language!='') then $doctype/@language else $locale"/>.<xsl:value-of select="$id"/>?filename=<xsl:value-of select="$filename"/></xsl:attribute>
			</i:include>
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>
