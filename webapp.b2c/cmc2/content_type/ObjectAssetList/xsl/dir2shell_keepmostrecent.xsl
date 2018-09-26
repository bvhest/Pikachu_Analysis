<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:shell="http://apache.org/cocoon/shell/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="dir"/>
  
  <!-- 
   | Keep only the latest full feed files.
   | Assumption is that there are only full feed files in the inbox.
   |
   | Example file names: 
   |   - Full_pcu_object_asset_201003051500_0001.xml
   |   - alaTest_20100304190701.xml
   | 
   | Files are grouped by "name" before a timestamp. Of each group the most recent is kept.
   | Files ending with a sequence (like _0001) are kept as a complete set based on the timestamp in the file.
   | Files that have string like '.batch_0.' in their name are deleted, because these are intermediate files
   | from a aprevious aborted run.
  -->
  <xsl:template match="dir:directory">
    <root>
      <xsl:variable name="files">
        <xsl:apply-templates select="dir:file[not(matches(@name,'\.batch_\d+\.'))]">
          <xsl:sort select="@name" order="descending"/>
        </xsl:apply-templates>
      </xsl:variable>
      <!-- Files ending with a sequence number -->
      <xsl:for-each-group select="$files/file" group-by="@base-name">
        <xsl:variable name="latest-ts" select="current-group()[1]/@ts"/>
        <xsl:apply-templates select="current-group()[@ts != $latest-ts]" mode="delete"/>
      </xsl:for-each-group>
      <!-- Remove any remaining resulting files from a previous run's split stage -->
      <xsl:apply-templates select="dir:file[matches(@name,'\.batch_\d+\.')]" mode="delete"/>
    </root>
  </xsl:template>
  
  <xsl:template match="dir:file">
    <xsl:variable name="ts" select="replace(@name,'.+_(\d{12,14})(_\d{4})?\.xml','$1')" />
    <xsl:if test="$ts != ''">
      <file>
        <xsl:attribute name="name" select="@name" />
        <xsl:attribute name="base-name" select="replace(@name, '(.+)_\d{12}.+', '$1')"/>
        <xsl:attribute name="ts" select="$ts" />
      </file>
    </xsl:if>
  </xsl:template>

  <xsl:template match="file" mode="delete">
    <shell:delete>
      <shell:source><xsl:value-of select="concat($dir,'/',@name)"/></shell:source>
    </shell:delete>
  </xsl:template>
</xsl:stylesheet>
