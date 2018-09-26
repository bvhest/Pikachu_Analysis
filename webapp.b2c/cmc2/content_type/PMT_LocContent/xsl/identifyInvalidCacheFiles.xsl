<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:shell="http://apache.org/cocoon/shell/1.0"
                xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="dir"/>
  <xsl:param name="ts"/>

  <xsl:key name="k_octls" match="/root/sql:rowset/sql:row/sql:object_id" use="."/>

  <xsl:template match="/root">
    <root name="delete-invalid-cache-files" ts="{$ts}">
      <xsl:for-each select="dir:directory/dir:file">
        <!-- xsl:variable name="id" select="replace(substring-before(@name,'.xml'),'_','/')"/ -->
        <xsl:variable name="id" select="substring-before(@name,'.xml')"/>
        <xsl:choose>
          <xsl:when test="key('k_octls',$id)">
            <!-- cache file exists but octl is PLACEHOLDER or DELETED in the db -->
            <delete name="{concat(@parent,'/',@name)}">
              <shell:delete>
                <shell:source><xsl:value-of select="concat($dir,'/',@parent,'/',@name)"/></shell:source>
              </shell:delete>
            </delete>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </root>
  </xsl:template>
</xsl:stylesheet>
