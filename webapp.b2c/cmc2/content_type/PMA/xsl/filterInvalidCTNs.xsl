<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:variable name="output_ct" select="'PMT'"/>  
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="entries">
    <xsl:key name="k_outputoctls" match="globalDocs/currentoctls[@content_type=$output_ct]/sql:rowset/sql:row/sql:object_id" use="."/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="entry[@valid='false'][result='No Placeholder']">
    <xsl:variable name="o" select="@o"/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*[not(local-name()='valid')] "/>
      <xsl:choose>
        <xsl:when test="key('k_outputoctls',$o)">
          <xsl:attribute name="valid">false</xsl:attribute>
          <xsl:element name="result">No Placeholder</xsl:element>
          <xsl:apply-templates select="node()[not(local-name()='result')] "/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="valid">false</xsl:attribute>
          <xsl:element name="result">PMT OCTL does not exist</xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>