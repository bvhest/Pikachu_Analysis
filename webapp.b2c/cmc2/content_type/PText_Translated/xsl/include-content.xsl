<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="svcURL"/>
	<xsl:param name="o"/>
	<xsl:param name="ct"/>
	<xsl:param name="l"/>

	<xsl:template match="content[../@valid='true']">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
			<i:include xmlns:i="http://apache.org/cocoon/include/1.0"  src="{$svcURL}common/get/{$ct}/{$l}/{$o}"/>
			<configuration>
				<i:include xmlns:i="http://apache.org/cocoon/include/1.0"  src="{$svcURL}common/get/PP_Log/none/{$o}"/>
			</configuration>
		</xsl:copy>
	</xsl:template>
	
  	<xsl:template match="@*|node()">
	   <xsl:copy copy-namespaces="no">
	      <xsl:apply-templates select="@*|node()"/>
	   </xsl:copy>
  	</xsl:template> 
		
</xsl:stylesheet>