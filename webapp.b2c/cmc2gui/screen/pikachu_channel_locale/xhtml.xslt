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
    <xsl:param name="param1"/>
	<xsl:param name="param2"/>
	<xsl:param name="id"/>
	<!-- -->
	<xsl:template match="/root">
		<html>
			<body contentID="content">
				<h2>
					<xsl:value-of select="sql:rowset/sql:row/sql:name"/> product list for <xsl:value-of select="@locale"/>
				</h2>
				<hr/>
				<table padding="2">
					<tr>
						<td>Product CTN</td>
						<td>Preview</td>
						<td>SOP</td>
						<td>EOP</td>
						<td>Var1</td>
						<td>LastModified</td>
						<td>LastTransmit</td>
						<td>Export</td>
						<td>Deleted</td>
					</tr>
					<xsl:apply-templates/>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="sql:node()">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="sql:row/sql:rowset/sql:row">
		<tr>
			<td>
        <a>
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_search_post/',$param1,'/',$param2,'/',translate(sql:id,'/','_'),'.xml?id=',sql:id)"/></xsl:attribute>
          <xsl:value-of select="sql:id"/>
        </a>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="sql:dataavailable=1">
						<a target="_blank">
							<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'icp/pikachu_product_nice/nor_product/',$param2,'/',translate(sql:id,'/','_'),'.html?id=',sql:id)"/></xsl:attribute>
							<xsl:text>Preview</xsl:text>
						</a>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:value-of select="substring(sql:sop,1,10)"/>
			</td>
			<td>
				<xsl:value-of select="substring(sql:eop,1,10)"/>
			</td>
			<td>
				<xsl:value-of select="sql:var1"/>
			</td>
			<td>
				<xsl:value-of select="sql:lastmodified"/>
			</td>
			<td>
				<xsl:value-of select="sql:lasttransmit"/>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="sql:lastmodified &gt; sql:lasttransmit">
						<xsl:text>1</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>0</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:value-of select="sql:deleted"/>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
