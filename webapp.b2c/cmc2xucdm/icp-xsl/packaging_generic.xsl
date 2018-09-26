<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="generic.xsl"/>
	
	<xsl:template name="display-packaging-text-item">
		<xsl:param name="text-item"/>
		<xsl:param name="include-source" select="false()"/>
		
		<dl class="packaging_text_item">
			<dt>
				<xsl:value-of select="$text-item/@itemDescription"/>
				<xsl:value-of select="concat(' [',$text-item/@code,']')"/>
			</dt>
			<dd>
				<xsl:if test="$include-source">
					<p><xsl:call-template name="display-text">
						<xsl:with-param name="text-node" select="source/ItemText"/>
					</xsl:call-template></p>
				</xsl:if>
				<p><xsl:call-template name="display-text">
					<xsl:with-param name="text-node" select="ItemText"/>
				</xsl:call-template></p>
			</dd>
		</dl>
	</xsl:template>
</xsl:stylesheet>
