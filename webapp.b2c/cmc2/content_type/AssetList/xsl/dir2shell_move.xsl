<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:shell="http://apache.org/cocoon/shell/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:param name="sourceDir" as="xs:string"/>
    <xsl:param name="targetDir" as="xs:string"/>
    <xsl:param name="limit"/>
  
    <xsl:variable name="l-limit" select="if (matches($limit,'\d+')) then number($limit) else 0"/>

    <xsl:template match="/">
        <page>
          <xsl:for-each select="//dir:file[$l-limit=0 or position() &lt;= $l-limit]">
            <shell:move overwrite="true">
              <shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
              <shell:target><xsl:value-of select="concat($targetDir,'/',@name)"/></shell:target>
            </shell:move>
          </xsl:for-each>
            <!-- <xsl:apply-templates select="//dir:file"/>  -->
        </page>
    </xsl:template>
<!-- 
    <xsl:template match="dir:file">
        <shell:move overwrite="true">
            <shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
            <shell:target><xsl:value-of select="concat($targetDir,'/',@name)"/></shell:target>
        </shell:move>
    </xsl:template>
 -->
</xsl:stylesheet>