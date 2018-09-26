<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:source="http://apache.org/cocoon/source/1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="dir">test</xsl:param>
	<xsl:param name="svcURL">test</xsl:param>
	
	<xsl:template match="*">
		<xsl:element name="{local-name()}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="entry">
		<xsl:variable name="obj" select="replace(@o,'/','_' )"/>
		<source:write >
				<source:source>
				<xsl:value-of select="concat($dir,'/',@ct,'/outbox/',$obj,'.',@ct,'.',@l,'.',../@ts,'.xml')"/> 
				</source:source>
						<source:fragment>
							<i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}/common/get/{@ct}/{../@l}/{@o}"/>
						</source:fragment>
		</source:write>
	</xsl:template>

</xsl:stylesheet>
