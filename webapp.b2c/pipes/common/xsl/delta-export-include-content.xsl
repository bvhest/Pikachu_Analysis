<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i="http://apache.org/cocoon/include/1.0">

  <xsl:param name="source"/>
  
  <xsl:template match="/delta-compare">
    <delta-compare name="{replace($source, '.*/(.*?\.xml)', '$1')}">
      <source>
        <xsl:sequence select="child::element()[1]"/>
      </source>
      <cache>
        <xsl:sequence select="child::element()[2]"/>
      </cache>
    </delta-compare>
  </xsl:template>

</xsl:stylesheet>