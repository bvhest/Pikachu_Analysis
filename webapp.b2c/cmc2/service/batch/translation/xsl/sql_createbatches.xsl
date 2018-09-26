<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:sql="http://apache.org/cocoon/SQL/2.0"
        xmlns:cinclude="http://apache.org/cocoon/include/1.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="batchsize"/>
  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:param name="category"/>
  <!-- $locale and $ctn will have a value only in the case of a PMT_Translated Priority Translation request -->
  <xsl:param name="locale"/>
  <xsl:param name="ctn"/>
  <!-- $catalogfilename and $catalogfiledir will have a value only in the case of a PMT_Translated catalog.xml request (i.e. to export only ctns in the catalog.xml file) -->
  <xsl:param name="runcatalogexport"/>
  <xsl:param name="workflow"/>
  <xsl:param name="phase2"/>
  <xsl:param name="timestamp"/>
  <xsl:param name="run_id"/>
  <xsl:param name="runmode"/>
  <xsl:param name="schedule_id"/>
  <!-- -->
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  <xsl:variable name="runmodus" select="if ($run_id != '') then 'BATCH' else 'MANUAL'" />
  <!-- -->
  <xsl:variable name="objecttype">
    <xsl:choose>
      <xsl:when test="$ct='PMT_Translated'">Product</xsl:when>
      <xsl:when test="$ct='Categorization_Translated'">Categorization</xsl:when>
      <xsl:when test="$ct='RangeText_Translated'">RangeText</xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="v_needsprocessing" select="if ($phase2 = 'yes') then '(3)' else if ($workflow = 'CL_CMC') then '(1,4)' else '(1)'"/>
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:choose>
      <xsl:when test="$ct='PMT_Translated'">
      <xsl:choose>
        <xsl:when test="$locale and $ctn">
          <sql:execute-query>
            <sql:query name="sql_create_batches: PMT_Translated for Locale and Ctn">
              <!-- If ctn and locale have a value, then this is a priority translation request -->
              update octl_control o 
                 set o.needsprocessing_flag = 1
                   , o.intransaction_flag   = 1
                   , o.batch_number         = 1
               where o.modus        = '<xsl:value-of select="$modus"/>'
                 and o.content_type = '<xsl:value-of select="$ct"/>'
                 and o.object_id    = '<xsl:value-of select="$ctn"/>'
                 and o.localisation in (select locale 
                                          from locale_language 
                                         where country = substr('<xsl:value-of select="$locale"/>',4,2)
                                       )
                 and exists (select 1 
                               from octl
                              where content_type = 'PMT_Localised'
                                and localisation = 'master_' || substr(o.localisation,4,2)
                                and object_id    = o.object_id
                                and status       = 'Final Published'
                            )
                 and exists (select 1
                               from catalog_objects cobj
                              where cobj.object_id      = o.object_id
                                and cobj.country        = substr(o.localisation,4,2)
                                and nvl(cobj.deleted,0) = 0
                                and cobj.customer_id   != 'CARE'
                               )
                 and sysdate &lt; (select cobj.eop
                                     from mv_co_object_id cobj
                                    where cobj.object_id  = o.object_id
                                      and cobj.deleted    = 0
                                  )
            </sql:query>
          </sql:execute-query>
        </xsl:when>
        <xsl:otherwise>
          <!-- Standard PMT_Translated export run -->
            <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
              <sql:query isstoredprocedure="true"  name="sql_create_batches: Standard PMT_Translated export run">
                declare
                  cursor c1( p_modus         IN octl_control.modus%TYPE
                           , p_content_type  IN octl.content_type%TYPE
                           , p_localisation  IN locale_language.languagecode%TYPE
                           , p_category      IN categorization.categorycode%TYPE
                           , p_object_type   IN object_master_data.object_type%TYPE
                           )
                  is
                     -- select localised products
                     select DISTINCT t.object_id 
                           , t.localisation 
                        from octl t
                       -- select triggered products from process control table:
                       inner join octl_control ocl
                          on ocl.content_type      = t.content_type
                         and ocl.localisation      = t.localisation 
                         and ocl.object_id         = t.object_id 
                         and ocl.modus             = p_modus
                       -- check that product is assigned to a (sub)category (as this is used to group the translation requests for a given locale).
                       inner join categorization c 
                          on c.categorycode     = p_category
                       inner join vw_object_categorization oc                     
                          on oc.object_id       = t.object_id
                         and oc.subcategory     = c.subcategorycode
                         and oc.catalogcode     = c.catalogcode
                       inner join locale_language ll
                          on ll.locale          = t.localisation
                         and ll.languagecode    = p_localisation    
                       -- check that source for translation has status 'Final Published':                         
                       inner join octl l
                          on l.object_id        = t.object_id
                         and l.content_type     = 'PMT_Localised'
                         and l.localisation     = 'master_'||substr(t.localisation,4,2)
                         and l.status           = 'Final Published'                        
                       -- product must be active in at least one country for a non-CARE catalog:
                       inner join mv_co_object_id mvco 
                          on mvco.object_id     = ocl.object_id
                         and mvco.deleted       = 0
                         and mvco.eop        &gt; trunc(sysdate)
                       -- product must be active in the specified country for a non-CARE catalog:
                       inner join mv_co_object_id_country mvco2 
                          on mvco2.object_id    = ocl.object_id
                         and mvco2.country      = substr(t.localisation,4,2)
                         and mvco2.deleted      = 0
                         and mvco2.eop       &gt; trunc(sysdate)
                       inner join language_translations lt
                          on lt.locale          = ll.locale
                         and lt.enabled         = 1
                         and lt.isdirect        = 0 -- numeric value, so don't convert into char...
                       -- check ???
                       inner join object_master_data omd
                          on omd.object_id      = t.object_id
                         and omd.object_type    = p_object_type
                         and omd.division       = lt.division
                       -- select the active non-localised PMT_Translated records.
                       where c.catalogcode      = 'MASTER'
                         and t.content_type          = p_content_type
                         and ocl.needsprocessing_flag in <xsl:value-of select="$v_needsprocessing"/>
                         and t.islocalized           = 1
                         and t.active_flag           = 1                                       
                    union
                     -- select non-localised products
                       select t.object_id
                            , min(t.localisation) as localisation
                         from categorization c 
                        inner join vw_object_categorization oc                     
                           on oc.subcategory    = c.subcategorycode
                          and oc.catalogcode    = 'MASTER'
                        inner join octl t
                           on t.object_id         = oc.object_id
                          and t.content_type      = p_content_type
                          and nvl(t.islocalized,0) = 0
                        inner join octl_control ocl
                           on ocl.content_type      = t.content_type
                          and ocl.localisation      = t.localisation 
                          and ocl.object_id         = t.object_id 
                          and ocl.modus             = p_modus
                        inner join locale_language ll
                           on ll.locale          = t.localisation
                          and ll.languagecode    = p_localisation                           
                        inner join octl l
                           on l.object_id        = t.object_id
                          and l.content_type     = 'PMT_Localised'
                          and l.localisation     = 'master_'||ll.country_code
                          and l.status           = 'Final Published'                                                
                       -- product must be active in at least one country:
                       inner join mv_co_object_id mvco 
                          on mvco.object_id       = ocl.object_id
                         and mvco.deleted         = 0
                         and mvco.eop          &gt; trunc(sysdate)
                       -- product must be active in the specified country:
                       inner join mv_co_object_id_country mvco2 
                          on mvco2.object_id    = ocl.object_id
                         and mvco2.country      = ll.country_code
                         and mvco2.deleted      = 0
<!-- 2010/july/29: Exception for the AVENT-products: only send out active (eop > sysdate) products out for translation. -->
<xsl:if test="$l='he_IL'">               
                          and mvco2.eop      &gt; sysdate
</xsl:if>               
                        inner join language_translations lt
                           on ll.locale   = lt.locale                        
                          and lt.enabled  = 1
                          and lt.isdirect = 0 -- numeric value, so don't convert into char...
                        inner join object_master_data omd
                           on omd.division    = lt.division
                          and omd.object_id   = t.object_id
                          and omd.object_type = p_object_type 
                        where c.catalogcode     = 'MASTER'                              
                          and c.categorycode    = p_category
                          and ocl.needsprocessing_flag in <xsl:value-of select="$v_needsprocessing"/>
                        group by t.object_id
                  ;

                  i                       pls_integer :=0 ;
                  batch_size              pls_integer                            := <xsl:value-of select="$batchsize"/>;
                  v_modus                 octl_control.modus%TYPE                := '<xsl:value-of select="$modus"/>';
                  v_content_type          octl_control.content_type%TYPE         := '<xsl:value-of select="$ct"/>';
                  v_localisation          octl_control.localisation%TYPE         := '<xsl:value-of select="$l"/>';
                  v_category              categorization.categorycode%TYPE       := '<xsl:value-of select="$category"/>';
                  v_object_type           object_master_data.object_type%TYPE    := '<xsl:value-of select="$objecttype"/>';
                  v_intro_str             varchar2(10)                           := 'MANUAL_';
                  v_date_format           varchar2(20)                           := 'YYYYMMDD_HH24MISS';
                  v_schedule_id           varchar2(20)                           := '<xsl:value-of select="$schedule_id"/>';
                  v_runmodus              varchar2(20)                           := '<xsl:value-of select="$runmodus"/>';
                  v_msg                   varchar2(4000);

                begin

                  -- set intransaction_flag, batch_number
                  for r in c1( v_modus
                             , v_content_type
                             , v_localisation
                             , v_category
                             , v_object_type
                             )
                  loop
                     -- dbms_output.put_line('Cursor2: o='||r.object_id||', ct='||v_content_type||', l='||r.localisation||', cat='||v_category||'.');
                     i := i+1;
                     update octl_control
                        set intransaction_flag = 1
                          , batch_number = ceil(i/batch_size) 
                      where modus             = v_modus
                        and content_type      = v_content_type
                        and localisation      = r.localisation 
                        and object_id         = r.object_id 
                     ;
                  end loop;

                  -- Volumn in update query 
                  begin
                  
                     update pcu_process_logging 
                        set object_count_in = object_count_in + i 
                      where modus        = v_runmodus               
                        and process_name = v_content_type
                  <xsl:choose>
                     <xsl:when test="$run_id = ''">                           
                        and run_schedule = (select  v_intro_str||to_char(startexec, v_date_format)
                                             from vw_content_type_schedule
                                            where content_type = v_content_type 
                                              and id           = v_schedule_id
                                           )             
                     </xsl:when>
                     <xsl:otherwise>
                        and run_schedule = '<xsl:value-of select="$run_id"/>'
                     </xsl:otherwise>
                  </xsl:choose>
                  ;
                  
                  exception
                     when others then 
                        v_msg := substr(sqlerrm,1,4000);
                        dbms_output.put_line('Error :'||v_msg);
                        insert into pcu_error_logging
                           (modus, process_name, ts_start, ts_error, run_schedule, message)
                        values
                           (v_modus, v_content_type, sysdate, sysdate, '', v_msg)
                        ;
                  end;
                  
               end;
              </sql:query>
            </sql:execute-query>
        </xsl:otherwise>
      </xsl:choose>
      </xsl:when>

      <xsl:when test="$ct='RangeText_Translated'">
          <!-- Standard export run -->
            <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
              <sql:query isstoredprocedure="true"  name="sql_create_batches: RangeText_Translated">
                declare
                  cursor c1( p_modus         IN octl_control.modus%TYPE
                           , p_content_type  IN octl_control.content_type%TYPE
                           , p_localisation  IN locale_language.languagecode%TYPE
                           ) 
                  is
                    select o.object_id
                         , o.localisation
                    from (select a.object_id
                               , a.masterlastmodified_ts
                               , a.localisation
                            from octl a
                           inner join octl_control ocl
                              on ocl.content_type      = a.content_type
                             and ocl.localisation      = a.localisation 
                             and ocl.object_id         = a.object_id 
                             and ocl.modus             = p_modus
                             and ocl.needsprocessing_flag = 1
                           inner join locale_language ll
                              on ll.locale               = a.localisation
                           inner join language_translations lt
                              on lt.locale               = ll.locale
                             and lt.division             = 'CE' -- assume CE
                           where a.content_type          = p_content_type
                             and ll.languagecode         = p_localisation
   <!--  Use of SOP to determine export disabled until confirmation received that LCB is no longer sending SOPs way into the future for packaging products
                             and a.startofprocessing &lt;= trunc(sysdate)
   -->
                             and a.endofprocessing   &gt;= trunc(sysdate)
                             and a.active_flag           = 1
                             and lt.enabled              = 1
                             and lt.isdirect             = 0
                             and exists (select 1 
                                           from octl
                                          where content_type = 'RangeText_Localized'
                                            and localisation = 'master_'||substr(a.localisation,4,2)
                                            and object_id    = a.object_id
                                          -- ? and status = 'Final Published'
                                        )
                         ) o
                    order by o.masterlastmodified_ts desc
                  ;

                  cursor c2( p_modus         IN octl_control.modus%TYPE
                           , p_content_type  IN octl_control.content_type%TYPE
                           , p_localisation  IN locale_language.languagecode%TYPE
                           ) 
                  is
                   (select masterlastmodified_ts
                         , object_id
                         , localisation
                      from (select a.masterlastmodified_ts  
                                 , a.object_id 
                                 , a.localisation 
                              from octl a
                             inner join octl_control oc
                                on oc.content_type       = a.content_type
                               and oc.localisation       = a.localisation 
                               and oc.object_id          = a.object_id 
                               and oc.modus              = p_modus
                               and oc.needsprocessing_flag = 1
                               and oc.intransaction_flag = 1
                             inner join locale_language ll
                                on ll.locale             = a.localisation
                             inner join language_translations lt
                                on ll.locale             = lt.locale
                               and lt.division           = 'CE' -- assume CE
                             where a.content_type        = p_content_type
                               and ll.languagecode       = p_localisation
                               and lt.enabled            = 1
                               and lt.isdirect           = 0
                          <!--  Use of SOP to determine export disabled until confirmation received that LCB is no longer sending SOPs way into the future for packaging products
                               and a.startofprocessing &lt;= trunc(sysdate)
                          -->
                               and a.endofprocessing &gt;= trunc(sysdate)
                               and a.active_flag = 1
                               and a.islocalized = 1
                               and exists (select 1 
                                             from octl
                                            where content_type = 'RangeText_Localized'
                                              and localisation = 'master_'||substr(a.localisation,4,2)
                                              and object_id = a.object_id
                                              -- ? and status = 'Final Published'
                                          )
                              )
                   )
                   union
                   (select o.masterlastmodified_ts
                         , o.object_id
                         , o.localisation
                      from octl o
                     inner join (select a.object_id
                                      , min(a.localisation) as localisation
                                      , min(a.content_type) as content_type
                                 from octl a
                                inner join octl_control oc
                                   on oc.content_type      = a.content_type
                                  and oc.localisation      = a.localisation 
                                  and oc.object_id         = a.object_id 
                                  and oc.modus             = p_modus
                                  and oc.needsprocessing_flag = 1
                                  and oc.intransaction_flag= 1
                                 inner join locale_language ll
                                    on ll.locale   = a.localisation
                                 inner join language_translations lt
                                    on lt.locale   = ll.locale
                                   and lt.division = 'CE' -- assume CE, but why?
                                 where a.content_type = p_content_type
                                   and ll.languagecode = p_localisation
                                   and lt.enabled = 1
                                   and lt.isdirect = 0
                             <!--  Use of SOP to determine export disabled until confirmation received that LCB is no longer sending SOPs way into the future for packaging products
                                   and a.startofprocessing &lt;= trunc(sysdate)
                             -->
                                   and a.endofprocessing &gt;= trunc(sysdate)
                                   and a.active_flag = 1
                                   and nvl(a.islocalized,0) = 0
                                   and exists (select 1 
                                                 from octl
                                                where content_type = 'RangeText_Localized'
                                                  and localisation = 'master_'||substr(a.localisation,4,2)
                                                  and object_id    = a.object_id
                                                -- ? and status = 'Final Published'
                                               )
                                 group by a.object_id
                                ) x
                        on x.object_id    = o.object_id 
                       and x.localisation = o.localisation 
                       and x.content_type = o.content_type
                   )
                   order by masterlastmodified_ts desc
                  ;

                  i                PLS_INTEGER := 0 ;
                  -- use a batchsize of 1 for range because the routing code for the file will be derived from the first referenced product in the range.
                  v_batch_size     PLS_INTEGER := 1;
                  v_modus          octl_control.modus%TYPE          := '<xsl:value-of select="$modus"/>';
                  v_content_type   octl_control.content_type%TYPE   := '<xsl:value-of select="$ct"/>';
                  v_localisation   octl_control.localisation%TYPE   := '<xsl:value-of select="$l"/>';
                  v_intro_str      varchar2(10)                     := 'MANUAL_';
                  v_date_format    varchar2(20)                     := 'YYYYMMDD_HH24MISS';
                  v_schedule_id    varchar2(20)                     := '<xsl:value-of select="$schedule_id"/>';
                  v_runmodus       varchar2(20)                     := '<xsl:value-of select="$runmodus"/>';
                  v_msg            varchar2(4000);

                begin
                  -- set intransaction_flag to 1 for all candidate rows regardless whether it will be selected for export or isLocalized is 1 or 0.
                  for r in c1( v_modus
                             , v_content_type
                             , v_localisation
                             )
                  loop
                     -- dbms_output.put_line('Cursor1: o='||r.object_id||', ct='||v_content_type||', l='||v_localisation||'.');
                     update octl_control
                        set intransaction_flag = 1
                          , batch_number       = null 
                      where modus             = v_modus
                        and content_type      = v_content_type
                        and localisation      = r.localisation 
                        and object_id         = r.object_id 
                     ;
                  end loop;

                  -- set batch_number only for those objects that will be used to create the export xml.
                  for r in c2( v_modus
                             , v_content_type
                             , v_localisation
                             )
                  loop
                     -- dbms_output.put_line('Cursor2: o='||r.object_id||', ct='||v_content_type||', l='||v_localisation||'.');
                     i := i+1;
                     update octl_control 
                        set batch_number = ceil(i/v_batch_size) 
                      where modus             = v_modus
                        and content_type      = v_content_type
                        and localisation      = r.localisation 
                        and object_id         = r.object_id 
                     ;
                  end loop;

                  -- Volumn in update query 
                  begin
                  
                     update pcu_process_logging 
                        set object_count_in = object_count_in + i 
                      where modus        = v_runmodus               
                        and process_name = v_content_type
                  <xsl:choose>
                     <xsl:when test="$run_id = ''">                           
                        and run_schedule = (select  v_intro_str||to_char(startexec, v_date_format)
                                             from vw_content_type_schedule
                                            where content_type = v_content_type 
                                              and id           = v_schedule_id
                                           )             
                     </xsl:when>
                     <xsl:otherwise>
                        and run_schedule = '<xsl:value-of select="$run_id"/>'
                     </xsl:otherwise>
                  </xsl:choose>
                  ;
                  
                  exception
                     when others then 
                        v_msg := substr(sqlerrm,1,4000);
                        dbms_output.put_line('Error :'||v_msg);
                        insert into pcu_error_logging
                           (modus, process_name, ts_start, ts_error, run_schedule, message)
                        values
                           (v_modus, v_content_type, sysdate, sysdate, '', v_msg)
                        ;
                  end;

               end;
              </sql:query>
            </sql:execute-query>
      </xsl:when>
      </xsl:choose>
    </root>
  </xsl:template>
</xsl:stylesheet>
