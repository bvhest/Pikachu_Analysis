<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="localisation"/>
	<!-- -->
	<xsl:template match="/root">
		<root>
		<ContentTypesCatalog_Def>
        <xsl:comment select="'This is the catalog definition file data for the ContentTypesCatalog.  
I.e., ct = &quot;catalog_definition&quot;, o=&quot;ContentTypesCatalog&quot;, l=&quot;none&quot;.
Append the data generated here to the most recent version held for this ct/o in the OCTL_STORE.'"        
        />
			<xsl:apply-templates select="sourceResult/source" mode="object"/>
		</ContentTypesCatalog_Def>
		<ProductMasterDataCatalog_Conf>
        <xsl:comment select="'This is the catalog configuration file data for output ctl.
This data can be used in a catalog configuration file (i.e. ct = &quot;catalog_configuation&quot;, l=&quot;none&quot;, object_id=&lt;catalogname e.g. &quot;AVENT_CN_Catalog&quot;&gt;.'"/>

        <xsl:comment select="'WARNING!!! Currently unfixed bug means that if there is an underscore in the output
ct, the @ct generated only contains the substring-before the underscore in the ct.  E.g. if output ctl is PMT_Enriched, @ct will be set to PMT.'" />

			<xsl:apply-templates select="sourceResult/source" mode="ctl"/>
		</ProductMasterDataCatalog_Conf>
		</root>
	</xsl:template>
		<!-- -->
	<xsl:template match="source" mode="object">
		<object>
			<xsl:attribute name="o">
				<xsl:choose>
					<xsl:when test="$localisation='master_global'">
						<xsl:copy-of select="substring-before(substring-after(text(),'outbox/'),'_master_global')"/>
					</xsl:when>
					<xsl:when test="$localisation='none'">
						<xsl:copy-of select="substring-before(substring-after(text(),'outbox/'),'_none')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="substring-before(substring-after(text(),'outbox/'),'.')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</object>
	</xsl:template>
	<xsl:template match="source" mode="ctl">
		<ctl>
			<xsl:attribute name="ct"><xsl:copy-of select="substring-before(substring-after(text(),'outbox/'),'_')"/></xsl:attribute>
			<xsl:attribute name="l">
				<xsl:choose>
					<xsl:when test="$localisation='master_'">
						<xsl:copy-of select="concat('master_',substring(text(),string-length(text())-5,2))"/>
					</xsl:when>
					<xsl:when test="$localisation='locales'">
						<xsl:copy-of select="substring(text(),string-length(text())-8,5)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$localisation"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</ctl>
	</xsl:template>
	
</xsl:stylesheet>