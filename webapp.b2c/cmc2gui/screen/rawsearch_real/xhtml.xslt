<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml test.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="gui_url"/>
	<xsl:param name="section"/>
	<xsl:variable name="sectionurl">
		<xsl:if test="$section">
			<xsl:value-of select="concat('section/', $section, '/')"/>
		</xsl:if>
	</xsl:variable>
	<xsl:param name="channel"/>
	<!-- -->
	<xsl:template match="/root">
		<html>
			<body contentID="content">
				<h2>Pikachu Text Search result</h2><hr/>
				<table>
					<tr>
						<td>Product CTN</td>
						<td>xUCDM XML</td>
						<td>Broker xUCDM&#160;</td>
						<td>Product Search</td>
					</tr>
					<xsl:apply-templates/>
				</table>
				<p>done</p>
			</body>
		</html>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:row">
			<tr>
				<td>
					<a target="_blank">
						<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'icp/pikachu_product_nice/nor_product/',sql:locale,'/',translate(sql:id,'/','_'),'.html?id=',sql:id)"/></xsl:attribute>
						<xsl:value-of select="sql:id"/>
					</a>
				</td>
				<td>
					<a target="_blank">
						<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'xmlraw/pikachu_product/nor_product/',sql:locale,'/',translate(sql:id,'/','_'),'.html?id=',sql:id)"/></xsl:attribute>
					xUCDM
				</a>
				</td>
				<td>
					<a target="_blank">
						<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'xmlraw/pikachu_product_broker/nor_product/',sql:locale,'/',translate(sql:id,'/','_'),'.html?id=',sql:id)"/></xsl:attribute>
					Broker xUCDM
				</a>
				</td>
				<td>
					<a>
						<xsl:attribute name="href"><xsl:value-of select="concat($gui_url, 'section/home/pikachu_search_post?id=', sql:id)"/></xsl:attribute>
						Search
					</a>
				</td>
			</tr>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:node()">
		<xsl:apply-templates/>
	</xsl:template>
</xsl:stylesheet>
