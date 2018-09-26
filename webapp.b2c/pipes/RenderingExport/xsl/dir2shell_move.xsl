<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:shell="http://apache.org/cocoon/shell/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="sourceDir" as="xs:string"/>
  <xsl:param name="targetDir" as="xs:string"/>
  <xsl:param name="timestamp"/>
  <xsl:param name="sourceFile"/>  
  <xsl:template match="/">
    <xsl:variable name="filename" select="concat('../',$sourceDir,'/',$sourceFile)"/>
    <xsl:choose>
    <xsl:when test="contains($filename,$timestamp)">
      <shell:move overwrite="true">
        <shell:source><xsl:value-of select="concat($sourceDir,'/',$sourceFile)"/></shell:source>
        <shell:target><xsl:value-of select="concat($targetDir,'/',$sourceFile)"/></shell:target>
      </shell:move>
    </xsl:when>
    <xsl:otherwise>
      <shell:delete>
        <shell:source><xsl:value-of select="concat($sourceDir,'/',$sourceFile)"/></shell:source>
      </shell:delete>
    </xsl:otherwise>          
  </xsl:choose>
  </xsl:template>

</xsl:stylesheet>