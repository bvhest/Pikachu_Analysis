<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i="http://apache.org/cocoon/include/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:param name="timestamp"/>
	<xsl:param name="locale"/>
	<xsl:template match="/">
		<xsl:element name="root">
			<xsl:apply-templates select="//sql:rowset/sql:row[sql:batch!='']"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="sql:row">
		<xsl:variable name="batch" select="sql:batch" as="xs:integer"/>
		<xsl:variable name="timestampint" select="xs:integer($timestamp)"/>
		<xsl:variable name="runtimestamp" select="$timestampint + ($batch - 1)"/>
		<xsl:element name="i:include">
			<xsl:attribute name="src">cocoon:/exportSub.<xsl:value-of select="$timestamp"/>.<xsl:value-of select="$locale"/>.<xsl:value-of select="sql:batch"/>.<xsl:value-of select="sql:maxbatchnumber"/></xsl:attribute>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
