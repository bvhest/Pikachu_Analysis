<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:local="http://pww.pkachu.philips.com/functions/local"
    extension-element-prefixes="local">
  
  <xsl:import href="../Assets/XSL/rendering-functions.xsl"/>
  
  <xsl:param name="imageSourceDir" />
  <xsl:param name="imageDestDir" />
  
  <!-- Export the path to ImageMagick and Ghostscript as these are not set by default on the system. By adding 
     | to the PATH, the ImageMagick/convert- and Ghostscript functions can be used directly.
     -->
  <xsl:template match="batch">
    <xsl:text>echo Processing batch </xsl:text><xsl:value-of select="@number"/><xsl:text> ...
</xsl:text>
    <xsl:choose>
      <xsl:when test="asset[1]">
        <xsl:text>export PATH=/cadappl/imagemagick/6.5.7-0-1.1.el5-64/bin:/cadappl/ghostscript/8.70-1.1.el5-64/bin:$PATH
</xsl:text>
        <xsl:for-each-group select="asset" group-by="local:get-asset-cache-dir(.)">
          <!-- Create the cache directory -->
          <xsl:text>mkdir -p </xsl:text>
          <xsl:value-of select="concat($imageDestDir,'/',current-grouping-key())"/>
          <xsl:text>
</xsl:text>
          <xsl:apply-templates select="current-group()" />
        </xsl:for-each-group>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>echo Nothing to process in this batch.
</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- 
   +   Generate the image conversion command. 
   +   Always remove old versions of the same image-type as these are no longer used 
   +   (this is a superfluous step for new products, but should not take much time).
   +   Copy images that do not need scaling, and convert images that do need scaling.
   +
   +   Nb. Make sure every shell command ends with a new-line command.
   +
   +-->
  <xsl:template match="asset">
    <xsl:variable name="in-file" select="concat($imageSourceDir,'/',@ccrsource)"/>
    <xsl:variable name="out-file" select="concat($imageDestDir,'/',local:get-asset-cache-file-path(.))"/>
    <!-- Remove the previous cached file -->
    <xsl:variable name="remove-file" select="concat($imageDestDir,'/',local:get-asset-cache-dir(.),'/',local:get-asset-cache-filename-base(.),'*')"/>
    
    <xsl:text>rm -f </xsl:text><xsl:value-of select="$remove-file"/><xsl:text>
</xsl:text>

    <xsl:variable name="command">
      <xsl:choose>
        <xsl:when test="@convertcmd">
          <xsl:value-of select="replace(replace(@convertcmd,'%1',$in-file),'%2',$out-file)"/>
          <xsl:text>
  </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>cp </xsl:text>
          <xsl:value-of select="$in-file"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$out-file"/>
          <xsl:text>
  </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:text>{ echo </xsl:text><xsl:value-of select="$command"/><xsl:text>
</xsl:text>
    <xsl:value-of select="$command"/><xsl:text>} ></xsl:text><xsl:value-of select="concat($imageDestDir,'/',local:get-asset-cache-dir(.),'/',local:get-asset-cache-filename-base(.),'.log')"/><xsl:text> 2>&amp;1
</xsl:text>
    
  </xsl:template>

  <!-- ignore all other nodes & stuff  -->
  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()" /> 
  </xsl:template>

</xsl:stylesheet>
