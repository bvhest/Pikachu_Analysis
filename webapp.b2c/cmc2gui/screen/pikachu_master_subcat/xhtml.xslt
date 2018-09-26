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
				<h2>Pika-Chu subcat list</h2>
				<hr/>
				<table>
					<tr>
						<td>CatTree Code</td>
						<td>Subcat Code</td>
						<td>Subcat Name</td>
						<td>CTN count</td>
					</tr>
					<xsl:apply-templates/>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="sql:row">
		<tr>
			<td>
				<xsl:value-of select="sql:catalogcode"/>
			</td>
			<td>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_master_subcat_products?subcat=', sql:subcategorycode)"/></xsl:attribute>
					<xsl:value-of select="sql:subcategorycode"/>
				</a>
			</td>
			<td>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_translatedsubcats?subcatcode=', sql:subcategorycode)"/></xsl:attribute>
					<xsl:value-of select="sql:subcategorycode"/>
				</a>
			</td>
			<td>
				<xsl:value-of select="sql:count"/>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
