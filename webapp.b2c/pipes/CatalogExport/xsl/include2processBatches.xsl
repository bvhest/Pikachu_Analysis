<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:i="http://apache.org/cocoon/include/1.0"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="channel"/>
  <xsl:param name="ts"/>
  <xsl:param name="dir"/>
  <xsl:param name="prefix" select="'batch.'"/>
  <xsl:param name="threads"/>

  <xsl:variable name="l-threads" select="if (matches($threads, '\d+') and number($threads) gt 0 and number($threads) le 20) then number($threads) else 1"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/root">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      
      <xsl:choose>
        <!-- Write batch files if multiple threads can be used -->
        <xsl:when test="$l-threads gt 1">
          <xsl:for-each-group select="sql:rowset[@name='select-flagged-catalogs']/sql:row"
                              group-by="floor((position()-1) div $l-threads)">
            <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
              <source:source>
                <xsl:value-of select="concat($dir, '/', $prefix, $ts, '.', current-grouping-key(), '.xml')"/>
              </source:source>
              <source:fragment>
                <root>
                  <xsl:apply-templates select="current-group()/sql:catalog_id" mode="include"/>
                </root>
              </source:fragment>
            </source:write>
          </xsl:for-each-group>
        </xsl:when>
        <!-- Do a simple include if only one thread can be used -->
        <xsl:otherwise>
          <xsl:apply-templates select="sql:rowset[@name='select-flagged-catalogs']/sql:row/sql:catalog_id" mode="include"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sql:catalog_id" mode="include">
    <i:include>
      <xsl:attribute name="src">
        <xsl:text>cocoon:/exportCatalog.</xsl:text>
        <xsl:value-of select="$ts"/>
        <xsl:text>.</xsl:text>
        <xsl:value-of select="."/>
      </xsl:attribute>
    </i:include>
  </xsl:template>
</xsl:stylesheet>
