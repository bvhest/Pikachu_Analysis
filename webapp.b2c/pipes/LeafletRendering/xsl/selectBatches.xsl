<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:i="http://apache.org/cocoon/include/1.0" 
                xmlns:dir="http://apache.org/cocoon/directory/2.0">
   <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:param name="process" />

  <xsl:template match="/">
    <root>
      <xsl:apply-templates select="/root/sourceResult" />
    </root>
  </xsl:template>

  <xsl:template match="sourceResult">
    <!-- root/sourceResult/source=
         file:/C:/work/cocoon-2.1.9/build/webapp.profB2B/pipes/LightingB2BRendering/../../../../data/LightingB2BRendering/temp/batch.20091120T1425.001.xml -->
    <xsl:variable name="batchfile" select="substring-after(source, '/temp/')" />
    <i:include>
      <xsl:attribute name="src">
        <xsl:value-of select="concat($process,'/',$batchfile)"/>
      </xsl:attribute>
    </i:include>
  </xsl:template>
  
</xsl:stylesheet>
