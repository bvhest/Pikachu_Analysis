<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:shell="http://apache.org/cocoon/shell/1.0">
  
  <xsl:param name="source"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="delta-compare">
    <xsl:variable name="new-content">
      <object>
        <xsl:sequence select="source/*"/>
      </object>
    </xsl:variable>
    <xsl:variable name="cached-content">
      <object>
        <xsl:sequence select="cache/*"/>
      </object>
    </xsl:variable>
    
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
        <xsl:when test="deep-equal($cached-content,$new-content)">
          <xsl:attribute name="status" select="'identical'"/>
          <shell:delete>
            <shell:source>
              <xsl:value-of select="$source" />
            </shell:source>
          </shell:delete>
        </xsl:when>
        <xsl:when test="empty($cached-content/object/*)">
          <xsl:attribute name="status" select="'new'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="status" select="'modified'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>  
    
</xsl:stylesheet>
