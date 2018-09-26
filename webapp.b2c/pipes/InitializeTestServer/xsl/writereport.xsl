<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:source="http://apache.org/cocoon/source/1.0">

  <xsl:param name="dest"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
      
  <xsl:template match="/">
    <source:write>
      <source:source>
        <xsl:value-of select="$dest"/>
      </source:source>
      <source:fragment>
        <xsl:apply-templates match="@*|node()"/>
      </source:fragment>
    </source:write>
  </xsl:template>
</xsl:stylesheet>