<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:zip="http://apache.org/cocoon/zip-archive/1.0">

  <xsl:param name="sourceDir" as="xs:string" select="'test/'" />
  <xsl:param name="zipDir" as="xs:string" select="'test/'" />
  <!-- -->
  <xsl:template match="/">
    <xsl:if test="count(//dir:file) &gt; 0">
      <zip:archive>
        <xsl:apply-templates select="//dir:file" />
      </zip:archive>
    </xsl:if>
    <xsl:if test="count(//dir:file) = 0">
      <zip:archive>
        <zip:entry name="index.html" serializer="html">
          <html>
            <head />
            <body>Empty</body>
          </html>
        </zip:entry>
      </zip:archive>
    </xsl:if>
  </xsl:template>
  <!-- -->
  <xsl:template match="dir:file">
    <zip:entry>
      <xsl:attribute name="name"><xsl:value-of select="concat($zipDir,@name)" /></xsl:attribute>
      <xsl:attribute name="src"><xsl:value-of select="concat($sourceDir,@name)" /></xsl:attribute>
    </zip:entry>
  </xsl:template>
</xsl:stylesheet>
