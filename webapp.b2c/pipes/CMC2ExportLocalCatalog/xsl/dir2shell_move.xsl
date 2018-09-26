<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:shell="http://apache.org/cocoon/shell/1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="sourceDir" as="xs:string"/>
	<xsl:param name="targetDir" as="xs:string"/>
  <xsl:param name="catalogDefDir"/>
  <xsl:param name="catalogConfDir"/>
  
	<xsl:template match="/">
		<page>
			<xsl:apply-templates select="//dir:file"/>
		</page>
	</xsl:template>

	<xsl:template match="dir:file">
		<shell:move overwrite="true">
			<shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
			<xsl:choose>
				<xsl:when test="contains(@name,'_def_')">      
          <shell:target><xsl:value-of select="concat($catalogDefDir,'/',@name)"/></shell:target>
        </xsl:when>          
        <xsl:when test="contains(@name,'_conf_')">      
          <shell:target><xsl:value-of select="concat($catalogConfDir,'/',@name)"/></shell:target>
        </xsl:when>          
        <xsl:otherwise>
          <shell:target><xsl:value-of select="concat($targetDir,'/',@name)"/></shell:target>
        </xsl:otherwise>          
			</xsl:choose>        
		</shell:move>
	</xsl:template>
</xsl:stylesheet>