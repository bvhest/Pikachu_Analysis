<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                >
  
  <xsl:param name="target_filename"/>
  <xsl:param name="source_url"/>
  
  <xsl:template match="/">
     <read source="{$source_url}">
        <xsl:value-of select="$target_filename"/>
     </read>
  </xsl:template>
</xsl:stylesheet>
