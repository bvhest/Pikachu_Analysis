<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:email="http://apache.org/cocoon/transformation/sendmail"
    xmlns:i="http://apache.org/cocoon/include/1.0">
  
  <xsl:param name="process"/>
    
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/report">
    <xsl:copy copy-namespaces="no">
      <xsl:choose>
        <xsl:when test="@error-count = '0'">
          <xsl:attribute name="name" select="$process"/>
          <i:include src="{$process}"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="@*|node()"/>
          <email:sendmail>
            <email:subject>PMT_Raw: copy inbox failed</email:subject>
            <email:body mime-type="text/plain">
              <xsl:text>Total number of files: </xsl:text>
              <xsl:value-of select="@total-count"/><xsl:text>
</xsl:text>
              <xsl:text>Files copied: </xsl:text>
              <xsl:value-of select="@success-count"/><xsl:text>
</xsl:text>              
              <xsl:text>Failed: </xsl:text>
              <xsl:value-of select="@error-count"/><xsl:text>

</xsl:text>
              <xsl:text>Failures:
</xsl:text>
              <xsl:for-each select="errors/source">
                <xsl:value-of select="substring-before(text(), ' to ')"/>
                <xsl:text>
</xsl:text>
              </xsl:for-each>
            </email:body>
          </email:sendmail>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>