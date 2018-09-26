<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <xsl:param name="Catalog"/>
        <xsl:param name="Country"/>

  <!-- -->
  <xsl:template match="/">
    <root>
      <sql:execute-query>
        <sql:query>
select co.OBJECT_ID, cl.LOCALISATION,      
CASE WHEN co.eop &lt; sysdate or co.sop >= (sysdate+31) or co.deleted=1 or pmt_enriched.status='Deleted' THEN 'inactive'
            ELSE 'active' END activity,
ts.status translation_status,
to_char(co.sop,'dd-Mon-yy') sop, to_char(co.eop, 'dd-Mon-yy') eop,
pmt_enriched.MARKETINGVERSION mv_enriched, pmt_enriched.STATUS status_enriched, 
pmt.MARKETINGVERSION mv_pmt, pmt.STATUS status_pmt,
pmt.STATUS status_fk,
pmt.data
from catalog_objects co
inner join catalog_ctl cl on cl.CATALOG_ID = co.CATALOG_ID and cl.CONTENT_TYPE = 'PMT2SPOT'
inner join octl pmt on pmt.CONTENT_TYPE = 'PMT' and pmt.LOCALISATION = cl.LOCALISATION and pmt.OBJECT_ID = co.OBJECT_ID 
inner join octl pmt_enriched on pmt_enriched.CONTENT_TYPE = 'PMT_Enriched' and pmt_enriched.LOCALISATION = 'master_global' and pmt_enriched.OBJECT_ID = co.OBJECT_ID 
left outer join octl filter_keys on filter_keys.CONTENT_TYPE = 'WebSiteFiltering' and filter_keys.LOCALISATION = 'master_global' and filter_keys.OBJECT_ID = co.OBJECT_ID 
inner join translation_status ts on ts.object_id = co.object_id and ts.locale = cl.LOCALISATION
where co.CUSTOMER_ID = '<xsl:value-of select="$Catalog" />'
and co.country = '<xsl:value-of select="$Country" />'
<!-- and co.object_id='42PFL5603D/27' -->
<!-- and co.object_id in ('1050X/20','1050X/22','1060X/20', '1090X/20','10FF2CMW/27','19PFL3403D/27','19PFL3403D/F7','47PFL7603D/F7','HD7814/60','HD7850/80','MNT1020/05','HTS8100/05') -->
order by co.object_id
        </sql:query>
      </sql:execute-query>
      
    </root>
  </xsl:template>
</xsl:stylesheet>