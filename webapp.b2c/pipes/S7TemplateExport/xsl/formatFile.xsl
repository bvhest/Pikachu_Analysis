<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:source="http://apache.org/cocoon/source/1.0" 
                exclude-result-prefixes="sql xsl source">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="dir"/>
  <xsl:param name="filename"/>
  <xsl:variable name="timestamp" select="substring(xs:string(current-dateTime()),1,19)"/>
  <xsl:variable name="timestampnumeric" select="replace(replace(replace($timestamp,':',''),'-',''),'T','')"/>
	<!-- -->
	<xsl:template match="/">
    <root>
      <xsl:apply-templates select="node()|@*"/>
    </root>
	</xsl:template>    
  <!-- -->  
  <xsl:template match="node()|@*">
    <xsl:apply-templates select="node()|@*"/>
	</xsl:template>        
  <!-- -->
  <xsl:template match="Template">  
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source><xsl:value-of select="concat($dir,Name,'.xml')"/></source:source>
			<source:fragment>
        <Templates>
          <xsl:copy-of select="."/>
        </Templates>  
			</source:fragment>
		</source:write>
	</xsl:template>
</xsl:stylesheet>
