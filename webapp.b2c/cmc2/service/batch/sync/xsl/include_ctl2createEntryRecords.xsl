<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:i="http://apache.org/cocoon/include/1.0"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:param name="timestamp"/>
  <xsl:param name="ct"/>
  <xsl:param name="input_ct"/>
  <xsl:param name="country_code"/>
  <xsl:param name="ctURL"/>
  <xsl:param name="start_batch_number" as="xs:integer"/>
  <xsl:param name="end_batch_number" as="xs:integer"/>

  <xsl:template match="/root">
    <root>
      <xsl:choose>
        <xsl:when test="$ct = 'PMT'">
          <xsl:for-each select="for $batch_number in $start_batch_number to $end_batch_number return $batch_number">
            <i:include src="{$ctURL}/{$ct}/createEntryRecords/{$ct}/{$input_ct}/{$country_code}/{$timestamp}?batch_number={.}" />
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="sql:rowset/sql:row" />
        </xsl:otherwise>
      </xsl:choose>
    </root>
  </xsl:template>

  <xsl:template match="sql:rowset/sql:row">
    <i:include src="cocoon:/createEntryRecords/{sql:content_type}/{sql:input_content_type}/{sql:country_code}/{$timestamp}" />
  </xsl:template>
</xsl:stylesheet>
