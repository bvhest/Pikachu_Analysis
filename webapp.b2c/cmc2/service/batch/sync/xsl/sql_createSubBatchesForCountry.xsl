<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                >
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="batchsize"/>
  <xsl:param name="ct"/>
  <xsl:param name="country"/>
  <xsl:param name="reload"/>  
  <xsl:param name="schedule_id"/>
  <xsl:param name="run_id"/>  
  <xsl:param name="runmode"/>  
  
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  <xsl:variable name="runmodus" select="if ($run_id != '') then 'BATCH' else 'MANUAL'" />
  
  <xsl:variable name="objecttype">
    <xsl:choose>
      <xsl:when test="$ct='PMT'">Product</xsl:when>
    </xsl:choose>
  </xsl:variable>
  <!-- -->
  <xsl:template match="/">
      <xsl:choose>
        <xsl:when test="$ct='PMT'">
          <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
            <sql:query isstoredprocedure="true">
               declare
                  cursor c1
                  ( cp_modus   IN VARCHAR2
                  , cp_ct      IN VARCHAR2
                  , cp_country IN VARCHAR2
                  ) is
                     select o.octl_rowid octl_rowid
                           ,o.object_id
                           ,o.localisation
                           ,(rownum + mod(rownum,2))/2 row_num
                      from  (select oc.rowid octl_rowid
                                  , oc.object_id
                                  , oc.localisation
                               from octl_control oc
                              inner join locale_language ll
                                 on ll.locale        = oc.localisation
							  inner join mv_co_object_id mvco
								on mvco.object_id = oc.object_id
								and mvco.deleted=0
								and mvco.eop>trunc(sysdate) 
                              -- sync only active ctls (e.g. not PMT/ms_MY, PMT/es_US)-->
                              inner join ctl
                                 on ctl.localisation = oc.localisation
                                and ctl.content_type = oc.content_type
                                and ctl.sync_code    = 1
                              where oc.modus         = cp_modus
                                and oc.content_type  = cp_ct
                                and ll.country       = cp_country
                             <xsl:if test="not($reload='true')">
                                and oc.needsprocessing_flag = 1
                             </xsl:if>
                              order by object_id
                            ) o
                  ;
     
             
                  i            	   PLS_INTEGER 					:= 0;
                  batch_size   	   PLS_INTEGER 					:= <xsl:value-of select="$batchsize"/>;
                  v_ct         	   octl.content_type%type 		:= '<xsl:value-of select="$ct"/>';
                  v_country    	   locale_language.country%type := '<xsl:value-of select="$country"/>';
                  v_intro_str  	   varchar2(10)					:= 'MANUAL_';
                  v_date_format     varchar2(20)					:= 'yyyymmdd_hh24miss';
                  v_schedule_id     varchar2(20)  				   := '<xsl:value-of select="$schedule_id"/>';
                  v_modus           varchar2(20)  		         := '<xsl:value-of select="$modus"/>';
                  v_runmodus        varchar2(20)  		         := '<xsl:value-of select="$runmodus"/>';
                  v_msg             varchar2(4000);
				  
               begin
                  update octl_control
                     set batch_number       = NULL
                       , intransaction_flag = 0
                   where content_type = '<xsl:value-of select="$ct"/>'
                     and localisation in (select locale from locale_language where country = '<xsl:value-of select="$country"/>')
                     and batch_number IS NOT NULL
                  ;
                  
                  for r in c1(v_modus, v_ct, v_country)
                  loop
                     --dbms_output.put_line('C1: ' || r.object_id || '-' || r.localisation || '-' || v_ct || '-' || v_country || '-' || r.row_num || '-' || ceil(r.row_num/batch_size) || '-');
                     i := i+1;

                     update octl_control
                        set batch_number       = ceil(r.row_num/batch_size) 
                          , intransaction_flag = 1
                      where modus        = v_modus
                        and content_type = v_ct
                        and localisation = r.localisation
                        and object_id    = r.object_id
                     ;                       
                  end loop;

                  begin
                  
                     update pcu_process_logging 
                        set object_count_in = object_count_in + i 
                      where modus        = v_runmodus               
                        and process_name = v_ct
                  <xsl:choose>
                     <xsl:when test="$run_id = ''">									
                        and run_schedule = (select  v_intro_str||to_char(startexec, v_date_format)
                                             from vw_content_type_schedule
                                            where content_type = v_ct 
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
                           (v_modus, v_ct, sysdate, sysdate, '', v_msg)
                        ;
                  end;
                  -- End of update query
               end;
            </sql:query>
          </sql:execute-query>
        </xsl:when>
      </xsl:choose>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
