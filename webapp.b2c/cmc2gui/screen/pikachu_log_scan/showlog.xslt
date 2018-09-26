<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml D:\eman.net\cocoon\build\webapp\othello\tasks\export\blocks_step1_test.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
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
	<xsl:param name="param3"/>
	<xsl:param name="id"/>
	<xsl:param name="locale"/>
	<xsl:param name="reporttype"/>
	<xsl:template match="/dir:directory">
		<html>
			<body>
				<h2>
					<xsl:value-of select="$param1"/>
					<xsl:text> - </xsl:text>
					<xsl:value-of select="$id"/>
					<xsl:text> - </xsl:text>
					<xsl:value-of select="$locale"/>
				</h2>
				<hr/>
				<table>
					<tr>
						<td width="100">Filename</td>
						<td width="100">Filedate</td>
						<td width="100">ID</td>
						<td width="100">Locale</td>
						<td width="100">Result</td>
						<td>Remark</td>
					</tr>
					<xsl:apply-templates select="dir:file/dir:xpath/item"/>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="body|html">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	<xsl:template match="head">
  </xsl:template>
	<xsl:template match="item">
		<tr>
			<td>
				<xsl:value-of select="../../@name"/>
			</td>
			<td>
				<xsl:value-of select="../../@date"/>
			</td>
			<td>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url, 'section/home/pikachu_search_post?id=', id)"/></xsl:attribute>
					<xsl:value-of select="id"/>
				</a>
			</td>
			<td>
				<xsl:value-of select="locale"/>
			</td>
			<td>
				<xsl:value-of select="result"/>
			</td>
			<td>
				<xsl:value-of select="remark"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="@*|node()">
  </xsl:template>
</xsl:stylesheet>
