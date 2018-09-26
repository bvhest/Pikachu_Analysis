<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"  xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:shell="http://apache.org/cocoon/shell/1.0" >
  <!-- -->	
	<xsl:param name="sourceDir"/>
	<xsl:param name="cacheDir"/>
	
	 <xsl:key name="groupName" match="//dir:directory/dir:file" use="substring-before(@name, '.')"/>
	
	<!-- -->	
	<xsl:template match="node()|@*">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- -->
 	<xsl:template match="//dir:directory">
		<directory>
		<xsl:variable name="directoryName" select="@name" />
		<delta>
			<xsl:apply-templates match="dir:file" mode="inbox">
			<xsl:with-param name="directoryName" select="$directoryName" />
			</xsl:apply-templates>
		</delta>	
		 <cache>
			<xsl:apply-templates match="dir:file" mode="cache">
			<xsl:with-param name="directoryName" select="$directoryName" />
			</xsl:apply-templates>
		  </cache>
		</directory>
	</xsl:template>
  
  <!-- -->
	<xsl:template match="dir:file" mode="inbox">
		<xsl:param name="directoryName"/>
		<cinclude:include src="{concat('cocoon:/readFile/',$sourceDir,'/',$directoryName,'/',@name)}" />
		<shell:delete>
			<shell:source>
			  <xsl:value-of select="concat($sourceDir,'/',$directoryName,'/',@name)" />
			</shell:source>
		</shell:delete>	
	</xsl:template>
	
	<!-- -->
	<xsl:template match="dir:file[1]" mode="cache">
		<xsl:param name="directoryName"/>
	    <cinclude:include>
          <xsl:attribute name="src"
            select="concat('cocoon:/readFile/', $cacheDir, '/',$directoryName,'/',substring-before(@name, '.'),'.xml')" />
        </cinclude:include>
	</xsl:template>
  
  
</xsl:stylesheet>