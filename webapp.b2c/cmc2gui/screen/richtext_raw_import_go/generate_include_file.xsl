<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>                
  <xsl:param name="ct"/>
  <xsl:template match="/root">
    <root xmlns:cinclude="http://apache.org/cocoon/include/1.0">
      <xsl:variable name="richtext_id" select="sql:rowset/sql:row[sql:content_type = $ct]/sql:id"/>
      <xsl:variable name="pmtenriched_id" select="sql:rowset/sql:row[sql:content_type = 'PMT_Enriched']/sql:id"/>
      <xsl:variable name="pmt_id" select="sql:rowset/sql:row[sql:content_type = 'PMT']/sql:id"/>
      <cinclude:include src="{concat('cocoon://cmc2/content_type/',$ct,'?schedule_id=',$richtext_id)}"/>
      <xsl:choose>
        <xsl:when test="$ct = 'RichText_Raw'">
          <cinclude:include src="cocoon://cmc2/content_type/PMT_Enriched?schedule_id={$pmtenriched_id}"/>      
        </xsl:when>
        <xsl:otherwise>
          <cinclude:include src="cocoon://cmc2/content_type/PMT?schedule_id={$pmt_id}"/>      
        </xsl:otherwise>
      </xsl:choose>
    </root>
  </xsl:template>
</xsl:stylesheet>