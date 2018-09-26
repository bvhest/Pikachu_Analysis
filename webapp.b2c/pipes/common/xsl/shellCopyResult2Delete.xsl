<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:shell="http://apache.org/cocoon/shell/1.0">

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="shellResult[action='copied' and execution='success']">
    <xsl:variable name="source" select="normalize-space(substring-before(source, ' to '))"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
    
    <shell:delete>
      <shell:source>
        <xsl:value-of select="$source" />
      </shell:source>
    </shell:delete>
  </xsl:template>

</xsl:stylesheet>