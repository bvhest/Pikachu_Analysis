<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i="http://apache.org/cocoon/include/1.0">

	<xsl:param name="svcURL"/>
  <xsl:param name="xmlDir"/>
  <xsl:param name="test"/>  

	
<xsl:template match="/entries">
	<entries>
		<xsl:copy-of select="@*"/>
		<globalDocs>
      <division><xsl:value-of select="@division"/></division>
      <translatedAttributes>
        <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$xmlDir}translated_attributes.xml"/>    
      </translatedAttributes>    
		</globalDocs>
		<xsl:apply-templates/>
	</entries>
</xsl:template>
		
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>