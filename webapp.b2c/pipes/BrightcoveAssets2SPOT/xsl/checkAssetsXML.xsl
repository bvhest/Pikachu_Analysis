<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:choose>
        <xsl:when test="ProductsMsg/Product">
          <cinclude:include src="cocoon:/go"/>
        </xsl:when>
        <xsl:otherwise>
          <cinclude:include src="cocoon:/stop"/>
        </xsl:otherwise>
      </xsl:choose>
    </root>
  </xsl:template>
</xsl:stylesheet>