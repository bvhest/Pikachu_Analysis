<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:shell="http://apache.org/cocoon/shell/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="dir"/>
  
  <!-- 
   | example file names: 
   |   - Full_pcu_object_asset_201003051500_0001.xml
   |   - alaTest_20100304190701.xml
   | 
   | Files must be sorted ascendingly on lastmodified date by the directory generator.
   | Files are grouped by "name" before a timestamp. Of each group the most recent is kept.
  -->
  <xsl:template match="dir:directory">
    <root>
      <xsl:for-each-group select="dir:file" group-by="replace(@name, '_\d{12}.*$', '')">
        <xsl:sort select="@name"/>
        <!-- Select the files that have a more recent version -->
        <xsl:apply-templates select="current-group()[position() &lt; last()]"/>
      </xsl:for-each-group>
    </root>
  </xsl:template>
  
  <xsl:template match="dir:file">
    <shell:delete>
      <shell:source><xsl:value-of select="concat($dir,'/',@name)"/></shell:source>
    </shell:delete>
  </xsl:template>
</xsl:stylesheet>
