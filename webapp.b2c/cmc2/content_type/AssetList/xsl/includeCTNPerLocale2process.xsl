<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"  xmlns:dir="http://apache.org/cocoon/directory/2.0"
	 >
  <!-- -->	
	<xsl:key name="groupName" match="//dir:directory/dir:file" use="substring-before(@name, '.')" />
	
	<!-- -->	
	<xsl:template match="node()|@*">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- -->	
  `	<xsl:template match="dir:directory">
		<Directory>
		<xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
			<xsl:variable name="directoryName" select="@name"/>
				<xsl:for-each-group select="//dir:directory/dir:file" group-by="substring-before(@name, '.')">
				<cinclude:include src="{concat('cocoon:/mergePerCTN/',$directoryName,'/',substring-before(@name, '.'))}" />
				</xsl:for-each-group>			
		</Directory>
	</xsl:template>
	
</xsl:stylesheet>