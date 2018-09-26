<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" >
  
  <xsl:template match="/">
  <root>

    <sql:execute-query>
      <sql:query>
update object_categorization oc
   set oc.deleted = 1
     , oc.lastmodified = sysdate
where not exists (select 1 
                 from object_categorization_ext oce where oce.catalogcode = oc.catalogcode
                 and oce.object_id = oc.object_id
                 and oc.subcategory=oce.subcategory
                 )
  and exists (select 1 
                from object_categorization_ext oce
               where oce.catalogcode = oc.catalogcode
             )
  and nvl(oc.deleted,0) = 0
     </sql:query>
    </sql:execute-query>
  
      <sql:execute-query>
      <sql:query>
merge into object_categorization oc
using  ( SELECT DISTINCT * FROM object_categorization_ext ) oce
  on (    oc.catalogcode = oce.catalogcode
      and oc.object_id   = oce.object_id
      and oc.subcategory = oce.subcategory)
  when matched then
    update set oc.deleted      = 0
             , oc.lastmodified = oce.lastmodified
     where oc.deleted != oce.deleted
  when not matched then
     insert ( oc.catalogcode, oc.object_id, oc.subcategory, oc.source, oc.isautogen, oc.object_type, oc.deleted, oc.lastmodified)
     values ( oce.catalogcode, oce.object_id, oce.subcategory, oce.source, oce.isautogen, oce.object_type, oce.deleted, oce.lastmodified)        

      </sql:query>
    </sql:execute-query> 
</root>
  </xsl:template>  
</xsl:stylesheet>