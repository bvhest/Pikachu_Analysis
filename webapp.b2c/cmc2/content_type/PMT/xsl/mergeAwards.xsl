<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="sql xsl cinclude">

  <!-- 
    Merge Awards that are in PMT_Translated with Awards included from PMA.
    Awards from PMT_Translated have precendence.
  -->
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="@*|node()" mode="product">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="entry/content/octl/sql-rowset/sql-row[sql-content_type='PMT_Translated']/sql-data/Product">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="product"/>
    </xsl:copy>
  </xsl:template> 
  
	<xsl:template match="ReviewStatistics" mode="product">
		<xsl:if test="../Award/octl/sql:rowset/sql:row/sql:data/object/ReviewStatistics">
		<xsl:copy>
		<xsl:choose>
			<xsl:when test="../Award/octl/sql:rowset/sql:row/sql:data/object/ReviewStatistics/ReviewStatistics">
				<xsl:copy-of select="../Award/octl/sql:rowset/sql:row/sql:data/object/ReviewStatistics/ReviewStatistics"/></xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="@*|node()" mode="product"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:copy>
	</xsl:if>
  </xsl:template>

  <xsl:template match="Award" mode="product">
    <!-- Only act on the first Award -->
    <xsl:if test="not(preceding-sibling::Award)">
      <xsl:call-template name="merge-awards">
        <xsl:with-param name="original-awards" select="../Award[not(octl)]"/>
        <xsl:with-param name="secondary-awards" select="../Award/octl/sql:rowset/sql:row/sql:data/object/Awards/Award"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="merge-awards">
    <xsl:param name="original-awards"/>
    <xsl:param name="secondary-awards"/>
    <xsl:copy-of select="$original-awards"/>
    <xsl:copy-of select="for $aw in $secondary-awards return if ($aw/AwardCode = $original-awards/AwardCode) then () else $aw"/>
  </xsl:template>
</xsl:stylesheet>
