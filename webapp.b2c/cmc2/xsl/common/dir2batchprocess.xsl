<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:i="http://apache.org/cocoon/include/1.0"
    xmlns:ws="http://apache.org/cocoon/source/1.0">
  
  <xsl:param name="process"/>
  <xsl:param name="root-dir"/>
  <xsl:param name="output-dir" select="'/tmp'"/>
  <xsl:param name="batch-size"/>
  <xsl:param name="prefix" select="'batch.'"/>
  <xsl:param name="limit"/>
  
  <xsl:variable name="l-batch-size" select="if (matches($batch-size,'\d+')) then number($batch-size) else 4"/>
  <xsl:variable name="l-limit" select="if (matches($limit,'\d+')) then number($limit) else 0"/>
  
  <xsl:template match="/">
    <root>
      <xsl:variable name="file-list">
        <xsl:apply-templates select="dir:directory">
          <xsl:with-param name="parent-path" select="$root-dir"/>
        </xsl:apply-templates>
      </xsl:variable>

      <xsl:for-each-group select="$file-list/dir:file[$l-limit=0 or position() &lt;= $l-limit]" group-by="(position()-1) idiv $l-batch-size">
        <ws:write>
          <ws:source>
            <xsl:value-of select="concat($output-dir,'/',$prefix,current-grouping-key(),'.xml')"/>
          </ws:source>
          <ws:fragment>
            <batch number="{current-grouping-key()}">
              <xsl:apply-templates select="current-group()" mode="write-batch"/>
            </batch>
          </ws:fragment>
        </ws:write>
      </xsl:for-each-group>
    </root>
  </xsl:template>
  
  <xsl:template match="dir:directory">
    <xsl:param name="parent-path"/>
    <xsl:apply-templates>
      <xsl:with-param name="parent-path" select="concat($parent-path,'/',@name)"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="dir:file">
    <xsl:param name="parent-path"/>
    <dir:file path="{concat($parent-path,'/',@name)}"/>
  </xsl:template>
  
  <xsl:template match="dir:file" mode="write-batch">
    <i:include src="{concat($process,@path)}"/>
  </xsl:template>
</xsl:stylesheet>