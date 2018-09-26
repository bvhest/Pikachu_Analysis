<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ct"/>
  <xsl:param name="timestamp"/>
  <!--  -->    
  <xsl:template match="/">
    <root>
      <xsl:choose>
        <xsl:when test="dir:directory/dir:file">
          <cinclude:include src="cocoon:/processFiles/{$ct}/{$timestamp}"/>
        </xsl:when>
        <xsl:otherwise>
          <!--cinclude:include src="cocoon:/reprocessExistingContent/{$ct}/{$timestamp}"/-->
        </xsl:otherwise>    
      </xsl:choose>    
    </root>
  </xsl:template>
  <!--  -->
</xsl:stylesheet>