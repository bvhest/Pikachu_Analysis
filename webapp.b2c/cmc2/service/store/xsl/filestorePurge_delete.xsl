<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:source="http://apache.org/cocoon/source/1.0"
	xmlns:shell="http://apache.org/cocoon/shell/1.0">
	
    <xsl:param name="recycle"/>
	<xsl:param name="ct"/>
	<xsl:param name="localisation"/>
	<xsl:param name="dir"/>
	
    <xsl:variable name="l-recycle" select="$recycle != 'false'"/>
    
	<xsl:template match="@*|node()">
			<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="/report">
		<xsl:copy copy-namespaces="no">
			<xsl:copy-of select="@*"/>
				<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="not-in-database">
		<xsl:apply-templates  mode="delete"/>
	</xsl:template>
	
	<xsl:template match="fs_filename" mode="delete">
      <xsl:choose>
        <xsl:when test="$l-recycle">
          <shell:move overwrite="true">
            <shell:source><xsl:value-of select="concat($dir,'/',$ct,'/',$localisation,'/',.,'.xml')"/></shell:source>
            <shell:target><xsl:value-of select="concat($dir,'/RecycleBin/',$ct,'/',$localisation,'/',.,'.xml')"/></shell:target>
          </shell:move> 
        </xsl:when>
        <xsl:otherwise>
          <shell:delete>
            <shell:source><xsl:value-of select="concat($dir,'/',$ct,'/',$localisation,'/',.,'.xml')"/></shell:source>
          </shell:delete>
        </xsl:otherwise>
      </xsl:choose>
	</xsl:template>

</xsl:stylesheet>
