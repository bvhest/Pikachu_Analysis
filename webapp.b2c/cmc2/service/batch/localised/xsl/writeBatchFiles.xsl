<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:i="http://apache.org/cocoon/include/1.0">

  <xsl:param name="threads"/>
  <xsl:param name="content-type"/>
  <xsl:param name="target-dir"/>
  <xsl:param name="prefix" value="'batch.'"/>
  <xsl:param name="process"/>

  <xsl:variable name="l-threads" select="if (matches($threads, '\d+') and number($threads) gt 0) then min((number($threads), 20)) else 1"/>
  <xsl:variable name="ts" select="format-dateTime(current-dateTime(),'[Y0001][M01][D01][H01][m01][s01]')"/>
  
  <xsl:template match="/root">
    <root>
      <xsl:choose>
        <!-- Write batch files if multiple threads can be used -->
        <xsl:when test="$l-threads gt 1">
          <xsl:for-each-group select="sql:rowset/sql:row" group-by="(position()-1) idiv $l-threads">
            <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
              <source:source>
                <xsl:value-of select="concat($target-dir, '/', $prefix, current-grouping-key(), '.xml')"/>
              </source:source>
              <source:fragment>
                <root>
                  <xsl:apply-templates select="current-group()/sql:localisation"/>
                </root>
              </source:fragment>
            </source:write>
          </xsl:for-each-group>
        </xsl:when>
        <!-- Create one batch file that will be processed with parallel = false -->
        <xsl:otherwise>
          <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
            <source:source>
              <xsl:value-of select="concat($target-dir, '/', $prefix, '0', '.xml')"/>
            </source:source>
            <source:fragment>
              <root>
                <xsl:apply-templates select="sql:rowset/sql:row/sql:localisation"/>
              </root>
            </source:fragment>
          </source:write>
        </xsl:otherwise>
      </xsl:choose>
    </root>
  </xsl:template>

  <xsl:template match="sql:localisation">
    <xsl:choose>
      <xsl:when test="$process != ''">
        <i:include src="{$process}/{.}" />
      </xsl:when>
      <xsl:otherwise>
        <i:include src="cocoon:/processBatches/{$content-type}/{.}/{$ts}"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>