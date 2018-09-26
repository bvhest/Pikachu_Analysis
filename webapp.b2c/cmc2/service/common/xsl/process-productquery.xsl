<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                exclude-result-prefixes="fn sql">

  <xsl:template match="/sql:rowset">
    <Products>
      <xsl:apply-templates select="sql:row/sql:data/Product"/>
    </Products>
  </xsl:template>

  <xsl:template match="Product">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of copy-namespaces="no" select="@*|node()"/>
  		<Categorization>
  			<GroupCode>
  				<xsl:value-of select="ancestor::sql:row/sql:groupcode" />
  			</GroupCode>
  			<CategoryCode>
  				<xsl:value-of select="ancestor::sql:row/sql:categorycode" />
  			</CategoryCode>
  			<SubcategoryCode>
  				<xsl:value-of select="ancestor::sql:row/sql:subcategorycode" />
  			</SubcategoryCode>
  		</Categorization>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>