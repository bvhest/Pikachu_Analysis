<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	
	<xsl:param name="file"/>

<xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>	


	<xsl:template match="store-outputs">
		<store-outputs>
			<xsl:apply-templates select="sql:rowset/sql:row"/>
		</store-outputs>
	</xsl:template>

	<xsl:template match="sql:rowset/sql:row">
				<cinclude:include src="{concat('cocoon:/secTransform/',sql:output_content_type,'/',$file) }" />
	</xsl:template>
  
</xsl:stylesheet>