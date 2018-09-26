<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:param name="svcURL"/>
	
	<xsl:template match="sql:*"/>
	
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="entry[@valid='true']">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
			<currentcontent>
				<i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}/common/get/{@ct}/{@l}/{@o}"/>
			</currentcontent>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
