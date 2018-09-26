<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:h="http://apache.org/cocoon/request/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1"/>
  <xsl:param name="channel"/>
  <!-- -->
  <xsl:template match="/h:request/h:requestParameters">
    <root>
	  <xsl:attribute name="ctn"><xsl:value-of select="h:parameter[@name='CTN']/h:value"/></xsl:attribute>
	  <xsl:attribute name="language"><xsl:value-of select="h:parameter[@name='language']/h:value"/></xsl:attribute>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
         <sql:query name="schedule_id">
            select id from content_type_schedule where description = 'Translation with Real Export'
         </sql:query>
      </sql:execute-query>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
         <sql:query name="catalogs">
select distinct cc.ctn
     , cc.country
     , cc.customer_id as catalog_type
     , to_char(cc.sop, 'YYYY-MM-DD') as SOP
     , to_char(cc.eop, 'YYYY-MM-DD') as EOP
     , cc.priority
     , cc.division ccdivision
     , cc.lastmodified
     , cc.deleted
     , ll.locale
     , ll.language
     , nvl(o.object_id, 'N/A') oid
     , o.lastmodified_ts
     , o.masterlastmodified_ts
     , nvl(o.status,'') status
     , o.localisation
     , oc.subcategory
     , case when cc.eop &gt; sysdate and cc.deleted = 0 then 1 else 0 end as eoppass
     , case when oc.subcategory is not null then 1 else 0 end as subcatpass
  from customer_catalog cc 
  left outer join object_categorization oc 
    on oc.object_id   = cc.ctn
   and oc.object_type = 'Product' 
   and oc.catalogcode = 'MASTER'
  left join locale_language ll 
    on ll.country     = cc.country
  left join octl o 
    on o.object_id    = cc.ctn
   and o.content_type = 'PMT_Localised' 
   and o.localisation = '<xsl:value-of select="concat('master_',substring-after(h:parameter[@name='language']/h:value,'_'))"/>'
   and o.status       = 'Final Published'
 where cc.ctn         = '<xsl:value-of select="h:parameter[@name='CTN']/h:value"/>'
--   and cc.country     = '<xsl:value-of select="substring-after(h:parameter[@name='language']/h:value,'_')"/>'
 order by cc.ctn, cc.country, cc.customer_id
         </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="h:node()">
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
