<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">

	<xsl:template match="marketing-raw">
		<marketing-text o="{@o}" ct="marketing_text" l="{@l}">
			<xsl:copy-of select="*"/>
		</marketing-text>
	</xsl:template>
	
	<xsl:template match="@*|node()">
		<xsl:apply-templates/>
	</xsl:template>
	

</xsl:stylesheet>