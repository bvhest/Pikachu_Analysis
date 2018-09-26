<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="gui_url"/>
	<xsl:param name="param1"/>
  <xsl:param name="section"/>
  <xsl:variable name="sectionurl">
	<xsl:if test="$section">
	  <xsl:value-of select="concat('section/', $section, '/')"/>
	</xsl:if>
  </xsl:variable>  
	<xsl:variable name="channel" select="/root/sql:rowset/sql:row/sql:id"/>
	<!-- -->
	<xsl:template match="/root">
		<html>
			<body contentID="content">
				<xsl:if test="$param1 = ''">
					<h2>Select a channel first!!</h2>
				</xsl:if>
				<xsl:if test="$param1 != ''">
					<h2>
						<xsl:value-of select="sql:rowset/sql:row/sql:name"/> - confirm deletion</h2>
					<hr/>
					<p>Deletion of a channel means that the channel definition is removed from the database.</p>
					<p>This does however not mean that the data directories are removed or that the cocoon channel files (pipes/..) are removed.</p>
					<br/>
					<a>
						<xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_channel_delete_real/', $param1, '?channel=', $channel)"/></xsl:attribute>Continue</a>
				</xsl:if>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="sql:node()">
		<xsl:apply-templates/>
	</xsl:template>
</xsl:stylesheet>
