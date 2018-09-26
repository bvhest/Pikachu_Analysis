<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:shell="http://apache.org/cocoon/shell/1.0">
  
  <xsl:param name="sourceDir"/>
  <xsl:param name="targetDir"/>
  <xsl:param name="processedDir"/>
  
  <xsl:template match="element()">
    <xsl:apply-templates />
  </xsl:template>
  
  <xsl:template match="/">
    <root name="renameFiles">
      <xsl:apply-templates/>
    </root>
  </xsl:template>
  
  <xsl:template match="dir:file">
    <xsl:variable name="country" select="dir:xpath/Catalog[1]/@Country"/>
    <xsl:variable name="catalog-type" select="dir:xpath/Catalog[1]/@CatalogTypeName"/>
    <xsl:variable name="timestamp" select="substring-after(substring-before(@name, '.xml'), 'FSS_')"/>

    <!-- Copy file to new name -->
  	<shell:copy overwrite="true">
	  <shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
	  <shell:target><xsl:value-of select="concat($targetDir,'/','pikachu_full_FSS_', $country, '_', $catalog-type, '_', $timestamp, '.xml')"/></shell:target>
	</shell:copy>
    <!-- Move original to processed dir -->
    <shell:move>
      <shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
      <shell:target><xsl:value-of select="concat($processedDir,'/',@name)"/></shell:target>
    </shell:move>
	
  </xsl:template>
</xsl:stylesheet>
  
 