<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:param name="dir"/>

	<xsl:template match="entry[@valid='true']">
	<xsl:variable name="docStatus" select="octl-attributes/status"/>
	<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source>
				<xsl:value-of select="concat($dir,'/',@ct,'/outbox/',@ct,'.',@o,'.', $docStatus/text(),'.',@l,'.pdf')"/> 
			</source:source>
			<source:fragment>
					<xsl:copy-of select="content/node()"/>
			</source:fragment>
		</source:write>
	</xsl:template>
	<!-- -->
	<xsl:template match="entry[@valid='false']"/><!-- erase everything else -->
</xsl:stylesheet>