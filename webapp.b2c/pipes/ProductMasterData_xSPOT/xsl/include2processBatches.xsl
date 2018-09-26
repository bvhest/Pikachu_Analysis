<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:i="http://apache.org/cocoon/include/1.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:param name="ts"/>
  <xsl:param name="batch-size"/>
  <xsl:param name="threads"/>

  <xsl:variable name="l-batch-size" select="if (matches($batch-size, '\d+') and number($batch-size) > 0) then number($batch-size) else 500"/>
  <xsl:variable name="l-threads" select="if (matches($threads, '\d+') and number($threads) gt 0 and number($threads) le 20) then number($threads) else 1"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/">
    <root>
      <xsl:apply-templates select="@*|node()"/>
      
      <xsl:variable name="new-count" select="number(root/sql:rowset[@name='new-products']/sql:row/sql:returncode)"/>
      <xsl:variable name="existing-count" select="number(root/sql:rowset[@name='existing-products']/sql:row/sql:returncode)"/>
      <xsl:variable name="total-count" select="$new-count + $existing-count"/>
      <xsl:variable name="num-batches" select="ceiling($total-count div $l-batch-size) cast as xs:integer"/>
      <xsl:variable name="num-concurrent-batches" select="ceiling($num-batches div $l-threads) cast as xs:integer"/>
      
      <execution-plan>
        <num-products><xsl:value-of select="$total-count"/></num-products>
        <batch-size><xsl:value-of select="$l-batch-size"/></batch-size>
        <threads><xsl:value-of select="$l-threads"/></threads>
        <num-batches><xsl:value-of select="$num-batches"/></num-batches>
        <num-concurrent-batches><xsl:value-of select="$num-concurrent-batches"/></num-concurrent-batches>
      </execution-plan>
      
      <xsl:choose>
        <xsl:when test="$l-threads gt 1">
          <!-- Process concurrently -->
          <xsl:for-each select="0 to $num-concurrent-batches - 1">
            <xsl:variable name="start" select=". * $l-threads + 1"/>
            <xsl:variable name="end" select="min(((. + 1) * $l-threads, $num-batches))"/>
            <i:include src="cocoon:/processBatchesConcurrent.{$ts}.{$locale}.{$start}.{$end}"/>
          </xsl:for-each>          
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="1 to $num-batches">
            <i:include src="cocoon:/processBatch.{$ts}.{$locale}.{.}"/>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </root>
  </xsl:template>
</xsl:stylesheet>