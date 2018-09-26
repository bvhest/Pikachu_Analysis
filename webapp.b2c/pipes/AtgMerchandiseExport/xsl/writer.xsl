<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:ph="http://www.philips.com/catalog/pdl">
	<xsl:param name="cacheFile"/>
	<xsl:param name="outboxFile"/>
	<!-- -->
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="ph:status"/>
	<xsl:template match="/root/delta">
		<root>
			<source:write>
				<source:source>
					<xsl:value-of select="$outboxFile"/>
				</source:source>
				<source:fragment>
					<xsl:for-each select="ph:products">
						<xsl:copy copy-namespaces="no">
							<xsl:apply-templates select="@*"/>
							<xsl:for-each select="ph:product[not(ph:status='exists')]">
								<xsl:copy copy-namespaces="no">
									<xsl:apply-templates select="@*|node()"/>
								</xsl:copy>
							</xsl:for-each>
						</xsl:copy>
					</xsl:for-each>
				</source:fragment>
			</source:write>
			<source:write>
				<source:source>
					<xsl:value-of select="$cacheFile"/>
				</source:source>
				<source:fragment>
					<xsl:for-each select="ph:products">
						<xsl:copy copy-namespaces="no">
							<xsl:for-each select="ph:product">
								<xsl:copy copy-namespaces="no">
									<xsl:apply-templates select="@*|node()"/>
								</xsl:copy>
							</xsl:for-each>
						</xsl:copy>
					</xsl:for-each>
				</source:fragment>
			</source:write>
		</root>
	</xsl:template>
</xsl:stylesheet>
