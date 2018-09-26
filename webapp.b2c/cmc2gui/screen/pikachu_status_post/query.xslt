<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:h="http://apache.org/cocoon/request/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="id"/>
	<xsl:variable name="id2" select="upper-case(/h:request/h:requestParameters/h:parameter[@name='Search']/h:value)"/>
	<xsl:variable name="idreal">
		<xsl:choose>
			<xsl:when test="not ($id2 = '')">
				<xsl:value-of select="$id2"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="upper-case($id)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- -->
	<xsl:template match="/h:request/h:requestParameters">
		<root id="{$idreal}">
			<xsl:if test="string-length($idreal) &gt; 3">
				<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
               <sql:query name="status">
select cobj.object_id, cobj.division legacydivision, cobj2.division division, cobj2.country, cobj2.sop, cobj2.eop, cobj2.deleted
, raw_.localisation raw_l, raw_.status rawstatus, raw_.masterlastmodified_ts rawmlm, raw_.lastmodified_ts rawlm, raw_.needsprocessing_flag rawnpf
, enriched.localisation enriched_l, enriched.status enrichedstatus, enriched.masterlastmodified_ts enrichedmlm, enriched.lastmodified_ts enrichedlm, enriched.needsprocessing_flag enrichednpf
, localised.localisation localised_l, localised.status localisedstatus, localised.masterlastmodified_ts localisedmlm, localised.lastmodified_ts localisedlm, localised.needsprocessing_flag localisednpf
, translated.localisation translated_l, translated.status translatedstatus, translated.masterlastmodified_ts translatedmlm, translated.lastmodified_ts translatedlm, translated.needsprocessing_flag translatednpf, translated.remark
, pmt.localisation pmt_l, pmt.status pmtstatus, pmt.masterlastmodified_ts pmtmlm, pmt.lastmodified_ts pmtlm, pmt.needsprocessing_flag pmtnpf
, ae.lasttransmit atglastexport
, ren.lasttransmit renlastexport, cobj2.soppass, cobj2.eoppass, nvl(ae.atgexportenableflag,0) atgexportenableflag, nvl(ren.renexportenableflag,0) renexportenableflag
, cobj2.lastmodified cobjlastmodified, cobj2.locale
from (select distinct co.object_id, omd.division from catalog_objects co inner join object_master_data omd on co.object_id = omd.object_id
where ( customer_id is not null or catalog_id = 'ProductMasterDataCatalog')
  and co.object_id = '<xsl:value-of select="$idreal"/>'
) cobj
left join
(select cobj2.*,ll.locale, ll.languagecode from 
  (select object_id, country, max(lastmodified) lastmodified, to_char(min(sop),'YYYYMMDD') sop
         , case when min(sop) &lt; sysdate then 1 else 0 end as soppass, to_char(max(eop),'YYYYMMDD') eop, case when max(eop) &gt;= sysdate then 1 else 0 end as eoppass, min(deleted) deleted, max(division) division from catalog_objects where object_id = '<xsl:value-of select="$idreal"/>' and country is not null group by object_id, country) cobj2
     inner join 
   locale_language ll 
     on cobj2.country = ll.country
) cobj2 
on cobj.object_id = cobj2.object_id 
left join (
  select o.object_id, o.localisation, o.status, o.masterlastmodified_ts, o.lastModified_ts
       , oc.needsprocessing_flag 
  from octl o
  left outer join octl_control oc
      on oc.content_type = o.content_type
     and oc.localisation = o.localisation
     and oc.object_id    = o.object_id
     and oc.modus        = 'BATCH'
  where o.object_id = '<xsl:value-of select="$idreal"/>' and o.content_type = 'PMT_Raw'  
) raw_ on cobj.object_id = raw_.object_id
left join (
  select o.object_id, o.localisation, o.status, o.masterlastmodified_ts, o.lastModified_ts
       , oc.needsprocessing_flag 
  from octl o
  left outer join octl_control oc
      on oc.content_type = o.content_type
     and oc.localisation = o.localisation
     and oc.object_id    = o.object_id
     and oc.modus        = 'BATCH'
  where o.object_id = '<xsl:value-of select="$idreal"/>' and o.content_type = 'PMT_Enriched'  
) enriched on cobj.object_id = enriched.object_id
left join (
  select o.object_id, o.localisation, o.status, o.masterlastmodified_ts, o.lastModified_ts
       , oc.needsprocessing_flag 
  from octl o
  left outer join octl_control oc
      on oc.content_type = o.content_type
     and oc.localisation = o.localisation
     and oc.object_id    = o.object_id
     and oc.modus        = 'BATCH'
  where o.object_id = '<xsl:value-of select="$idreal"/>' and o.content_type = 'PMT_Localised'   
) localised on cobj2.object_id = localised.object_id and cobj2.country = substr(localised.localisation,8,2)
left join (
  select o.object_id, o.localisation, o.status, o.masterlastmodified_ts, o.lastModified_ts
       , oc.needsprocessing_flag 
       , ll.country, remark
    from octl o 
   inner join locale_language ll on o.localisation = ll.locale
   left outer join octl_control oc
      on oc.content_type = o.content_type
     and oc.localisation = o.localisation
     and oc.object_id    = o.object_id
     and oc.modus        = 'BATCH'
  where o.object_id = '<xsl:value-of select="$idreal"/>' and o.content_type = 'PMT_Translated'   
) translated on cobj.object_id = translated.object_id and cobj2.locale = translated.localisation
left join (
  select o.object_id, o.localisation, o.status, o.masterlastmodified_ts, o.lastModified_ts
       , oc.needsprocessing_flag 
       , ll.country 
  from octl o inner join locale_language ll on o.localisation = ll.locale
  left outer join octl_control oc
      on oc.content_type = o.content_type
     and oc.localisation = o.localisation
     and oc.object_id    = o.object_id
     and oc.modus        = 'BATCH'
  where o.object_id = '<xsl:value-of select="$idreal"/>' and o.content_type = 'PMT'   
) pmt on cobj.object_id = pmt.object_id and cobj2.locale = pmt.localisation      
left join (
         select cc.locale, cc.division, omd.object_id, max(cle.lasttransmit) lasttransmit, max(cc.enabled) atgexportenableflag 
         from channels c inner join channel_catalogs cc on cc.customer_id = c.id and c.name = 'AtgExport'
         inner join object_master_data omd on cc.division = omd.division AND cc.BRAND = omd.BRAND and omd.OBJECT_ID = '<xsl:value-of select="$idreal"/>' 
         left outer join customer_locale_export CLE ON OMD.OBJECT_ID = CLE.CTN AND CLE.customer_id = 'AtgExport' AND cle.locale = cc.locale
         group by cc.locale, cc.division, omd.object_id
         ) ae on cobj2.object_id = ae.object_id and cobj2.locale = ae.locale
left join (
         select cc.locale, cc.division, omd.object_id, max(cle.lasttransmit) lasttransmit, max(cc.enabled) renexportenableflag from channels c inner join channel_catalogs cc on cc.customer_id = c.id and c.name = 'AtgExport'
         inner join object_master_data omd on cc.division = omd.division AND cc.BRAND = omd.BRAND and omd.OBJECT_ID = '<xsl:value-of select="$idreal"/>' 
         left outer join customer_locale_export CLE ON OMD.OBJECT_ID = CLE.CTN AND CLE.customer_id = 'RenderingExport' AND cle.locale = cc.locale
         group by cc.locale, cc.division, omd.object_id
         ) ren on cobj2.object_id = ren.object_id and cobj2.locale = ren.locale 
order by cobj2.country, cobj2.locale
               </sql:query>
				</sql:execute-query>
			</xsl:if>
		</root>
	</xsl:template>
	<!-- -->
	<xsl:template match="h:node()">
		<xsl:apply-templates/>
	</xsl:template>
</xsl:stylesheet>
