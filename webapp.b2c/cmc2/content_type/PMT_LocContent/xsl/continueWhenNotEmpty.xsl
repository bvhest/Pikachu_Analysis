<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:i="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="process"/> 

  <xsl:template match="/">
    <root name="{$process}">
      <xsl:if test="exists(//dir:file[1])">
        <i:include>
          <xsl:attribute name="src">
            <xsl:value-of select="$process"/>
          </xsl:attribute>
        </i:include>
      </xsl:if>
    </root>
  </xsl:template>
  
</xsl:stylesheet>