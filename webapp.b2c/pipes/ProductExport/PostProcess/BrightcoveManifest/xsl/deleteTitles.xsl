<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:include="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:shell="http://apache.org/cocoon/shell/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<!-- -->
	<xsl:param name="dir"/>
		<xsl:param name="ts"/>
		<xsl:param name="country"/>
		<xsl:param name="locale"/>

	<!-- -->
	<xsl:variable name="publisher-id" select="'23648075001'"/>
	<xsl:variable name="preparer" select="'Philips'"/>
	<xsl:variable name="report-success" select="'TRUE'"/>
	<xsl:variable name="overlay-update" select="'TRUE'"/>
	<xsl:variable name="active" select="'TRUE'"/>
	<xsl:variable name="cmst-email" select="'john.brakewell@philips.com'"/>
	<xsl:variable name="support-email" select="'pancras.pouw@philips.com'"/>
	<!-- -->
	<xsl:template match="@*|node()">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	<!-- -->
	<xsl:template match="/">
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source>
				<xsl:value-of select="concat($dir,'outbox/manifest_',$ts,'_',$country,'_',$locale,'.xml')"/>
			</source:source>
			<source:fragment>
				<xsl:element name="publisher-upload-manifest">
					<xsl:attribute name="publisher-id" select="$publisher-id"/>
					<xsl:attribute name="preparer" select="$preparer"/>
					<xsl:attribute name="report-success" select="$report-success"/>
					<xsl:element name="notify">
						<xsl:attribute name="email" select="$cmst-email"/>
					</xsl:element>
					<xsl:element name="notify">
						<xsl:attribute name="email" select="$support-email"/>
					</xsl:element>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:element>
			</source:fragment>
		</source:write>
	</xsl:template>
	<!-- -->
	<xsl:template match="title">
		<xsl:element name="include:include">
			<xsl:attribute name="src"><xsl:value-of select="concat('cocoon:/deleteAssets/',@refid,'.xml')"/></xsl:attribute>
		</xsl:element>
		<shell:delete>
      <shell:source>
        <xsl:value-of select="concat($dir,'cache/',@refid, '.xml')" />
      </shell:source>
    </shell:delete>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
