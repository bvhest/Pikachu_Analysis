<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
				xmlns:dir="http://apache.org/cocoon/directory/2.0" 
				xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="runmode" select="''"/>
  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:param name="batchsize"/>
  <xsl:param name="reload"/>    
  <xsl:param name="run_id"/>
  <xsl:param name="schedule_id"/>
  <xsl:param name="translation_filter"/>
 
	<xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
	<xsl:variable name="runmodus" select="if ($run_id != '') then 'BATCH' else 'MANUAL'" />
		
  <xsl:template match="/">
    <root>
      <sql:execute-query>
        <sql:query isstoredprocedure="true">
         declare
            cursor c1( cp_modus in varchar2
                     , cp_ct in varchar2
                     , cp_l in varchar2
                     ) 
            is
               select cp_modus as modus
                    , o.content_type
                    , o.localisation
                    , o.object_id
               from octl o
             <xsl:if test="not($reload='true')">
               inner join octl_control oc
                  on oc.content_type = o.content_type
                 and oc.localisation = o.localisation
                 and oc.object_id    = o.object_id
                 and oc.modus        = cp_modus
             </xsl:if> 
               where o.content_type  = cp_ct
                 and o.localisation  = cp_l
         <xsl:choose>
           <xsl:when test="not($reload='true')">
                 and oc.needsprocessing_flag = 1
               <xsl:if test="$ct != 'PCT'">
                 and o.endofprocessing &gt;= trunc(sysdate)  
               </xsl:if>
                 and o.active_flag = 1
           </xsl:when>
           <xsl:otherwise>
                 and o.status != 'PLACEHOLDER'
           </xsl:otherwise>                
         </xsl:choose>              
            <!-- Do not batch care catalog for spot -->
         <xsl:if test="$ct='Catalog2SPOT'">
	              and not o.object_id like 'CARE%'
         </xsl:if>            
               order by o.masterlastmodified_ts desc
         ;
                  
         i              pls_integer            := 0;
         batch_size     pls_integer            := <xsl:value-of select="$batchsize"/>;
         v_ct           octl.content_type%type := '<xsl:value-of select="$ct"/>';
         v_l            octl.localisation%type := '<xsl:value-of select="$l"/>';      
         v_intro_str    varchar2(10)			  := 'MANUAL_';
         v_date_format  varchar2(20)			  := 'yyyymmdd_hh24miss';
         v_schedule_id  varchar2(20)  		     := '<xsl:value-of select="$schedule_id"/>';
         v_modus        varchar2(20)  		     := '<xsl:value-of select="$modus"/>';
         v_runmodus     varchar2(20)  		     := '<xsl:value-of select="$runmodus"/>';
         v_msg          varchar2(4000);
         
         v_import_ts    varchar2(20);
         v_status_flag  varchar2(5) := 'OK';
      
         CURSOR L1
          IS
         SELECT LOCALE FROM LOCALE_LANGUAGE WHERE COUNTRY = SUBSTR('<xsl:value-of select="$l"/>',8);
         			
         begin      
            for r1 in c1(v_modus, v_ct, v_l)
            loop
              <xsl:if test="$ct = 'PMT_Localised' and $translation_filter ='yes'">
				for r2 in l1
				loop
				  begin				  	  	                   
					  select nvl(to_char(import_ts,'dd/mm/yy'), 'NULL') 
					    into v_import_ts
					    from (select import_ts from octl_translations ot
					                 inner join octl o
	                                  on o.object_id = ot.object_id
                                     and o.localisation = ot.localisation
                                     and o.content_type = ot.content_type
					                 inner join octl o2
	                                  on o.object_id = o2.object_id
                                     and o2.localisation = v_l
                                   where ot.content_type = 'PMT_Translated' 
                                     and ot.localisation = r2.locale 
                                     and ot.object_id    = r1.object_id
                                     and ot.workflow     = 'CL_CMC'
                                     and o2.content_type = 'PMT_Localised'
                                     and o2.status       != 'PLACEHOLDER'     
					                order by ot.lastmodified_ts desc
					           ) where rownum = 1;
					/*            
					 * New products will fall under No Data Found exception
					 */  
                    exception
	                    when no_data_found 
	                    then
	                      v_status_flag := 'OK';   
                    end;                  
					  /*
					   * v_import_ts - null means the product is send to SDL and 
					   * waiting for translated result. To avoid duplicate translation
					   * request we are avoiding these products 
					   */
					  if v_import_ts = 'NULL' 
					  then
					      v_status_flag := 'NOK';
					  else
					      v_status_flag := 'OK';
					  end if; 
					  
					  
				end loop;
              </xsl:if>
 
              IF v_status_flag = 'OK' THEN
                 i := i+1;
	               update octl_control 
	                  set batch_number       = ceil(i/batch_size)
	                    , intransaction_flag = 1
	                where modus        = r1.modus
	                  and content_type = r1.content_type
	                  and localisation = r1.localisation
	                  and object_id    = r1.object_id;
              END IF;
               
            end loop; 
			
            -- Volumn in update query 
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
         end;
        </sql:query>
      </sql:execute-query>
    </root>
</xsl:template>
</xsl:stylesheet>