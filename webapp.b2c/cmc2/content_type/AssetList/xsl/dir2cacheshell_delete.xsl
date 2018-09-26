<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:shell="http://apache.org/cocoon/shell/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:param name="sourceDir" as="xs:string" />

  <xsl:template match="root">
    <page>
      <xsl:apply-templates select="file" />
    </page>
  </xsl:template>

  <!-- Delete the file -->
  <xsl:template match="file">
    <shell:delete>
      <shell:source>
        <xsl:value-of select="concat($sourceDir,'/',@name)" />
      </shell:source>
    </shell:delete>
  </xsl:template>

</xsl:stylesheet>