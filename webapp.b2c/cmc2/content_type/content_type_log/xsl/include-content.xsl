<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="svcURL"/>
	
	<xsl:template match="@*|node()">
	    <xsl:copy copy-namespaces="no">
	      <xsl:apply-templates select="@*|node()"/>
	    </xsl:copy>
  	</xsl:template> 

	
	<xsl:template match="content">
		<xsl:copy>
			<i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get/content_type_definition/{../@l}/{../@o}"/>
		</xsl:copy>
	</xsl:template>

	
</xsl:stylesheet>