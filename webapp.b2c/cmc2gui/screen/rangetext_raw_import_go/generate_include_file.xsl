<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
  <xsl:template match="/root">
    <root xmlns:cinclude="http://apache.org/cocoon/include/1.0">
      <xsl:variable name="catalog_def_id"          select="sql:rowset/sql:row[sql:content_type = 'catalog_definition']/sql:id"/>
      <xsl:variable name="catalog_log_id"          select="sql:rowset/sql:row[sql:content_type = 'catalog_log']/sql:id"/>    
      <xsl:variable name="rangetext_raw_id"        select="sql:rowset/sql:row[sql:content_type = 'RangeText_Raw']/sql:id"/>
      <xsl:variable name="rangetext_localized_id"  select="sql:rowset/sql:row[sql:content_type = 'RangeText_Localized']/sql:id"/>
      <xsl:variable name="rangetext_translated_id" select="sql:rowset/sql:row[sql:content_type = 'RangeText_Translated']/sql:id"/>
      <xsl:variable name="rangetext_id"            select="sql:rowset/sql:row[sql:content_type = 'RangeText']/sql:id"/>
      <xsl:variable name="pmtenriched_id"          select="sql:rowset/sql:row[sql:content_type = 'PMT_Enriched']/sql:id"/>
      <xsl:variable name="pmtmaster_id"          select="sql:rowset/sql:row[sql:content_type = 'PMT_Master']/sql:id"/>

      <!-- This wil be run as a part of RangeText_Raw 
		cinclude:include src="cocoon://cmc2/content_type/catalog_definition?schedule_id={$catalog_def_id}"/>
      <cinclude:include src="cocoon://cmc2/content_type/catalog_log?schedule_id={$catalog_log_id}"/-->      
      <cinclude:include src="cocoon://cmc2/content_type/RangeText_Raw?schedule_id={$rangetext_raw_id}"/>
      <!--
      <cinclude:include src="cocoon://cmc2/content_type/RangeText_Localized?schedule_id={$rangetext_localized_id}"/>
      <cinclude:include src="cocoon://cmc2/content_type/RangeText_Translated?schedule_id={$rangetext_translated_id}"/>
      <cinclude:include src="cocoon://cmc2/content_type/RangeText?schedule_id={$rangetext_id}"/>
      <cinclude:include src="cocoon://cmc2/content_type/PMT_Enriched?schedule_id={$pmtenriched_id}"/>
      <cinclude:include src="cocoon://cmc2/content_type/PMT_Master?schedule_id={$pmtmaster_id}"/>
      -->
    </root>
  </xsl:template>
</xsl:stylesheet>
