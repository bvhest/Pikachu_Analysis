<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:dir="http://apache.org/cocoon/directory/2.0">
  <xsl:param name="timestamp"/>
  <xsl:param name="sourceDir" as="xs:string"/>  
  <xsl:param name="sourceFile"/>  
  <xsl:param name="localetype"/>    
  <xsl:template match="/">
    <xsl:variable name="filename" select="concat('../',$sourceDir,'/',$sourceFile)"/>
    <xsl:choose>
      <xsl:when test="$localetype = 'Master'">
        <xsl:if test="contains($sourceFile,$timestamp) and contains($sourceFile,'Master') and not(contains($sourceFile, 'CONTENT-READY'))">  
              <xsl:value-of select="$sourceFile" /><xsl:text>
</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="contains($sourceFile,$timestamp) and not(contains($sourceFile,'Master')) and not(contains($sourceFile, 'CONTENT-READY'))">  
              <xsl:value-of select="$sourceFile" /><xsl:text>
</xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>      
  </xsl:template>
</xsl:stylesheet>