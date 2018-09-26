<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="gui_url"/>
	<xsl:param name="exportdate"/>
	<xsl:param name="param1"/>
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
				<h2>Translation Progress Detail for <xsl:value-of select="$exportdate"/> - <xsl:value-of select="$param1"/>
				</h2>
				<hr/>
				<table padding="2">
					<tr>
						<td>CTN&#160;</td>
						<td>Search&#160;</td>
						<td>Containing&#160;File&#160;</td>
						<td>TE&#160;date&#160;</td>
						<td>TI&#160;date</td>
					</tr>
					<xsl:apply-templates/>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="sql:row">
		<tr>
			<td>
				<a target="_blank">
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'icp/pikachu_product_nice/nor_product/','master','/',translate(sql:ctn,'/','_'),'.html?id=',sql:ctn)"/></xsl:attribute>
					<xsl:value-of select="sql:ctn"/>
				</a>
			</td>
			<td>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'section/home/pikachu_search_post/search?id=',sql:ctn)"/></xsl:attribute>
					Search
				</a>
			</td>
			<td>
		<a target="blank">
		<xsl:attribute name="href"><xsl:value-of select="concat($gui_url, 'pikachu_pals_get_file/upload/',sql:remark,'?file=',sql:remark)"/></xsl:attribute>
		<xsl:value-of select="sql:remark"/>
		</a>			
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="sql:exportdate gt sql:importdate">
						<xsl:attribute name="bgcolor">#FF0000</xsl:attribute>
					</xsl:when>
					<xsl:when test="sql:exportdate le sql:importdate">
						<xsl:attribute name="bgcolor">#00FF00</xsl:attribute>
					</xsl:when>
				</xsl:choose>			
				<xsl:value-of select="sql:exportdate"/>
			</td>
			<td>
				<xsl:value-of select="sql:importdate"/>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
