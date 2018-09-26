<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:h="http://apache.org/cocoon/request/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:template match="/">
    <root>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="missedtranslations">
          select localised.CONTENT_TYPE "Content Type"
                ,localised.LOCALISATION Locale
                ,localised.OBJECT_ID CTN
                ,decode(oc_loc.NEEDSPROCESSING_FLAG,1,'Yes',0,'No') Needsprocessing
                ,to_char(localised.MASTERLASTMODIFIED_TS,'YYYY-MM-DD HH24:MI:SS') MasterLastModified
                ,to_char(localised.LASTMODIFIED_TS,'YYYY-MM-DD HH24:MI:SS') LastModified
                ,to_char(raw_.masterlastmodified_ts,'YYYY-MM-DD HH24:MI:SS') "PMT_RAW MASTERLASTMODIFIED"                
                ,to_char(localised.STARTOFPROCESSING,'YYYY-MM-DD') STARTOFPROCESSING
                ,to_char(localised.ENDOFPROCESSING,'YYYY-MM-DD') ENDOFPROCESSING
                ,decode(localised.ACTIVE_FLAG,1,'Yes',0,'No') Active
                ,localised.STATUS
                ,localised.REMARK
           from octl localised 
           left join octl_control oc_loc
             on oc_loc.modus        = 'BATCH'
            and oc_loc.content_type = localised.content_type
            and oc_loc.localisation = localised.localisation
            and oc_loc.object_id    = localised.object_id
          left outer join (select content_type, localisation, object_id, max(masterlastmodified_ts)masterlastmodified_ts 
                           from octl_translations 
                           where content_type = 'PMT_Translated' group by content_type, localisation, object_id) ot 
             on localised.object_id = ot.object_id
             and substr(localised.localisation,8) = substr(ot.localisation,4)
          inner join locale_language ll 
             on ll.country = substr(localised.localisation,8)
          inner join octl translated 
              on translated.object_id = localised.object_id
             and translated.localisation = ll.locale 
             and translated.content_type = 'PMT_Translated'
           left join octl_control oc_tra
             on oc_tra.modus        = 'BATCH'
            and oc_tra.content_type = localised.content_type
            and oc_tra.localisation = localised.localisation
            and oc_tra.object_id    = localised.object_id
          inner join octl raw_
             on localised.object_id = raw_.object_id 
             and raw_.localisation = 'none' 
             and raw_.content_type = 'PMT_Raw'
          inner join language_translations lt 
             on lt.locale = translated.localisation
          inner join (select object_id, country, MAX(EOP) EOP 
                      from catalog_objects 
                      where EOP > SYSDATE and deleted = 0 group by object_id, country) co 
             on co.object_id = localised.object_id 
             and co.country = ll.country   
          inner join object_master_data omd 
             on omd.object_id = localised.object_id
             and omd.division = lt.division  
          where localised.content_type = 'PMT_Localised'
            and localised.masterlastmodified_ts > nvl(ot.masterlastmodified_ts,to_date('19000101','YYYYMMDD'))
            and raw_.masterlastmodified_ts > nvl(ot.masterlastmodified_ts,to_date('20080126','YYYYMMDD'))
            and oc_tra.needsprocessing_flag != 1
            and lt.enabled = 1
            and lt.isdirect != 1
          --and localised.object_id = 'PET704/05'
          order by localised.lastmodified_ts desc
				</sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
