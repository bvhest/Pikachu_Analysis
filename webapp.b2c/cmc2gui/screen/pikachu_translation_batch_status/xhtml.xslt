<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="gui_url"/>
    <xsl:param name="section"/>
    <xsl:variable name="sectionurl">
	  <xsl:if test="$section">
		<xsl:value-of select="concat('section/', $section, '/')"/>
	  </xsl:if>
    </xsl:variable>	
	<!-- -->
	<xsl:template match="/root">
		<html>
			<body contentID="content">
				<h2>Translation Progress</h2>
				<hr/>
				<table padding="2">
					<tr>
			            <td>Translation Export Date&#160;</td>
			            <td>Count&#160;</td>
			            <td>Percentage</td>
			        </tr>
					<xsl:apply-templates/>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="sql:row">
	<tr>
		<td>
			<a>
				<xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_translation_export_status?exportdate=', sql:exportdate)"/></xsl:attribute>
				<xsl:value-of select="sql:exportdate"/>
			</a>
		</td>
		<td>
				<xsl:value-of select="sql:count"/>
		</td>
		<td>
				<xsl:value-of select="replace(sql:percentage, '(\d*\.\d{2}).*', '$1')"/>
		</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
