<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:h="http://apache.org/cocoon/request/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="id"/>
  <xsl:variable name="id2" select="upper-case(/h:request/h:requestParameters/h:parameter[@name='SearchContent']/h:value)"/>
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
  <xsl:template match="/">
    <root>
      <!-- -->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="search_content">
            select distinct o.object_id, o.content_type, nvl(cts.id,0)  schedule_id
             from octl o
             left outer join (select content_type, max(sequence) as id from content_type_schedule where machineaffinity != 'all(FL)' group by content_type) cts 
               on cts.content_type = o.content_type
            where object_id =  '<xsl:value-of select="$idreal"/>'
            order by nvl(cts.id,0)  
        </sql:query>
        <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
          <sql:query name="search_content_data">
            select o.object_id
                 , o.content_type
                 , o.localisation
                 , TO_CHAR(o.masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
                 , TO_CHAR(o.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts
                 , nvl(oc_b.needsprocessing_flag,0)  as needsprocessing_flag_b
                 , nvl(oc_fl.needsprocessing_flag,0) as needsprocessing_flag_fl
                 , case 
                     when (mvo.deleted = 0 and eop > sysdate) then 1 
                     when mvo.deleted is null then 1 
                     else 0 
                   end as active_flag
                 , o.marketingversion
                 , o.status
                 , case when o.data is null then 0 else 1 end as dataavailable
                 , nvl(o.islocalized,0) as islocalized
              from octl o
         left join mv_co_object_id mvo
                on mvo.object_id = o.object_id
         left join octl_control oc_b
                on oc_b.content_type        = o.content_type
               and oc_b.localisation        = o.localisation       
               and oc_b.object_id           = o.object_id
               and oc_b.modus               = 'BATCH'
         left join octl_control oc_fl
                on oc_fl.content_type       = o.content_type
               and oc_fl.localisation       = o.localisation       
               and oc_fl.object_id          = o.object_id
               and oc_fl.modus              = 'FASTLANE'
             where o.object_id    = '<sql:ancestor-value name="object_id" level="1"/>' 
               and o.content_type = '<sql:ancestor-value name="content_type" level="1"/>' 
            </sql:query>
        </sql:execute-query>
      </sql:execute-query>
      <!-- -->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
         <sql:query name="catalogs">
         select distinct cc.ctn, cc.country, cc.customer_id as catalog_type, to_char(cc.sop, 'YYYY-MM-DD') as SOP, to_char(cc.eop, 'YYYY-MM-DD') as EOP, cc.priority, cc.local_going_price, cc.division, cc.lastmodified, cc.deleted, ll.locale, ll.language, case when lp.id is not null then 'true' else 'false' end as lpexists
         from customer_catalog cc
         left join locale_language ll on ll.country=cc.country
         left outer join localized_products lp on ll.locale = lp.locale and cc.ctn = lp.id
         where   cc.ctn = '<xsl:value-of select="$idreal"/>'
         order by cc.customer_id, ll.locale
         </sql:query>
      </sql:execute-query>      
      
    </root>
  </xsl:template>
</xsl:stylesheet>
