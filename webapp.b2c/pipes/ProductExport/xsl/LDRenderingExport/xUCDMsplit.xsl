<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="dir"/>
  <xsl:param name="locale"/>
  <xsl:param name="ext">.xml</xsl:param>
  
  <!-- For PMTRenderingExport we split the files directly into the archive -->
  <xsl:variable name="archive" select="concat(substring-before($dir,'outbox'), 'archive/')"/>
  
  <!--  -->
  <xsl:template match="/">
     <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <!--  -->
  <xsl:template match="Product">
    <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
      <source:source>
        <xsl:value-of select="$archive"/>
        <xsl:value-of select="translate(CTN,'/','_')"/>
        <xsl:value-of select="concat('.', $locale, '.', replace(replace(replace(@lastModified, '-', ''), ':', ''), 'T', ''))"/>
        <xsl:value-of select="$ext"/>
      </source:source>
      <source:fragment>
        <Products>
          <xsl:apply-templates select="../@*"/>
          <Product>
            <xsl:apply-templates select="@*|node()"/>
          </Product>
        </Products>
      </source:fragment>
    </source:write>
  </xsl:template>
  <!--  -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!--  -->
</xsl:stylesheet>
