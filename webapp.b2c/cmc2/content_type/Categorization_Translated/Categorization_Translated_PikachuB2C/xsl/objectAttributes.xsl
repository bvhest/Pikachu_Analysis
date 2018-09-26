<xsl:stylesheet version="2.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   xmlns:sql="http://apache.org/cocoon/SQL/2.0">
    
  <xsl:param name="category"/>  
	<!-- -->    
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="entry">
    <xsl:copy>
		<xsl:attribute name="category" select="$category"/>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>  
  </xsl:template>

	    <xsl:template match="Categorization ">
    <xsl:copy>
      <xsl:apply-templates select="@*[not(local-name()='lastModified' or local-name()='masterLastModified')]"/>
      <!--xsl:attribute name="Division" select="CE"/-->
	  <xsl:attribute name="masterLastModified" select="../../octl-attributes/masterlastmodified_ts"/>  
	  <xsl:attribute name="lastModified" select="../../octl-attributes/lastmodified_ts"/>       
      <xsl:apply-templates select="node()"/>
    </xsl:copy>  
  </xsl:template>
  
</xsl:stylesheet>