<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="threshold"/>
  <xsl:param name="ts"/>
	<xsl:template match="/">
    <root>
      <xsl:variable name="changedProductCount" select="count(root/FilterProduct[text()='not equal'])"/>
      <xsl:choose>
        <xsl:when test="$changedProductCount  gt number($threshold)">
          <cinclude:include src="cocoon:/stop?filecount={$changedProductCount}"/>
        </xsl:when>
        <xsl:otherwise>
          <cinclude:include src="cocoon:/go/{$ts}"/>
        </xsl:otherwise>
      </xsl:choose>
    </root>
	</xsl:template>
</xsl:stylesheet>