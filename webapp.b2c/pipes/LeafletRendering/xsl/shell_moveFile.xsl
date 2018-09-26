<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:shell="http://apache.org/cocoon/shell/1.0">

	<xsl:param name="sourceFile" as="xs:string"/>
	<xsl:param name="targetFile" as="xs:string"/>
    <xsl:param name="keepPrevious" as="xs:string"/>
    
    <xsl:variable name="ts" select="format-dateTime(current-dateTime(), '[Y0001][M01][D01][H01][m01][s01]')"/>
    
	<xsl:template match="/">
      <root name="update-cache">
        <xsl:if test="$keepPrevious='true'">
          <shell:move overwrite="true">
            <shell:source><xsl:value-of select="$targetFile"/></shell:source>
            <shell:target><xsl:value-of select="replace($targetFile,'\.xml$',concat('.', $ts,'.xml'))"/></shell:target>
          </shell:move>
        </xsl:if>
        <shell:move overwrite="true">
          <shell:source><xsl:value-of select="$sourceFile"/></shell:source>
          <shell:target><xsl:value-of select="$targetFile"/></shell:target>
        </shell:move>
      </root>
	</xsl:template>

</xsl:stylesheet>