<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
  <xsl:template match="/root">
    <root xmlns:cinclude="http://apache.org/cocoon/include/1.0">
      <xsl:variable name="catalog_def_id"          select="sql:rowset/sql:row[sql:content_type = 'catalog_definition']/sql:id"/>
      <xsl:variable name="catalog_log_id"          select="sql:rowset/sql:row[sql:content_type = 'catalog_log']/sql:id"/>    
      <xsl:variable name="localization_id"         select="sql:rowset/sql:row[sql:content_type = 'Localization']/sql:id"/>
      <xsl:variable name="rangetext_loc_id"        select="sql:rowset/sql:row[sql:content_type = 'RangeText_Localized']/sql:id"/>
      <xsl:variable name="rangetext_tra_id"        select="sql:rowset/sql:row[sql:content_type = 'RangeText_Translated']/sql:id"/>      
      <xsl:variable name="rangetext_id"            select="sql:rowset/sql:row[sql:content_type = 'RangeText']/sql:id"/>            
      <xsl:variable name="pmtlocalised_id"         select="sql:rowset/sql:row[sql:content_type = 'PMT_Localised']/sql:id"/>      
      <cinclude:include src="cocoon://cmc2/content_type/catalog_definition?schedule_id={$catalog_def_id}"/>
      <cinclude:include src="cocoon://cmc2/content_type/catalog_log?schedule_id={$catalog_log_id}"/>            
      <cinclude:include src="cocoon://cmc2/content_type/Localization?schedule_id={$localization_id}"/>      
      <cinclude:include src="cocoon://cmc2/content_type/RangeText_Localized?schedule_id={$rangetext_loc_id}"/>
      <cinclude:include src="cocoon://cmc2/content_type/RangeText_Translated?schedule_id={$rangetext_tra_id}"/>
      <cinclude:include src="cocoon://cmc2/content_type/RangeText?schedule_id={$rangetext_id}"/>
      <cinclude:include src="cocoon://cmc2/content_type/PMT_Localised?schedule_id={$pmtlocalised_id}"/>
    </root>
  </xsl:template>
</xsl:stylesheet>
