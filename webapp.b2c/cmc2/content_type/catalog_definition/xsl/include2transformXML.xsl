<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:my="http://pww.pikachu.philips.com/functions/local">
  <!-- -->
  <xsl:param name="source"/>
  <xsl:param name="sourcedir"/>
  <xsl:param name="destination"/>
  <xsl:param name="ts"/>
  <xsl:param name="runmode"/>

  <xsl:variable name="source-doc">
    <xsl:if test="doc-available(concat($sourcedir,'/',$source))">
      <xsl:sequence select="document(concat($sourcedir,'/',$source))"/>
    </xsl:if>
  </xsl:variable>
    
  <xsl:template match="/">
    <root source="{$sourcedir}/{$source}">
      <xsl:if test="exists($source-doc/*)">
        <xsl:variable name="timestamp" select="my:get-timestamp($source-doc)"/>

        <cinclude:include><xsl:attribute name="src">cocoon:/transformXMLToExternalTable/<xsl:value-of select="$source"/>?destination=<xsl:value-of select="$destination"/>&amp;timestamp=<xsl:value-of select="$timestamp"/></xsl:attribute></cinclude:include>
        <xsl:choose>
          <xsl:when test="contains($source,'prisma')">        
            <cinclude:include><xsl:attribute name="src">cocoon:/processDeletionsAndMerge?destination=<xsl:value-of select="$destination"/>&amp;timestamp=<xsl:value-of select="$timestamp"/></xsl:attribute></cinclude:include>
          </xsl:when>
          <xsl:otherwise>
            <cinclude:include><xsl:attribute name="src">cocoon:/mergeExternalTable?destination=<xsl:value-of select="$destination"/></xsl:attribute></cinclude:include>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="contains($source,'lcb') or contains($source,'pikachu_full')">
          <cinclude:include><xsl:attribute name="src">cocoon:/updateCLE/<xsl:value-of select="$source"/>?destination=<xsl:value-of select="$destination"/>&amp;timestamp=<xsl:value-of select="$timestamp"/></xsl:attribute></cinclude:include>
        </xsl:if>
        <xsl:if test="contains($source,'pikachu_full')">
          <cinclude:include><xsl:attribute name="src">cocoon:/updateCHANNEL_PARAM/<xsl:value-of select="$source"/>?destination=<xsl:value-of select="$destination"/>&amp;timestamp=<xsl:value-of select="$timestamp"/></xsl:attribute></cinclude:include>
        </xsl:if>        
        <cinclude:include><xsl:attribute name="src">cocoon:/selectUpdates/<xsl:value-of select="$source"/>?destination=<xsl:value-of select="$destination"/>&amp;timestamp=<xsl:value-of select="$timestamp"/>&amp;ts=<xsl:value-of select="$ts"/></xsl:attribute></cinclude:include>      
        <!--cinclude:include><xsl:attribute name="src">cocoon:/archiveFile/<xsl:value-of select="$source"/></xsl:attribute></cinclude:include-->
      </xsl:if>      
    </root>
  </xsl:template>
  
  <xsl:function name="my:get-timestamp">
    <xsl:param name="doc"/>

    <xsl:choose>
      <xsl:when test="$doc/catalog-definition">
        <xsl:value-of select="$doc/catalog-definition/@DocTimeStamp"/>
      </xsl:when>
      <xsl:when test="$doc/Catalogs">
        <xsl:value-of select="$doc/Catalogs/@Timestamp"/>
      </xsl:when>
      <xsl:when test="$doc/catalogs">
        <xsl:value-of select="$doc/catalogs/@timestamp"/>
      </xsl:when>
    </xsl:choose>
  </xsl:function>
  
</xsl:stylesheet>