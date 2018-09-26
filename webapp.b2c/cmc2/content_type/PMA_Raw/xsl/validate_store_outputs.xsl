<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template> 
  <!-- -->
  <xsl:template match="entry[store-outputs/trigger-octl|store-outputs/create-relation]">
    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name()='valid')]"/>
      <xsl:choose>
        <xsl:when test="store-outputs//sql:error">
          <xsl:attribute name="valid">false</xsl:attribute>
          <result>Store Output Warning</result>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="@valid|result"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()[not(local-name()='result')]"/>      
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
