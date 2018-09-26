<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="id">0</xsl:param>
	<xsl:param name="gui_url"/>	
    <xsl:variable name="sectionurl">
	  <xsl:if test="$section">
		<xsl:value-of select="concat('section/', $section, '/')"/>
	  </xsl:if>
    </xsl:variable>		
	<xsl:template match="/root">
		<html>
			<body contentID="content">
				<h2>Translated Subcats</h2>
				<hr/>
				<table padding="2">
					<tr>
			            <td>Locale</td>
			            <td>Subcategory</td>
			            <td>Category</td>
			            <td>Group</td>
						<td>Catalog</td>
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
				<xsl:value-of select="sql:locale"/>
			</a>
		</td>
		<td>
			<a>
				<xsl:value-of select="sql:subcategoryname"/>
			</a>
		</td>
		<td>
			<a>
				<xsl:value-of select="sql:categoryname"/>
			</a>
		</td>
		<td>
			<a>
				<xsl:value-of select="sql:groupname"/>
			</a>
		</td>
		<td>
			<a>
				<xsl:value-of select="sql:catalogname"/>
			</a>
		</td>
	</tr>
	</xsl:template>
</xsl:stylesheet>
