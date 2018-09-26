<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:include="http://apache.org/cocoon/include/1.0"
		xmlns:dir="http://apache.org/cocoon/directory/2.0" 
		xmlns:shell="http://apache.org/cocoon/shell/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <!-- -->
  <xsl:param name="sourceDir"/>    
  <!-- -->
  <xsl:template match="/dir:directory">
  <root>
      <xsl:apply-templates select="dir:file"/>
  </root>
  </xsl:template>
 
  <!-- -->
  <xsl:template match="dir:file">
	  <file>
        <include:include src="cocoon:/process/{@name}/manifest_{substring-after(@name, '_')}"/>
        <include:include src="cocoon:/cacheTitles/manifest_{substring-after(@name, '_')}"/>
      </file>
     <shell:delete>
      <shell:source>
        <xsl:value-of select="concat($sourceDir,'/',@name)" />
      </shell:source>
    </shell:delete>
  </xsl:template>
  <!-- -->

</xsl:stylesheet>