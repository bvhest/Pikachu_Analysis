<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0"  xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- file name of the uploaded file -->
	<xsl:param name="datafile"/>
	<xsl:param name="division" select="'CE'"/>
	<xsl:param name="store-dir"/>
	<xsl:variable name="current-timestamp" select="replace(/ProductReferences/@DocTimeStamp,'[^0-9]','')"/>


	<xsl:template match="/">
		<root>
			<source:write>
				<source:source>
					<xsl:value-of select="concat($store-dir,'/','ProductReferences_',$current-timestamp,'.xml')"/>
				</source:source>
				<source:fragment>
					<xsl:copy-of select="." copy-namespaces="no"/>
				</source:fragment>
			</source:write>
			<xsl:copy-of select="." copy-namespaces="no"/>
		</root>
	</xsl:template>

	<!-- -->
</xsl:stylesheet>
