<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:shell="http://apache.org/cocoon/shell/1.0"
    exclude-result-prefixes="dir shell">

  <xsl:template match="/root">
    <xsl:variable name="error-count" select="count(shellResult[execution!='success'])"/>
    <report success-count="{count(shellResult[execution='success'])}"
            error-count="{$error-count}"
            total-count="{count(shellResult)}">
      <xsl:apply-templates select="@*"/>
      
      <xsl:if test="$error-count gt 0">
        <errors>
          <xsl:apply-templates select="shellResult[execution!='success']/source"/>
        </errors>
      </xsl:if>
    </report>
  </xsl:template>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>