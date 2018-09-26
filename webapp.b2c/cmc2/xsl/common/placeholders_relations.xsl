<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >
<!-- -->
<xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="store-outputs">
    <xsl:copy>
      <!-- first trigger octls that will have their relations deleted -->
      <xsl:apply-templates select="trigger-octl"/>
      <!-- next clean out old secondary relations -->
      <!-- Note that we are possibly doingdouble work here, as in we delete the secondary relations for the same object multiple times -->
      <xsl:apply-templates select="drop-relation"/>
      <!-- then create new placeholders and (secondary) relations -->
      <xsl:apply-templates select="@*|node()[not(local-name()='trigger-octl' or local-name()='drop-relation')]"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="placeholder">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:variable name="v_needsprocessing" select="if (@needsProcessing) then @needsProcessing else '1'"/>     
      <sql:execute-query>
        <sql:query name="createPlaceholders">
            insert into octl  (CONTENT_TYPE
                              ,LOCALISATION
                              ,OBJECT_ID
                              ,NEEDSPROCESSING_FLAG
                              ,NEEDSPROCESSING_TS
                              ,INTRANSACTION_FLAG
                              ,MASTERLASTMODIFIED_TS
                              ,LASTMODIFIED_TS
                              ,STARTOFPROCESSING
                              ,ENDOFPROCESSING
                              ,ACTIVE_FLAG
                              ,STATUS
                              ,BATCH_NUMBER
                              ,REMARK
                              ,ISLOCALIZED
                              ,DERIVESECONDARY_FLAG)
                       select  '<xsl:value-of select="@ct"/>'
                              ,'<xsl:value-of select="@l"/>'
                              ,'<xsl:value-of select="@o"/>'
                              ,to_number('<xsl:value-of select="$v_needsprocessing"/>')
                              ,to_date('01/01/2000','dd/mm/yyyy')
                              ,0
                              ,to_date('01/01/1900','dd/mm/yyyy')
                              ,to_date('01/01/1900','dd/mm/yyyy')
                              ,to_date('01/01/1900','dd/mm/yyyy')
                              ,to_date('01/01/2299','dd/mm/yyyy')
                              ,1
                              ,'PLACEHOLDER'
                              ,NULL
                              ,NULL
                              ,NULL
                              ,0
                     from dual
                     where not exists (select 1 
                                         from octl oc
                                        where oc.CONTENT_TYPE = '<xsl:value-of select="@ct"/>'
                                          and oc.LOCALISATION =  '<xsl:value-of select="@l"/>'
                                          and oc.OBJECT_ID    =  '<xsl:value-of select="@o"/>'
                                      )
        </sql:query>
      </sql:execute-query>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="drop-relation">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <sql:execute-query>
        <sql:query name="deletePlaceholdersRelations">
          delete from octl_relations
          where output_content_type = '<xsl:value-of select="@ct-out"/>'
            and output_localisation = '<xsl:value-of select="@l-out"/>'
            and output_object_id = '<xsl:value-of select="@o-out"/>'
          <xsl:if test="@ct-in != '' and not(empty(@ct-in))">
            and input_content_type = '<xsl:value-of select="@ct-in"/>'
            and input_localisation = '<xsl:value-of select="@l-in"/>'
            and input_object_id = '<xsl:value-of select="@o-in"/>'
          </xsl:if>
            and isderived = 1
            and issecondary = 1
            and exists (select 1 
                          from octl o
                         where o.content_type = '<xsl:value-of select="@ct-out"/>'
                           and o.localisation = '<xsl:value-of select="@l-out"/>'
                           and o.object_id    = '<xsl:value-of select="@o-out"/>'
                        )
        </sql:query>
      </sql:execute-query>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="create-relation">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <sql:execute-query name="createPlaceholdersRelations">
        <sql:query name="createPlaceholdersRelations">
          insert into octl_relations (output_content_type
                                     ,output_localisation
                                     ,output_object_id
                                     ,input_content_type
                                     ,input_localisation
                                     ,input_object_id
                                     ,issecondary
                                     ,isderived)
                             select  '<xsl:value-of select="@ct-out"/>'
                                    ,'<xsl:value-of select="@l-out"/>'
                                    ,'<xsl:value-of select="@o-out"/>'
                                    ,'<xsl:value-of select="@ct-in"/>'
                                    ,'<xsl:value-of select="@l-in"/>'
                                    ,'<xsl:value-of select="@o-in"/>'
                                    ,'<xsl:value-of select="@secondary"/>'
                                    ,<xsl:value-of select="@secondary"/>
                           from dual
                           where exists (select 1 
                                           from octl o
                                          where o.content_type = '<xsl:value-of select="@ct-out"/>'
                                            and o.localisation = '<xsl:value-of select="@l-out"/>'
                                            and o.object_id    = '<xsl:value-of select="@o-out"/>'
                                         )
        </sql:query>
      </sql:execute-query>
      <!-- Set NeedsProcessing_Flag on Output_object when 
           1) input_object.status not in ('PLACEHOLDER','Deleted'), and 
           2) the output_object.status in ('PLACEHOLDER','Deleted')
      -->
        <xsl:variable name="v_needsprocessing" select="if (@needsProcessing) then @needsProcessing else '1'"/>     
        <sql:execute-query name="createPlaceholdersRelationsControlRecords">
            <sql:query name="createPlaceholdersRelationsControlRecords">
            merge into octl_control t 
            using (select o.content_type, o.localisation, o.object_id, to_number('<xsl:value-of select="$v_needsprocessing"/>') as needsprocessing_flag 
                     from octl o
                    where o.content_type = '<xsl:value-of select="@ct-out"/>'
                      and o.localisation = '<xsl:value-of select="@l-out"/>'
                      and o.object_id    = '<xsl:value-of select="@o-out"/>'
                      and exists ( select 1
                                     from octl in_o
                                    where in_o.content_type       = o.content_type
                                      and in_o.localisation       = o.localisation
                                      and in_o.object_id          = o.object_id
                                      and in_o.status            in ('PLACEHOLDER', 'Deleted')
                                 )
                      and exists ( select 1
                                     from octl in_o
                                        , octl_relations o_r
                                    where in_o.content_type       = o_r.input_content_type
                                      and in_o.localisation       = o_r.input_localisation
                                      and in_o.object_id          = o_r.input_object_id
                                      and ((in_o.content_type      = 'PText_Raw' and in_o.status = 'PLACEHOLDER')
                                        or in_o.status        not in ('PLACEHOLDER', 'Deleted')
                                          )
                                      and o_r.output_content_type = o.content_type
                                      and o_r.output_localisation = o.localisation
                                      and o_r.output_object_id    = o.object_id
                                 )
                  ) s
              on (t.modus        = pck_pcu.get_runmode
              and t.content_type = s.content_type
              and t.localisation = s.localisation
              and t.object_id    = s.object_id
                 )
            when matched then update 
               set t.needsprocessing_flag = s.needsprocessing_flag                  
            when not matched then insert 
                 (modus, content_type, localisation, object_id, needsprocessing_flag, needsprocessing_ts, batch_number)
               values 
                 (pck_pcu.get_runmode, s.content_type, s.localisation, s.object_id, s.needsprocessing_flag, sysdate, null)
            </sql:query>
        </sql:execute-query>
    </xsl:copy>
  </xsl:template>
 <!-- -->
  <xsl:template match="trigger-octl">
    <xsl:copy>
      <!-- Set NeedsProcessing_Flag on Output_object when input_object.status not in ('PLACEHOLDER','Deleted')
                and the output_object.status in ('PLACEHOLDER','Deleted')-->
        <xsl:variable name="v_needsprocessing" select="if (@needsProcessing) then @needsProcessing else '1'"/>     
        <sql:execute-query>
            <sql:query name="createControlRecord">
               merge into octl_control t 
               using (select '<xsl:value-of select="@ct"/>' as content_type
                           , '<xsl:value-of select="@l"/>'  as localisation
                           , '<xsl:value-of select="@o"/>'  as object_id
                           , to_number('<xsl:value-of select="$v_needsprocessing"/>') as needsprocessing_flag 
                        from dual
                      ) s
                 on (t.modus        = pck_pcu.get_runmode
                 and t.content_type = s.content_type
                 and t.localisation = s.localisation
                 and t.object_id    = s.object_id
                    )
               when matched then update 
                  set t.needsprocessing_flag = s.needsprocessing_flag                  
               when not matched then insert 
                    (modus, content_type, localisation, object_id, needsprocessing_flag, needsprocessing_ts, batch_number)
                  values 
                    (pck_pcu.get_runmode, s.content_type, s.localisation, s.object_id, s.needsprocessing_flag, sysdate, null)
            </sql:query>
        </sql:execute-query>
    </xsl:copy>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
