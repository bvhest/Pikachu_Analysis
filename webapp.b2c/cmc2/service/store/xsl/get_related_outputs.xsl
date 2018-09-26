<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

<xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>	

	<xsl:template match="entries">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
			<store-outputs>
				<sql:execute-query>
					<sql:query>	
						select cr.output_content_type, cr.output_localisation
						from ctl_relations cr, content_types ct
						where cr.input_content_type   = '<xsl:value-of select="@ct"/>'
                    and cr.input_localisation   = '<xsl:value-of select="@l"/>'
                    and ct.content_type         = cr.output_content_type
                    and ct.secondary_derivation = 1
					</sql:query>
				</sql:execute-query>
			</store-outputs>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
