<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:shell="http://apache.org/cocoon/shell/1.0"
                xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="dir"/>
  <xsl:param name="ts"/>
  <xsl:param name="ct"/>
  <xsl:param name="pubSystemId"/>

  <xsl:key name="k_octls" match="/root/sql:rowset/sql:row/sql:object_id" use="."/>

	<xsl:template match="/root">
    <entries ct="{$ct}" ts="{$ts}">
      <entry includeinreport="yes">
        <root>
          <xsl:for-each select="dir:directory/dir:file">
            <xsl:variable name="id">
            	<xsl:choose>
            		<xsl:when test="$pubSystemId = 'PikachuB2C'">
            			<xsl:value-of select="replace(substring-before(@name,'.xml'),'_','/')"/>
            		</xsl:when>
            		<xsl:otherwise>
            			<xsl:value-of select="substring-before(@name,'.xml')"/>
            		</xsl:otherwise>
            	</xsl:choose>
            </xsl:variable>  
            <xsl:choose>
              <xsl:when test="key('k_octls',$id)">
                <delete name="{@name}">
                  <shell:delete>
                    <shell:source><xsl:value-of select="concat($dir,'/',@name)"/></shell:source>
                  </shell:delete>
                </delete>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
        </root>
      </entry>
    </entries>
  </xsl:template>
</xsl:stylesheet>
