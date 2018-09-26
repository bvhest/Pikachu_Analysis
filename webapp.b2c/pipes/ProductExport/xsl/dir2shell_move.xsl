<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:shell="http://apache.org/cocoon/shell/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:param name="sourceDir" as="xs:string" />
  <xsl:param name="targetDir" as="xs:string" />
  <xsl:param name="channel" as="xs:string" />

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="dir:file">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      
      <xsl:if test="$channel != 'AmaHK' and @name != 'subcatalog.xml'">
        <shell:move overwrite="true">
          <shell:source>
            <xsl:value-of select="concat($sourceDir,'/',@name)" />
          </shell:source>
          <shell:target>
            <xsl:value-of select="concat($targetDir,'/',@name)" />
          </shell:target>
        </shell:move>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>