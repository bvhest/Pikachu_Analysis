<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:cmc2-f="http://www.philips.com/cmc2-f" extension-element-prefixes="cmc2-f"  >
	<xsl:param name="dir"/>
	
  <xsl:include href="../../../xsl/common/cmc2.function.xsl"/>

	<xsl:template match="/entries">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="globalDocs">
	<xsl:variable name="processTimestamp" select="cmc2-f:formatDate(../@ts)" />
		<xsl:copy>			
			<xsl:if test="../entry[@valid='true']/content/Product/KeyValuePairs">
				<source:write>
					<source:source>
						<xsl:value-of select="concat($dir,'/KeyValuePairs/inbox/KeyValuePairs_',../@batchnumber,'_',../@ts,'.xml')"/>
					</source:source>
					<source:fragment>
						<KeyValuePairs DocStatus="approved" DocTimeStamp="{$processTimestamp}">
							<xsl:for-each select="../entry[@valid='true']/content/Product[KeyValuePairs]">
								<!--xsl:for-each select="entry/content/Product"-->
								<object IsMaster="true" code="{CTN}" lastModified="{@lastModified}" masterLastModified="{@masterLastModified}" object_id="{CTN}">
									<xsl:apply-templates select="KeyValuePairs/KeyValuePair"/>
								</object>
							</xsl:for-each>
						</KeyValuePairs>
					</source:fragment>
				</source:write>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="KeyValuePairs"/>
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
