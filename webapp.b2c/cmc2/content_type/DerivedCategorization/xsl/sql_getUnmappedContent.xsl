<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" >
  
  <xsl:template match="/">
  <root>

    <sql:execute-query>
      <sql:query>
merge into object_categorization obc 
using (
  select co.OBJECT_ID
  from mv_co_object_id_care co
  where --co.object_id='SHM3100/37BX'
    co.sop &lt;= sysdate
    and co.eop &gt;= trunc(sysdate)
    and co.deleted=0
    and not exists (
     select 1
      
       from object_categorization oc
      
      inner join categorization c
      on c.catalogcode = oc.catalogcode
      and c.subcategorycode = oc.subcategory
      and   c.catalogcode = 'CARE'
      and oc.subcategory!='UNMAPPED_SU'
      
      where oc.object_id=co.object_id
      and oc.deleted =0

  )
) coc
on (
      obc.object_id = coc.OBJECT_ID
  and obc.subcategory='UNMAPPED_SU'
)
when matched then
  update set obc.deleted      = 0
           , obc.lastmodified = sysdate
  where obc.deleted = 1
    and obc.subcategory = 'UNMAPPED_SU'
when not matched then
  insert ( obc.catalogcode, obc.object_id, obc.subcategory, obc.source, obc.isautogen, obc.object_type, obc.deleted, obc.lastmodified)
  values ( 'CARE', coc.OBJECT_ID, 'UNMAPPED_SU', 'DefaultAssignment', 1, 'Product', 0, sysdate)
     </sql:query>
    </sql:execute-query>
  
       
</root>
  </xsl:template>  
</xsl:stylesheet>
