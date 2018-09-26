<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"  xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:shell="http://apache.org/cocoon/shell/1.0" >
  <!-- -->	
	<xsl:param name="cacheDir"/>
		
  <xsl:template match="node()|@*">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
  <!-- <xsl:attribute name="name"><xsl:value-of select="//dir:directory/dir:directory/node(name)"/></xsl:attribute> -->	
	<xsl:template match="//dir:directory">
		<directory>
		<xsl:variable name="directoryName" select="@name" />
			<xsl:apply-templates>
			<xsl:with-param name="directoryName" select="$directoryName" />
			</xsl:apply-templates>
		</directory>
	</xsl:template>
  <!-- -->
	<xsl:template match="dir:file">
	<xsl:param name="directoryName"/>
				<cinclude:include src="{concat('cocoon:/readFile/',$cacheDir,'/',$directoryName,'/',@name)}" />
				<shell:delete>
					<shell:source>
					  <xsl:value-of select="concat($cacheDir,'/',$directoryName,'/',@name)" />
					</shell:source>
				  </shell:delete>				
	</xsl:template>
  <!-- -->
  
  
</xsl:stylesheet>