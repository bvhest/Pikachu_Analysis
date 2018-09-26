<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:param name="threshold" />
  <xsl:param name="overrideCheck"/>
  <xsl:param name="locale"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/root">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:variable name="relative-deleted-count" select="if (number(files-in-cache/@n) &gt; 0) then 100 * (count(delete) div number(files-in-cache/@n)) else 0"/>
      <xsl:choose>
        <xsl:when test="$relative-deleted-count gt number($threshold) and not($overrideCheck = 'yes')">
          <xsl:variable name="rel-deleted-fmt" select="format-number($relative-deleted-count, '##0.0')"/>
          <cinclude:include src="cocoon:/abortDeletions.{$locale}?filecount={count(delete)}&amp;rel-count={$rel-deleted-fmt}" />
          <report name="deleted objects" count="{count(delete)}" relative-count="{$rel-deleted-fmt}%" relative-allowed="{$threshold}%">
            <xsl:apply-templates select="delete" mode="report"/>
          </report>
        </xsl:when>
        <xsl:otherwise>
          <!-- Copy the delete elements to proceed -->
          <xsl:apply-templates select="delete"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="delete" mode="report">
    <id l="{@locale}" ct="{@ct}"><xsl:value-of select="@id"/></id>
  </xsl:template>
</xsl:stylesheet>