<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:sql="http://apache.org/cocoon/SQL/2.0"
        xmlns:dir="http://apache.org/cocoon/directory/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="dir"/>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="/dir:directory">
    <root>
      <root>
        <xsl:apply-templates select="dir:file"/>
      </root>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="dir:file">
    <xsl:copy-of select="document(concat($dir,'/',@name))/root/root/entries"/>
  </xsl:template>
</xsl:stylesheet>