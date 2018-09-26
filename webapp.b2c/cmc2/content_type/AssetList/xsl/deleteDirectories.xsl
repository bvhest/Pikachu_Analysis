<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:shell="http://apache.org/cocoon/shell/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0">
  
  <xsl:param name="sourceDir"/>
  
   <xsl:template match="@*|node()" mode="#all">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template> 
  
  <xsl:template match="//dir:directory/dir:directory">
	<root>
		<shell:delete>
			<shell:source>
			  <xsl:value-of select="concat($sourceDir,'/',@name)" />
			</shell:source>
		</shell:delete>
	</root>
  </xsl:template>
   
</xsl:stylesheet>
