<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0">

	<xsl:template match="/">
    <xsl:choose>
      <xsl:when test="octl/sql:rowset/sql:row/sql:data/Product">
  		  <xsl:copy-of select="octl/sql:rowset/sql:row/sql:data/Product"/>
      </xsl:when>
      <xsl:otherwise>
        <Products>
          <xsl:copy-of select="sql:rowset/sql:row/sql:data/Product"/>
        </Products>
      </xsl:otherwise>
    </xsl:choose>    
	</xsl:template>
	
</xsl:stylesheet>