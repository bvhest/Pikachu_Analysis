<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:dir="http://apache.org/cocoon/directory/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="dir"/>
  <xsl:template match="/">
    <log>
      <xsl:apply-templates select="/root/row"/>
    </log>
  </xsl:template>
  <!-- -->
  <xsl:template match="row">
    <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
      <source:source>
        <xsl:value-of select="concat($dir, locale, '.xml')"/>
      </source:source>
      <source:fragment>
        <root>
          <xsl:copy-of copy-namespaces="no" select="node()"/>
        </root>
      </source:fragment>
    </source:write>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
