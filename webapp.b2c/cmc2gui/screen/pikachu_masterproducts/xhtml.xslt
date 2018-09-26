<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="id">0</xsl:param>
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
				<h2>Pika-Chu master product list</h2>
				<hr/>
				<table>
					<tr>
						<td>Product CTN</td>
						<td>Status</td>
						<td>Last Modified</td>
						<td>xUCDM XML</td>
						<td>Broker xUCDM XML</td>
						<td width="100">Catalog</td>
					</tr>
					<xsl:apply-templates/>
				</table>
			</body>
		</html>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:row">
		<tr>
			<td>
				<a target="_blank">
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'icp/pikachu_product_nice/nor_product/','master','/',translate(sql:id,'/','_'),'.html?id=',sql:id)"/></xsl:attribute>
					<xsl:value-of select="sql:id"/>
				</a>
			</td>
			<td>
				<xsl:value-of select="sql:status"/>
			</td>
			<td>
				<xsl:value-of select="sql:lastmodified"/>
			</td>
			<td>
				<a target="_blank">
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'xmlraw/pikachu_product/nor_product/','master','/',translate(sql:id,'/','_'),'.xml?id=',sql:id)"/></xsl:attribute>
					xUCDM
				</a>
			</td>
			<td>
				<a target="_blank">
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'xmlraw/pikachu_product_broker/nor_product/','master','/',translate(sql:id,'/','_'),'.xml?id=',sql:id)"/></xsl:attribute>
					Broker xUCDM
				</a>
			</td>
			<td>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_search_post/search/',translate(sql:id,'/','_'),'?id=',sql:id)"/></xsl:attribute>
					Search
				</a>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
