<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
  <xsl:template match="/root">
    <root xmlns:cinclude="http://apache.org/cocoon/include/1.0">
      <xsl:variable name="catalog_def_id"         select="sql:rowset/sql:row[sql:content_type = 'catalog_definition']/sql:id"/>
      <xsl:variable name="catalog_log_id"         select="sql:rowset/sql:row[sql:content_type = 'catalog_log']/sql:id"/>    
      <xsl:variable name="keyvaluepairs_id"       select="sql:rowset/sql:row[sql:content_type = 'KeyValuePairs']/sql:id"/>
      <xsl:variable name="assettemplate_id"       select="sql:rowset/sql:row[sql:content_type = 'AssetTemplate']/sql:id"/>
      <xsl:variable name="pmt_master_id"          select="sql:rowset/sql:row[sql:content_type = 'PMT_Master']/sql:id"/>    
      <xsl:variable name="pmt_id"                 select="sql:rowset/sql:row[sql:content_type = 'PMT']/sql:id"/>    
      <cinclude:include src="cocoon://cmc2/content_type/catalog_definition?schedule_id={$catalog_def_id}"/>
      <cinclude:include src="cocoon://cmc2/content_type/catalog_log?schedule_id={$catalog_log_id}"/>            
      <cinclude:include src="cocoon://cmc2/content_type/KeyValuePairs?schedule_id={$keyvaluepairs_id}"/>      
      <cinclude:include src="cocoon://cmc2/content_type/AssetTemplate?schedule_id={$assettemplate_id}"/>      
      <!-- not sure whether it's a good idea to include pmt_master and pmt; probably better to run them manually -->
    </root>
  </xsl:template>
</xsl:stylesheet>
