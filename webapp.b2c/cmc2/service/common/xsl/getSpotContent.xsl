<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0">

	<xsl:template match="/">
    <xsl:choose>
      <xsl:when test="octl/sql:rowset/sql:row/sql:data/Product">
		    <xsl:apply-templates select="octl/sql:rowset/sql:row/sql:data/Product"/>
      </xsl:when>
      <xsl:otherwise>
        <error>The requested object was not found</error>
      </xsl:otherwise>
    </xsl:choose>
	</xsl:template>
	
	<xsl:template match="Product">
		<xsl:copy>
			<xsl:copy-of select="@*[not(local-name='Locale')]"/>
			<xsl:choose>
			<xsl:when test="ancestor::sql:row/sql:content_type='PMT_Enriched'">
				<xsl:attribute name="Locale" select="'en_Philips'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="@Locale"/>
			</xsl:otherwise>
		</xsl:choose>
			<xsl:copy-of select="node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>