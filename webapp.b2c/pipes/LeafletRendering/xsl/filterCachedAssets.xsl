<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:key name="cache" match="/root/cachedata/cachedir/dir:directory/dir:file" use="@name"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="xmldata">
    <xsl:apply-templates select="@*|node()" />
  </xsl:template>
  
  <!-- Remove assets that are up to date in the cache -->
  <xsl:template match="asset[exists(key('cache', @cachename))]"/>
  
  <xsl:template match="cachedata"/>
  
</xsl:stylesheet>