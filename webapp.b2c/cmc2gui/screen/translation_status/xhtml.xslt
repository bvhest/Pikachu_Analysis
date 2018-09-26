<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="gui_url"/>
	<xsl:param name="exportdate"/>
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
				<h2>Translation Status for products exported on <xsl:value-of select="replace($exportdate,'(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})','$1-$2-$3 $4:$5:$6')"/> per locale</h2>
				<hr/>
				<table class="main">
					<tr>
                      <td>Locale</td>
                      <td>ToDo-Count</td>
                      <td>Out-Count</td>
                      <td>In-Count</td>
                      <td>Percentage returned</td>
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
				<xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl,'translation_status_detail/', sql:locale)"/></xsl:attribute>
				<xsl:value-of select="sql:locale"/>
			</a>
		</td>
		<td>
				<xsl:value-of select="sql:todocount"/>
		</td>
		<td>
				<xsl:value-of select="sql:outcount"/>
		</td>
		<td>
				<xsl:value-of select="sql:incount"/>
		</td>
		<td>
				<xsl:value-of select="sql:percentage"/>
		</td>
	</tr>
	</xsl:template>
</xsl:stylesheet>
