<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ws="http://apache.org/cocoon/source/1.0">

  <xsl:import href="prepareComparison.xsl"/>

  <xsl:param name="temp-dir" select="'/tmp'"/>
  <xsl:param name="overrideCheck"/>
  
  <xsl:template match="Files2Compare">
    <xsl:variable name="newContent">
      <xsl:apply-templates select="Nodes[1]/Node"/>
    </xsl:variable>
    <xsl:variable name="cachedContent">
      <xsl:apply-templates select="Nodes[2]/Node"/>
    </xsl:variable>
    
    <Filter>
      <xsl:choose>
        <xsl:when test="deep-equal($cachedContent,$newContent)">
          <identical><xsl:value-of select="Nodes[1]/Node/@code"/></identical>
        </xsl:when>
        <xsl:otherwise>
          <changed code="{Nodes[1]/Node/@code}"/>
          <xsl:if test="$overrideCheck != 'yes'">
            <ws:write>
              <ws:source><xsl:value-of select="concat($temp-dir,'/',Nodes[1]/Node/@code,'.xml')"/></ws:source>
              <ws:fragment>
                <xsl:copy-of select="$newContent"/>
              </ws:fragment>
            </ws:write>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </Filter>
  </xsl:template>  

</xsl:stylesheet>
