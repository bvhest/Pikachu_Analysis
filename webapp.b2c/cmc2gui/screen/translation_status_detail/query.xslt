<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1"/>
  <!-- -->
  <xsl:template match="/">
  <root>
	<xsl:attribute name="locale"><xsl:value-of select="$param1"/></xsl:attribute>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
select ll.country
     , os_localised.object_id
     , TO_CHAR(os_localised.masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') localisedmlm
     , TO_CHAR(os_localised.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') localisedlm
     , TO_CHAR(o_translated.masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') translatedmlm
     , TO_CHAR(o_translated.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') translatedlm
     , omd.division
     , cc_g_by_ctn.maxeop
     , o_translated.remark teremark
     , oc_translated.needsprocessing_flag
     , o_translated.status transstatus
     , o_translated.localisation translocale
     , os_localised.localisation locallocale
  from octl os_localised
  inner join octl o_translated
     on os_localised.object_id = o_translated.object_id
   left join octl_control oc_translated
     on oc_translated.modus        = 'BATCH'
    and oc_translated.content_type = o_translated.content_type
    and oc_translated.localisation = o_translated.localisation
    and oc_translated.object_id    = o_translated.object_id
  inner join  object_master_data omd 
     on os_localised.object_id = omd.object_id 
  inner join object_categorization oc 
     on os_localised.object_id = oc.object_id 
    and oc.catalogcode= 'MASTER'
  inner join (select distinct ctn, country from customer_catalog where deleted = 0) cc_g_by_country_ctn
     on os_localised.object_id =  cc_g_by_country_ctn.ctn 
  left outer join (select ctn, max(eop) maxeop from customer_catalog where deleted = 0 group by ctn ) cc_g_by_ctn
     on os_localised.object_id =  cc_g_by_ctn.ctn
  inner join locale_language ll 
     on cc_g_by_country_ctn.country = ll.country
  inner join language_translations lt 
     on ll.LANGUAGECODE = lt.LOCALE
    and lt.locale = o_translated.localisation  
  where os_localised.content_type   = 'PMT_Localised' 
    and os_localised.Status         = 'Final Published' 
    and os_localised.LOCALISATION   = 'master_'||ll.country
    and o_translated.content_type   = 'PMT_Translated' 
    and sysdate                  &lt; cc_g_by_ctn.maxeop
    and lt.isdirect                 = 0
    and ll.locale                   = '<xsl:value-of select="$param1"/>'
   <!-- Look at internal subcats only -->
    and oc.source                  in ('CE_CategorizationTree','DAP_CategorizationTree')
  order by ll.country, os_localised.object_id
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>