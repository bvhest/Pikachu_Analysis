<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:shell="http://apache.org/cocoon/shell/1.0">

  <xsl:param name="dir" />
  <xsl:param name="delete-root" />

  <xsl:template match="/dir:directory">
    <root name="dir2shell_deletetree">
      <xsl:apply-templates select="dir:file|dir:directory">
        <xsl:with-param name="dir" select="$dir"/>
      </xsl:apply-templates>
      <xsl:if test="$delete-root='true'">
        <!-- Delete this directory itself -->
        <shell:delete>
          <shell:source>
            <xsl:value-of select="$dir" />
          </shell:source>
        </shell:delete>
      </xsl:if>
    </root>
  </xsl:template>

  <xsl:template match="dir:directory">
    <xsl:param name="dir"/>
    <!-- Delete files subdirectories -->
    <xsl:apply-templates select="dir:directory">
      <xsl:with-param name="dir" select="concat($dir,'/',@name)"/>
    </xsl:apply-templates>
    <!-- Delete files in this directory -->
    <xsl:apply-templates select="dir:file">
      <xsl:with-param name="dir" select="concat($dir,'/',@name)"/>
    </xsl:apply-templates>
    <!-- Delete this directory itself -->
    <shell:delete>
      <shell:source>
        <xsl:value-of select="concat($dir,'/',@name)" />
      </shell:source>
    </shell:delete>
  </xsl:template>
  
  <!-- Delete a file -->
  <xsl:template match="dir:file">
    <xsl:param name="dir"/>
    <shell:delete>
      <shell:source>
        <xsl:value-of select="concat($dir,'/',@name)" />
      </shell:source>
    </shell:delete>
  </xsl:template>
  
</xsl:stylesheet>
