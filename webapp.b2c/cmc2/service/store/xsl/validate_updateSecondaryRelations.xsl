<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:*"/>
  <!-- -->
  <xsl:template match="entry">
    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name()='valid')]"/>
      <xsl:choose>
        <xsl:when test="@valid='true'">
          <xsl:choose>
            <xsl:when test="secondary/sql:rowset/sql:error">
              <xsl:attribute name="valid">false</xsl:attribute>
              <result><xsl:value-of select="concat('updateSecondary Failed:', secondary/sql:rowset/sql:error)"/></result>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="valid">true</xsl:attribute>
              <result>OK</result>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="@valid='false'">
          <xsl:copy-of copy-namespaces="no" select="@valid"/>
          <xsl:copy-of copy-namespaces="no" select="result"/>
        </xsl:when>
      </xsl:choose>          
      <xsl:apply-templates select="node()[not(local-name()='result')]"/>            
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
