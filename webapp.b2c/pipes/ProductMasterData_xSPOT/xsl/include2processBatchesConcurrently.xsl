<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:i="http://apache.org/cocoon/include/1.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="locale"/>
  <xsl:param name="ts"/>
  <xsl:param name="start"/>
  <xsl:param name="end"/>

  <xsl:template match="/">
    <root>
      <xsl:for-each select="number($start) cast as xs:integer to number($end) cast as xs:integer">
        <i:include src="cocoon:/processBatch.{$ts}.{$locale}.{.}"/>
      </xsl:for-each>
    </root>
  </xsl:template>
</xsl:stylesheet>