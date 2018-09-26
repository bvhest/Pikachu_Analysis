<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="id"/>

	<xsl:template match="/">
		<root id="{$id}">
			<xsl:if test="string-length($id) &gt; 2">
				<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
					<sql:query name="status">
select 
  ppconf.localisation ppconf_l, ppconf.status ppconf_status, ppconf.masterlastmodified_ts ppconf_mlm, ppconf.lastmodified_ts ppconf_lm, ppconf.needsprocessing_flag ppconf_npf
, pplog.localisation pplog_l, pplog.status pplog_status, pplog.masterlastmodified_ts pplog_mlm, pplog.lastmodified_ts pplog_lm, pplog.needsprocessing_flag pplog_npf
, ptext_raw.localisation ptext_raw_l, ptext_raw.status ptext_raw_status, ptext_raw.masterlastmodified_ts ptext_raw_mlm, ptext_raw.lastmodified_ts ptext_raw_lm, ptext_raw.needsprocessing_flag ptext_raw_npf
, ptext_translated.localisation ptext_translated_l, ptext_translated.status ptext_translated_status, ptext_translated.masterlastmodified_ts ptext_translated_mlm, ptext_translated.lastmodified_ts ptext_translated_lm, ptext_translated.needsprocessing_flag ptext_translated_npf
, pp_translations.localisation pp_translations_l, pp_translations.status pp_translations_status, pp_translations.masterlastmodified_ts pp_translations_mlm, pp_translations.lastmodified_ts pp_translations_lm, pp_translations.needsprocessing_flag pp_translations_npf
from (
  select o.object_id, o.localisation, o.status, o.masterlastmodified_ts, o.lastModified_ts
       , oc.needsprocessing_flag 
    from octl o
   inner join octl_control oc
      on oc.content_type = o.content_type
     and oc.localisation = o.localisation
     and oc.object_id    = o.object_id
     and oc.modus        = 'BATCH'
   where o.object_id    = '<xsl:value-of select="$id"/>' 
     and o.content_type = 'PP_Configuration'  
      ) ppconf
left join (
  select o.object_id, o.localisation, o.status, o.masterlastmodified_ts, o.lastModified_ts
       , oc.needsprocessing_flag 
    from octl o
   inner join octl_control oc
      on oc.content_type = o.content_type
     and oc.localisation = o.localisation
     and oc.object_id    = o.object_id
     and oc.modus        = 'BATCH'
   where o.object_id = '<xsl:value-of select="$id"/>' 
     and o.content_type     = 'PP_Log'  
          ) pplog 
   on ppconf.object_id = pplog.object_id
left join (
  select o.object_id, o.localisation, o.status, o.masterlastmodified_ts, o.lastModified_ts
       , oc.needsprocessing_flag 
    from octl o
   inner join octl_control oc
      on oc.content_type = o.content_type
     and oc.localisation = o.localisation
     and oc.object_id    = o.object_id
     and oc.modus        = 'BATCH'
   where o.object_id    = '<xsl:value-of select="$id"/>' 
     and o.content_type = 'PText_Raw'   
          ) ptext_raw 
   on ppconf.object_id = ptext_raw.object_id
left join (
  select o.object_id, o.localisation, o.status, o.masterlastmodified_ts, o.lastModified_ts
       , oc.needsprocessing_flag
       , ll.country 
    from octl o 
   inner join octl_control oc
      on oc.content_type = o.content_type
     and oc.localisation = o.localisation
     and oc.object_id    = o.object_id
     and oc.modus        = 'BATCH'
   inner join locale_language ll 
      on o.localisation = ll.locale
   where o.object_id    = '<xsl:value-of select="$id"/>' 
     and o.content_type = 'PText_Translated'   
          ) ptext_translated 
   on ppconf.object_id = ptext_translated.object_id
left join (
  select o.object_id, o.localisation, o.status, o.masterlastmodified_ts, o.lastModified_ts
       , oc.needsprocessing_flag 
       , ll.country 
    from octl o 
   inner join octl_control oc
      on oc.content_type = o.content_type
     and oc.localisation = o.localisation
     and oc.object_id    = o.object_id
     and oc.modus        = 'BATCH'
   inner join locale_language ll 
      on o.localisation = ll.locale
   where o.object_id    = '<xsl:value-of select="$id"/>' 
     and o.content_type = 'PP_Translations'   
          ) pp_translations 
   on ppconf.object_id = pp_translations.object_id
order by ptext_translated.localisation
		</sql:query>
				</sql:execute-query>
			</xsl:if>
		</root>
	</xsl:template>
</xsl:stylesheet>
