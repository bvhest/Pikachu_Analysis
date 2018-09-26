<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ph="http://www.philips.com/catalog/pdl">
	<!-- -->
		<xsl:key name="cached" match="/root/cached/ph:products/ph:product" use="ph:id"/>
		<xsl:key name="new" match="/root/new/ph:products/ph:product" use="ph:id"/>
	
	<!-- -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="new|cached"/>

	<xsl:template match="delta">
		<xsl:copy>
		<ph:products>
			<xsl:for-each select="../new/ph:products/ph:product">
				<xsl:variable name="id" select="ph:id"/>
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
					<ph:status>
						<xsl:choose>
							<xsl:when test="deep-equal(.,key('cached',$id) )">exists</xsl:when>
							<xsl:otherwise>updated</xsl:otherwise>
						</xsl:choose>
					</ph:status>
				</xsl:copy>
			</xsl:for-each>
			
			<xsl:for-each select="../cached/ph:products/ph:product">
				<xsl:variable name="id" select="ph:id"/>
					<xsl:if test="not(key('new',$id))">
					<xsl:copy>
						<xsl:apply-templates select="@*|node()"/>
						<ph:status>exists</ph:status>
					</xsl:copy>
</xsl:if>
			</xsl:for-each>
			</ph:products>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
