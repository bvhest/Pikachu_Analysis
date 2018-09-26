<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:shell="http://apache.org/cocoon/shell/1.0">

  <xsl:param name="sourceDir" as="xs:string"/>
  <xsl:param name="targetDir" as="xs:string"/>
  <xsl:param name="sourceFile"/>  

  <xsl:template match="/">
    <shell:move overwrite="true">
      <shell:source><xsl:value-of select="concat($sourceDir,'/',$sourceFile)"/></shell:source>
      <shell:target><xsl:value-of select="concat($targetDir,'/',$sourceFile)"/></shell:target>
    </shell:move>
  </xsl:template>
</xsl:stylesheet>