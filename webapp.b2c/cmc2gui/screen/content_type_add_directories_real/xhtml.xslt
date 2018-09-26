<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="param1"/>
	<xsl:param name="channel"/>
	<xsl:template match="/root">
		<html>
			<body contentID="content">
				<h2>Add channel directories - result</h2>
				<xsl:for-each select="//source">
					<p>
						<xsl:value-of select="node()"/>
					</p>
					<xsl:if test="../message!=''">
						<br/>
						<b>
							<xsl:text>message: </xsl:text>
						</b>
						<xsl:value-of select="../message"/>
						<br/>
					</xsl:if>
				</xsl:for-each>
				<br/>
				<p>done creating directories</p>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="sql:node()">
		<xsl:apply-templates/>
	</xsl:template>
</xsl:stylesheet>
