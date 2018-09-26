<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

	<xsl:param name="svcURL"/>
  
  	<xsl:template match="@*|node()">
	    <xsl:copy copy-namespaces="no">
	      <xsl:apply-templates select="@*|node()"/>
	    </xsl:copy>
  	</xsl:template> 
	<!-- -->
	<xsl:template match="content[../@valid='true']">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:rowset">
		<xsl:apply-templates select="node()"/>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:row">
		<secondary>
			<i:include xmlns:i="http://apache.org/cocoon/include/1.0"  src="{$svcURL}common/get/{sql:input_content_type}/{sql:input_localisation}/{sql:input_object_id}"/>
		</secondary>
	</xsl:template>
	
</xsl:stylesheet>