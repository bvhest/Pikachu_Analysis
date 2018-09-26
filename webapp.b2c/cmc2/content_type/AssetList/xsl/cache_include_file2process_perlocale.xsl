<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"  xmlns:dir="http://apache.org/cocoon/directory/2.0"
	 >
  <!-- -->	
	<xsl:param name="sourceDir"/>
		
<xsl:key name="groupName" match="//dir:directory/dir:file" use="substring-before(@name, '.')" />
		
  <xsl:template match="node()|@*">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	`	<xsl:template match="dir:directory">
		<directory>
		<xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
			<xsl:variable name="directoryName" select="@name"/>
				<xsl:for-each-group select="//dir:directory/dir:file" group-by="substring-before(@name, '.')">
				<cinclude:include src="{concat('cocoon:/mergePerCacheCTN/',$directoryName,'/',substring-before(@name, '.'))}" />
				</xsl:for-each-group>			
		</directory>
	</xsl:template>
	
  <!-- <xsl:attribute name="name"><xsl:value-of select="//dir:directory/dir:directory/node(name)"/></xsl:attribute> 
	<xsl:template match="dir:directory">
		<directory> 
		<xsl:variable name="directoryName" select="@name"/>
			<xsl:apply-templates>
			<xsl:with-param name="directoryName" select="$directoryName" />
			</xsl:apply-templates>
		 </directory> 
	</xsl:template>-->
  
  <!-- 
  <xsl:template match="dir:file">
  <xsl:copy copy-namespaces="no">
  <xsl:param name="directoryName"/>
		<xsl:for-each-group select="//dir:directory/dir:file" group-by="substring-before(@name, '.')">
		<cinclude:include src="{concat('cocoon:/mergePerCacheCTN/',$directoryName,'/',substring-before(@name, '.'))}" /> 
		</xsl:for-each-group>	
 </xsl:copy>		
  </xsl:template> -->
  
 <!--
  <xsl:template match="dir:file">
		<xsl:param name="directoryName"/>
		<xsl:for-each-group select="//dir:directory/dir:file" group-by="substring-before(@name, '.')">
		 <xsl:call-template name="group">
		 <xsl:with-param name="directoryName" select="$directoryName" />
		 </xsl:call-template>			
		</xsl:for-each-group>				
	</xsl:template>
  
	<xsl:template name="group">
		<xsl:copy copy-namespaces="no">
		<xsl:param name="directoryName"/>
			<cinclude:include src="{concat('cocoon:/mergePerCacheCTN/',$directoryName,'/',substring-before(@name, '.'))}" /> 
		 </xsl:copy>
	</xsl:template> 
  -->
  
</xsl:stylesheet>