<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:i="http://apache.org/cocoon/include/1.0"
	>

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
  <xsl:param name="process" />

  <xsl:template match="/">
    <root>
      <xsl:apply-templates select="//dir:file" />
    </root>
  </xsl:template>

  <xsl:template match="dir:file">
    <i:include>
      <xsl:attribute name="src">
        <xsl:value-of select="concat($process,'/',../@name,'/',@name)"/>
      </xsl:attribute>
    </i:include>
  </xsl:template>

</xsl:stylesheet>