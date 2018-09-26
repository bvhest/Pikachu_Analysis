<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:i="http://apache.org/cocoon/include/1.0">

  <xsl:param name="deletionsthreshold" select="0" as="xs:decimal"/>
  <xsl:param name="overrideCheck" select="'no'"/>
  <xsl:param name="source"/>
  <xsl:param name="destination"/>
  <xsl:param name="timestamp"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/root">
    <root>
      <!-- Each sql_row represent the deletion info for one customer id/country (i.e. one catalog) -->
      <xsl:apply-templates select="sql:rowset[@name='catalogs']/sql:row"/>
    </root>
  </xsl:template>

  <xsl:template match="sql:rowset/sql:row">
    <catalog catalog_id="{sql:catalog_id}" customer_id="{sql:customer_id}" country="{sql:country}">
      <xsl:variable name="catalog-deletions" select="../../sql:rowset[@name='deletions']/sql:row[sql:catalog_id=current()/sql:catalog_id]"/>
      <xsl:variable name="actual-total" select="sql:rowset/sql:row/sql:actual_total"/>
      
      <xsl:choose>
        <xsl:when test="exists($catalog-deletions)">
          <xsl:variable name="relative-deletions" select="if ($actual-total != '0') then
                                                            100 * number($catalog-deletions/sql:catalog_deleted) div number($actual-total)
                                                          else
                                                            0"
                                                  as="xs:decimal"/>
          <xsl:attribute name="action" select="if ($overrideCheck != 'yes' and $relative-deletions gt number($deletionsthreshold)) then 'block' else 'proceed'"/>
          <counts actual="{$actual-total}" deleted="{$catalog-deletions/sql:catalog_deleted}"
                  deleted-relative="{format-number($relative-deletions, '##0.0')}"
                  threshold-relative="{$deletionsthreshold}"
                  deletions-allowed="{floor(number($deletionsthreshold) div 100 * number(sql:rowset/sql:row/sql:actual_total))}"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="action" select="'proceed'"/>
          <counts actual="{$actual-total}"/>
        </xsl:otherwise>
      </xsl:choose>
    </catalog>
  </xsl:template>
    
</xsl:stylesheet>
