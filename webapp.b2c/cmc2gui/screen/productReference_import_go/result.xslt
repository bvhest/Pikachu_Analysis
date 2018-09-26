<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/shellResult">
		<html>
			<body>
				<xsl:choose>
					<xsl:when test="execution!='success'">
						<p style="color: red">
							<xsl:value-of select="message"/>
						</p>
					</xsl:when>
					<xsl:otherwise>
						<p>
							<xsl:value-of select="message"/>
						</p>
						<p>
							<xsl:value-of select="source"/>
						</p>
					</xsl:otherwise>
				</xsl:choose>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
