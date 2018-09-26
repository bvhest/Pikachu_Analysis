<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:shell="http://apache.org/cocoon/shell/1.0">
	<xsl:param name="cache-folder"/>
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="title">
		<xsl:variable name="titlefilename" select="concat(@refid,'.xml')" />
		<delta>
			<new>
				<xsl:copy copy-namespaces="no">
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</new>
			<cache>
				<cinclude:include src="{concat('cocoon:/readFile/', $cache-folder, '/', $titlefilename)}"/>
			</cache>
		</delta>
	</xsl:template>
</xsl:stylesheet>
