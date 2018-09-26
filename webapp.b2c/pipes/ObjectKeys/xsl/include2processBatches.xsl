<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:i="http://apache.org/cocoon/include/1.0"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    exclude-result-prefixes="xs">

  <xsl:param name="channel"/>
  <xsl:param name="ts"/>
  <xsl:param name="dir"/>
  <xsl:param name="prefix"/>
  <xsl:param name="threads"/>
  <xsl:param name="batch-size"/>
  <xsl:param name="sourceCT"/>
  
  <xsl:variable name="max-batch-size" select="1000"/>
  <xsl:variable name="l-threads" select="if (matches($threads,'\d+')) then number($threads) cast as xs:integer else 1"/>
  <xsl:variable name="l-batch-size" select="if (matches($batch-size,'\d+') and number($batch-size) le $max-batch-size) then number($batch-size) cast as xs:integer else $max-batch-size"/>
  <xsl:variable name="source" select="if ($sourceCT != '') then $sourceCT else 'PMT'" />

  <xsl:template match="@*||node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="root">
    <xsl:copy>
      <xsl:apply-templates/>

      <xsl:variable name="sql-result" select="sql:rowset[@name='count-objects']/sql:row/sql:totalcount"/>
      <xsl:if test="$sql-result">
        <xsl:variable name="num-batches" select="ceiling(number($sql-result) div $l-batch-size) cast as xs:integer"/>
        <xsl:variable name="num-concurrent-batches" select="ceiling($num-batches div $l-threads) cast as xs:integer"/>
 
        <execution-plan>
          <num-objects><xsl:value-of select="$sql-result"/></num-objects>
          <batch-size><xsl:value-of select="$l-batch-size"/></batch-size>
          <threads><xsl:value-of select="$l-threads"/></threads>
          <num-batches><xsl:value-of select="$num-batches"/></num-batches>
          <num-concurrent-batches><xsl:value-of select="$num-concurrent-batches"/></num-concurrent-batches>
        </execution-plan>
      
        <xsl:choose>
          <xsl:when test="$l-threads gt 1">
            <xsl:for-each select="0 to $num-concurrent-batches - 1">
              <xsl:variable name="file-num" value="."/>
              <xsl:variable name="start" select=". * $l-threads + 1"/>
              <xsl:variable name="end" select="min(((. + 1) * $l-threads, $num-batches))"/>
              
              <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
                <source:source>
                  <xsl:value-of select="concat($dir,'/',$prefix,$ts,'.',.,'.xml')"/>
                </source:source>
                <source:fragment>
                  <root>
                    <xsl:for-each select="$start to $end">
                      <i:include src="cocoon:/processBatch.{$ts}.{$source}.{.}"/>
                    </xsl:for-each>
                  </root>
                </source:fragment>
              </source:write>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <!-- simple include to process batches sequencially -->
            <xsl:for-each select="1 to $num-batches">
              <i:include src="cocoon:/processBatch.{$ts}.{$source}.{.}"/>
            </xsl:for-each>
          </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>