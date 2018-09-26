<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:include="http://apache.org/cocoon/include/1.0">
	<xsl:param name="count" as="xs:integer"/>
	<!-- -->
	<xsl:template match="/">
		<root>
			<xsl:call-template name="for.loop">
				<xsl:with-param name="i" select="1"/>
				<xsl:with-param name="count" select="$count"/>
			</xsl:call-template>
		</root>
	</xsl:template>
	<!-- -->
	<xsl:template name="for.loop">
		<xsl:param name="i" as="xs:integer"/>
		<xsl:param name="count" as="xs:integer"/>
		<!--begin_: Line_by_Line_Output -->
		<include:include src="cocoon:/ExecuteSoapCall"/>
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt; xs:integer($count)">
			<xsl:call-template name="for.loop">
				<xsl:with-param name="i" select="$i + 1"/>
				<xsl:with-param name="count" select="$count"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
