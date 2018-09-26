<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:source="http://apache.org/cocoon/source/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="pipeline"/>
	<xsl:param name="dir"/>
	<xsl:variable name="importdate"><xsl:value-of select="format-dateTime(current-dateTime(),'[Y,4][M,2][D,2][H,2][m,2][s,2]')"/></xsl:variable>
<!-- -->
	<xsl:template match="/">
    <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
     <source:source><xsl:value-of select="$dir"/><xsl:text>logs/Report_</xsl:text><xsl:value-of select="$importdate"/><xsl:text>.xml</xsl:text></source:source>      
      <source:fragment>
		<report>
			<!--<xsl:attribute name="reportId"><xsl:value-of select="$reportId"/></xsl:attribute>-->
			<xsl:attribute name="reportId"><xsl:value-of select="$importdate"/></xsl:attribute>
			<xsl:attribute name="pipeline"><xsl:value-of select="$pipeline"/></xsl:attribute>
			<xsl:apply-templates select="//entry"/>
		</report>
	 </source:fragment>
    </source:write>
	</xsl:template>
<!-- -->
	<xsl:template match="entry">
		<xsl:variable name="status">
			<xsl:choose>
				<xsl:when test="./sql:rowset/sql:row">Success</xsl:when>
				<xsl:when test="./sql:rowset/sql:error">Failure</xsl:when>
				<xsl:otherwise>Unknown</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="comments">
			<xsl:choose>
				<xsl:when test="./sql:rowset/sql:row"><xsl:value-of select="./sql:rowset/sql:row"/></xsl:when>
				<xsl:when test="./sql:rowset/sql:error"><xsl:value-of select="./sql:rowset/sql:error"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		<item>
			<id><xsl:value-of select="@id"/></id>
			<locale><xsl:value-of select="@locale"/></locale>
			<result><xsl:value-of select="$status"/></result>
			<remark><xsl:value-of select="$comments"/></remark>
		</item>
	</xsl:template>
<!-- -->
</xsl:stylesheet>