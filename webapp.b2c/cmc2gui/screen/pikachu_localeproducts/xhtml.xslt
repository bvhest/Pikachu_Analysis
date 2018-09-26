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
  	<xsl:param name="param1"/>
	<xsl:variable name="locale" select="$param1"/>
<!-- -->  
	<xsl:template match="/root">
		<html>
			<body contentID="content">
				<h2>Pika-Chu product list for <xsl:value-of select="@locale"/>
				</h2>
				<hr/>
				<table padding="2">
					<tr>
						<td>Product CTN</td>
						<td> xUCDM-XML </td>
						<td> Catalog </td>
						<td> Status</td>
						<td> Last Modified</td>
						<td> Division</td>
						<td> SOP</td>
						<td> EOP</td>
						<td> Available</td>
					</tr>
					<xsl:apply-templates/>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="sql:row">
		<xsl:choose>
			<xsl:when test="sql:dataavailable=1">
				<tr>
					<td>
				<a target="_blank">
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'icp/pikachu_product_nice/nor_product/',$locale,'/',translate(sql:id,'/','_'),'.html?id=',sql:id)"/></xsl:attribute>
					<xsl:value-of select="sql:id"/>
				</a>
					</td>
					<td>
				<a target="_blank">
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'xmlraw/pikachu_product/nor_product/',$locale,'/',translate(sql:id,'/','_'),'.xml?id=',sql:id)"/></xsl:attribute>
					<xsl:value-of select="sql:id"/>
				</a>
					</td>
					<td>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_search_post/search/',translate(sql:id,'/','_'),'?id=',sql:id)"/></xsl:attribute>
					Search
				</a>					</td>
					<td>
						<xsl:value-of select="sql:status"/>
					</td>
					<td>
						<xsl:value-of select="substring(sql:lastmodified,1,19)"/>
					</td>
					<td>
						<xsl:value-of select="sql:division"/>
					</td>
					<td>
						<xsl:value-of select="substring(sql:sop,1,10)"/>
					</td>
					<td>
						<xsl:value-of select="substring(sql:eop,1,10)"/>
					</td>
					<td>Loaded</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td>
						<xsl:value-of select="sql:id"/>
					</td>
					<td/>					
					<td>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_search_post/search/',translate(sql:id,'/','_'),'?id=',sql:id)"/></xsl:attribute>
					Search
				</a>					</td>
					<td/>
					<td/>
					<td>
						<xsl:value-of select="sql:division"/>
					</td>
					<td>
						<xsl:value-of select="substring(sql:sop,1,10)"/>
					</td>
					<td>
						<xsl:value-of select="substring(sql:eop,1,10)"/>
					</td>
					<td>In LCB but NoData</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
