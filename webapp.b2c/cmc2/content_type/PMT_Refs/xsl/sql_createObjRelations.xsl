<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="ts"/>

  <!-- Identity transform -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>

  <xsl:template match="entry">
  <entry>
    <xsl:apply-templates select="@*|node()"/>

    <!-- and add SQL to create the object relations in the database -->
    <xsl:if test="count(content/Product/ProductRefs/ProductReference[@ProductReferenceType='Performer']/CTN) > 0">
        <accessories>
        <sql:execute-query name="create ObjRelations">
          <sql:query name="create ObjRelations" isstoredprocedure="true">
DECLARE
   -- util variables
   l_processing_ts         DATE := TO_DATE('<xsl:value-of select="$ts"/>', 'YYYYMMDDHH24MISS');
   l_accessory_object_id   object_relations.object_id_tgt%TYPE := '<xsl:value-of select="content/Product/CTN/text()"/>';

BEGIN          
<xsl:for-each select="content/Product/ProductRefs/ProductReference[@ProductReferenceType='Performer']/CTN">
   insert into object_relations$ values('<xsl:value-of select="text()" />'
                                      , l_accessory_object_id
                                      , 'PRD_ACC'
                                      , 0
                                      , l_processing_ts);
</xsl:for-each>

   -- remove object_relations that are not present in the current data:
   update object_relations
      set deleted         = 1
        , lastmodified_ts = l_processing_ts
    where object_id_src not in (select prd.object_id_src 
                                  from object_relations$ prd
                                )
      and object_id_tgt = l_accessory_object_id
      and rel_type      = 'PRD_ACC'
      and deleted       = 0
   ;

   -- create new/update existing object_relations:
   merge into object_relations old
   using (select prd.object_id_src        as object_id_src  -- product
               , prd.object_id_tgt        as object_id_tgt  -- accessory
               , prd.rel_type             as rel_type
               , prd.deleted              as deleted
               , prd.lastmodified_ts      as lastmodified_ts
            from object_relations$ prd
         ) new
      on ( old.object_id_src = new.object_id_src -- product
       and old.object_id_tgt = new.object_id_tgt -- accessory
       and old.rel_type      = new.rel_type
         )
   when matched then
      update set deleted     = new.deleted
           , lastmodified_ts = new.lastmodified_ts
				where old.deleted != 0
   when not matched then
      insert ( object_id_src
             , object_id_tgt
             , rel_type
             , deleted
             , lastmodified_ts
             )
      values ( new.object_id_src
             , new.object_id_tgt
             , new.rel_type
             , new.deleted
             , new.lastmodified_ts
             );

   -- trigger related product PMT_Master-records for processing
   -- is performed with a trigger on the object_relations table:

   commit;
   
exception
   when others then 
     rollback; 
     raise_application_error (-20000, SUBSTR('Error creating object_relations():'||sqlerrm, 1, 4000));
END;          
          </sql:query>
        </sql:execute-query>
        </accessories>
      </xsl:if>
  </entry>
  </xsl:template>  
  
</xsl:stylesheet>