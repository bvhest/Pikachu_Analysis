<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:shell="http://apache.org/cocoon/shell/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="source-dir"/>
  <xsl:param name="locale"/>

  <xsl:template match="/">
    <root name="deleteDuplicates" locale="{$locale}">
      <xsl:apply-templates select="@*|node()"/>
    </root>
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>

  <!--
    Remove family files that occur for multiple regions (EU, NA, AP)
    because the NA and AP families are renamed to EU.
    If a family exists for multiple refions:
      -If a EU family exists the NA and/or AP families are deleted.
      -If no EU family exists the AP family is deleted.
  -->
  <xsl:template match="dir:directory">
    <xsl:for-each-group select="dir:file" group-by="replace(@name,'_(EU|NA|AP)$','')">
      <xsl:if test="count(current-group()) gt 1">
        <xsl:choose>
          <xsl:when test="current-group()[ends-with(@name,'_EU')]">
            <xsl:apply-templates select="current-group()[not(ends-with(@name,'_EU'))]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="current-group()[ends-with(@name,'_AP')]"/>
          </xsl:otherwise>
        </xsl:choose>
        
      </xsl:if>
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template match="dir:file">
    <shell:delete>
      <shell:source>
        <xsl:value-of select="concat($source-dir,'/',@name)" />
      </shell:source>
    </shell:delete>
  </xsl:template>
</xsl:stylesheet>