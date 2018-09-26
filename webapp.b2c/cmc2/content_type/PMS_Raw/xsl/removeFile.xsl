<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:shell="http://apache.org/cocoon/shell/1.0">
	
	<xsl:param name="source" />

	<xsl:template match="FilterProduct">
    <xsl:choose>
      <xsl:when test="identical">
        <identical source="{$source}">
    		  <shell:delete>
    			  <shell:source><xsl:value-of select="$source"/></shell:source>
    		  </shell:delete>
       </identical>
     </xsl:when>
     <xsl:otherwise><changed source="{$source}"/></xsl:otherwise>     
   </xsl:choose>
	</xsl:template>

</xsl:stylesheet>