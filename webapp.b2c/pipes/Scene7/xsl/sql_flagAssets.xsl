<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">

   <xsl:param name="channel"/>
   <xsl:param name="locale"/>
   
   <!-- Optional object_id to export one particular object's (product, feature, ...) assets -->   
   <xsl:param name="object_id"/>
   
   
   <xsl:variable name="publicationOffset">
      <xsl:choose><xsl:when  test="$channel='FlixMediaAssets'">45</xsl:when><xsl:otherwise>7</xsl:otherwise></xsl:choose>
   </xsl:variable> 

   <xsl:variable name="doctype-channel">
      <xsl:choose>
         <xsl:when test="$channel = 'FlixMediaAssets'">SyndicationL5Assets</xsl:when>
         <xsl:when test="$channel = 'WebcollageAssets'">SyndicationL5Assets</xsl:when>    
         <xsl:when test="$channel = 'AtgAssets' ">ATGAssets</xsl:when>  
         <xsl:otherwise>
            <xsl:value-of select="$channel"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>

   <!-- Below piece of code generates output in format '_FP','A1P','A2P','A3P','A4P','A5P','ABP','APP','AWL',-->
   <xsl:variable name="doctype-list">
    '<xsl:value-of select='string-join(doctypes/doctype[attribute::*[local-name()=$doctype-channel]="yes"]/@code, "&apos;,&apos;")'/>'
   </xsl:variable>

   <xsl:template match="/">
      <root>
         <!-- clear all-->
         <sql:execute-query>
            <sql:query name ='cle-reset-flags'>
            UPDATE CUSTOMER_LOCALE_EXPORT
               set FLAG=0
            where
               CUSTOMER_ID='<xsl:value-of select="$channel"/>'
               and LOCALE='<xsl:value-of select="$locale"/>'
               and FLAG!=0
            </sql:query>
         </sql:execute-query>

         <!-- Add a row for each new AssetList -->
         <sql:execute-query>
            <sql:query name ='cle-insert-new-prd-assets'>
              INSERT INTO CUSTOMER_LOCALE_EXPORT
                  (CUSTOMER_ID, LOCALE, CTN, FLAG, REMARK,LASTTRANSMIT)                
                     (
                     select   
                           '<xsl:value-of select="$channel"/>' as customer_id
                           ,'<xsl:value-of select="$locale"/>' as locale
                           ,a.asset_id
                           ,0
                           ,null 
						   ,to_date('1900-01-01 00:00:00','YYYY-MM-DD HH24:MI:SS')
                     from asset_lists a
                         <xsl:choose>
                           <xsl:when test="$locale != 'master_global'">
                           inner join locale_language ll
                                 on ll.locale = a.locale
                           inner join mv_co_object_id_country co
                                 on co.country = ll.country 
                                 and co.object_id = a.object_id                    
                           </xsl:when>
                           <xsl:otherwise>
                           inner join mv_co_object_id co
                                 on co.object_id=a.object_id
                           </xsl:otherwise>
                         </xsl:choose>
                           and (co.sop-<xsl:value-of select="$publicationOffset"/>) &lt; sysdate
                           and co.eop &gt; sysdate
                           and nvl(co.deleted,0) = 0 
                     where a.locale = '<xsl:value-of select="$locale"/>'
                           and a.product_asset=1
                           
                        <!-- Export to sepcific ctn -->  
                        <xsl:if test="$object_id != ''">
                           and a.object_id = '<xsl:value-of select="$object_id"/>'
                        </xsl:if>
                        <!-- Export to sepcific ctn -->  
                           and a.doctype in (<xsl:value-of select="$doctype-list"/>)
                           and not exists(
                                 select 
                                       1 
                                 from customer_locale_export 
                                 where 
                                       customer_id ='<xsl:value-of select="$channel"/>' 
                                       and locale = '<xsl:value-of select="$locale"/>'  
                                       and a.asset_id = ctn
                                 <xsl:choose>            
                                    <xsl:when test="$object_id != ''">
                                       and ctn like '<xsl:value-of select="$object_id"/>|%'
                                    </xsl:when>
                                    <xsl:otherwise>
                                       and ctn like '%|%'
                                    </xsl:otherwise>
                                 </xsl:choose>
                                       )
                     )
            </sql:query>
         </sql:execute-query> 

         <sql:execute-query>
            <sql:query name ='cle-insert-new-obj-assets'>
              INSERT INTO CUSTOMER_LOCALE_EXPORT(CUSTOMER_ID, LOCALE, CTN, FLAG, REMARK,LASTTRANSMIT)                
                  (
                   select   
                        '<xsl:value-of select="$channel"/>' as customer_id
                        ,'<xsl:value-of select="$locale"/>' as locale
                        ,a.asset_id
                        ,0
                        ,null
						,to_date('1900-01-01 00:00:00','YYYY-MM-DD HH24:MI:SS')	
                  from asset_lists a
                  
                  where a.locale = '<xsl:value-of select="$locale"/>'                    
                        and a.product_asset=0
                        and a.deleted=0                    
                     <!-- Export to sepcific ctn -->  
                     <xsl:if test="$object_id != ''">
                        and a.object_id = '<xsl:value-of select="$object_id"/>'
                     </xsl:if>
                        and a.doctype in (<xsl:value-of select="$doctype-list"/>)                       
                   
                        and not exists
                           (
                           select 
                              1                           
                           from customer_locale_export cle
                           
                           where cle.locale= '<xsl:value-of select="$locale"/>'
                           and cle.customer_id = '<xsl:value-of select="$channel"/>' 
                           and cle.ctn=a.asset_id

                         <xsl:if test="$object_id != ''">
                           <!-- Export to sepcific ctn -->  
                           and ctn like '<xsl:value-of select="$object_id"/>|%'
                         </xsl:if>                           
                           )
                        )
            </sql:query>
         </sql:execute-query> 

         <!-- Set flag to 1 if the MD5 was modified after the last export.
           MD5 of the last export is stored in the CLE.remark column. 
      -->
         <sql:execute-query>
            <sql:query isstoredprocedure="true" name="cle-set-flags">
      DECLARE 

         v_locale              VARCHAR2(20)   := '<xsl:value-of select="$locale"/>';
         v_channel             VARCHAR2(100)  := '<xsl:value-of select="$channel"/>';
         n_allowedSize         NUMBER := 24000;  -- this variable is used to restrict the total size of the exported assets
         n_actualSize          NUMBER := 0;

               <!-- Cursor ASSET_LIST start -->
            CURSOR ASSET_LIST IS
            select 
                  distinct al.asset_id
            from 
                  asset_lists al
         <xsl:choose>
           <xsl:when test="$locale != 'master_global'">
            inner join locale_language ll
                  on ll.locale = al.locale
            inner join mv_co_object_id_country co
                  on co.country = ll.country 
                  and co.object_id = al.object_id                    
           </xsl:when>
           <xsl:otherwise>
            inner join mv_co_object_id co
                  on co.object_id=al.object_id
           </xsl:otherwise>
         </xsl:choose>
               and (co.sop-<xsl:value-of select="$publicationOffset"/>) &lt; sysdate
                  and co.eop &gt; sysdate
                  and nvl(co.deleted,0) = 0
               <!-- CLE.ctn is a combination of asset id and doc type, e.g. 32PFL3405H_12|RTP -->
            inner join customer_locale_export cle
                  on cle.ctn = al.asset_id
                  and cle.locale = al.locale
                  <xsl:choose>            
                  <xsl:when test="$object_id != ''">
                              and cle.ctn like '<xsl:value-of select="$object_id"/>|%'
                  </xsl:when>
                  <xsl:otherwise>
                             and cle.ctn like '%|%'
                  </xsl:otherwise>
                  </xsl:choose>
               <!-- flag if md5 has a value and it is different than the last sent md5
                    or if md5 is empty and the lastmodified timestamp is newer -->
                  where (
                        (
                           al.md5 is not null and nvl(cle.remark, 'null') != al.md5
                        ) 
                  or    (  al.md5 is null and al.lastmodified > cle.lasttransmit
                        )
                      )
                  and al.doctype in (<xsl:value-of select="$doctype-list"/>)
                  and al.locale = '<xsl:value-of select="$locale"/>'
                  
                  
            ;
            <!-- Cursor ASSET_LIST end -->
            <!-- Cursor OBJECTASSET_LIST start -->
            CURSOR OBJECTASSET_LIST IS
                     select 
                        distinct cle.ctn
                     from                  customer_locale_export cle 
                     inner join asset_lists al 
                        on al.asset_id = cle.ctn 
                        and al.locale = '<xsl:value-of select="$locale"/>'                  
                        and  
                           (  
                              (
                              al.md5 is not null and nvl(cle.remark, 'null') != al.md5
                              )
                              or 
                              (
                              al.md5 is null and al.lastmodified > cle.lasttransmit 
                              )
                           )            

                        and al.doctype in (<xsl:value-of select="$doctype-list"/>) 
                     where  cle.customer_id = '<xsl:value-of select="$channel"/>'
                        <xsl:choose>            
                           <xsl:when test="$object_id != ''">
                              and cle.ctn like '<xsl:value-of select="$object_id"/>|%'
                           </xsl:when>
                           <xsl:otherwise>
                              and cle.ctn like '%|%'
                           </xsl:otherwise>
                        </xsl:choose>
                        and cle.locale = '<xsl:value-of select="$locale"/>'
                  
             ;   
         <!-- Cursor OBJECTASSET_LIST end -->


            begin
               for r in ASSET_LIST() 
                  loop
         <!--dbms_output.put_line('CursorASSET_LIST: o='||r.ctn||', l='||v_locale||', dt='||v_doctype_list||', cha='||v_channel||'.');-->
                     UPDATE CUSTOMER_LOCALE_EXPORT cle
                           set FLAG=1
                     where 
                           customer_id = v_channel
                           and locale = v_locale
                           and ctn = r.asset_id
                     ;
                  end loop;

               for objlist in OBJECTASSET_LIST()
               loop
         <!--dbms_output.put_line('CursorOBJECTASSET_LIST: o='||r.ctn||', l='||v_locale||', dt='||v_doctype_list||', cha='||v_channel||'.');-->
                     UPDATE CUSTOMER_LOCALE_EXPORT cle
                           set FLAG=1
                     where 
                           customer_id = v_channel
                           and locale = v_locale 
                           and ctn = objlist.ctn;
               end loop;
            end;
      </sql:query>
   </sql:execute-query>
</root>
</xsl:template>

</xsl:stylesheet>