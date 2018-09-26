<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  
  <xsl:variable name="publicationOffset" select="if ($channel='FlixMediaAssets') then '45' else '7'"/>
  
  <xsl:variable name="doctype-channel">
    <xsl:choose>
      <xsl:when test="$channel = 'FlixMediaAssets'">SyndicationL5Assets</xsl:when>
      <xsl:when test="$channel = 'WebcollageAssets'">SyndicationL5Assets</xsl:when>    
      <xsl:when test="$channel = 'AtgAssets' ">ATGAssets</xsl:when>  
      <xsl:otherwise><xsl:value-of select="$channel"/></xsl:otherwise>
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
          and FLAG=1
        </sql:query>
      </sql:execute-query>
      
      <!-- Add a row for each new AssetList -->
      <sql:execute-query>
        <sql:query name ='cle-insert-new-prd-assets'>
              INSERT INTO CUSTOMER_LOCALE_EXPORT(CUSTOMER_ID, LOCALE, CTN, FLAG, REMARK)
                select 
                  '<xsl:value-of select="$channel"/>',
                  '<xsl:value-of select="$locale"/>',
                  al.asset_id,
                  0, null 
                from asset_lists al
                where (al.asset_id, locale) in
                (
                  select a.asset_id, a.locale 
                  from asset_lists a
                  
                  inner join locale_language ll
                     on ll.locale = '<xsl:value-of select="$locale"/>'
                  
                  inner join mv_co_object_id_country co
                     on co.country = ll.country 
                    and co.object_id = a.object_id
                    
                  where locale = '<xsl:value-of select="$locale"/>'
                    --and nvl(a.md5, 'null') != 'null'
                    and a.product_asset=1
                    and (co.sop-to_number('<xsl:value-of select="$publicationOffset"/>')) &lt; sysdate
                    and co.eop &gt; sysdate
                    and nvl(co.deleted,0) = 0 ;
                    
                  minus
                  
                  select ctn,locale 
                  from customer_locale_export 
                  where customer_id ='<xsl:value-of select="$channel"/>' 
                    and locale = '<xsl:value-of select="$locale"/>'
                )
        </sql:query>
      </sql:execute-query> 
      
      <sql:execute-query>
        <sql:query name ='cle-insert-new-obj-assets'>
              INSERT INTO CUSTOMER_LOCALE_EXPORT(CUSTOMER_ID, LOCALE, CTN, FLAG, REMARK)
                select 
                  '<xsl:value-of select="$channel"/>',
                  '<xsl:value-of select="$locale"/>',
                  al.asset_id,
                  0, null
                from asset_lists al
                where (al.asset_id, al.locale) in
                (
                  select a.asset_id, a.locale 
                  from asset_lists a
                  where a.locale = '<xsl:value-of select="$locale"/>'
                    --and nvl(a.md5, 'null') != 'null'
                    and a.product_asset=0
                    and a.deleted=0
                    
                  minus
                  
                  select ctn,locale 
                  from customer_locale_export 
                  where customer_id ='<xsl:value-of select="$channel"/>' 
                    and locale = '<xsl:value-of select="$locale"/>'
                )
        </sql:query>
      </sql:execute-query> 

      <!-- Set flag to 1 if the MD5 was modified after the last export.
           MD5 of the last export is stored in the CLE.remark column. 
      -->
      <sql:execute-query>
        <sql:query isstoredprocedure="true" name="cle-set-flags">
      DECLARE 
        CURSOR ASSET_LIST(p_locale IN VARCHAR2 ,p_doctype_list IN VARCHAR2,p_publicationOffset IN VARCHAR2) IS
            select distinct cle.ctn
            from locale_language ll
            
            inner join mv_co_object_id_country co
               on co.country = ll.country 
              
            inner join channel_catalogs cc
               on cc.catalog_type = co.customer_id 
              and cc.enabled = 1
              and cc.locale = ll.locale
            
            <!-- CLE.ctn is a combination of asset id and doc type, e.g. 32PFL3405H_12|RTP -->
            inner join customer_locale_export cle
               on substr(cle.ctn,1,instr(cle.ctn,'|')-1) = co.object_id
              and cle.locale = ll.locale
            
            inner join asset_lists al 
               on cle.ctn = al.asset_id
              and cle.locale = al.locale
            <!-- flag if md5 has a value and it is different than the last sent md5
                 or if md5 is empty and the lastmodified timestamp is newer -->
              and (  (al.md5 not is null and nvl(cle.remark, 'null') != al.md5) 
                  or (al.md5 is null and al.lastmodified > cle.lasttransmit))
              and instr(p_doctype_list,al.doctype) > 0 
            
            where ll.locale = p_locale
              and (co.sop-to_number(p_publicationOffset)) &lt; sysdate
              and co.eop &gt; sysdate
              and nvl(co.deleted,0) = 0
            ;
         
        CURSOR OBJECTASSET_LIST(p_locale IN VARCHAR2 ,p_doctype_list in VARCHAR2) IS
          select distinct cle.ctn
          from customer_locale_export cle 
          inner join asset_lists al 
             on cle.ctn = al.asset_id
            and cle.locale = al.locale
            and (  (al.md5 is not null and nvl(cle.remark, 'null') != al.md5)
                or (a1.md5 is null and a1.lastmodified > cle.lasttransmit))
            and cle.locale = p_locale
            and instr(p_doctype_list,al.doctype) > 0 ;
      
        v_locale              VARCHAR2(10)   := '<xsl:value-of select="$locale"/>';
        v_doctype_list        VARCHAR2(3000) := q'|<xsl:value-of select="$doctype-list"/>|';
        v_publicationOffset   VARCHAR2(10)   := '<xsl:value-of select="$publicationOffset"/>';
        v_channel             VARCHAR2(100)  := '<xsl:value-of select="$channel"/>';
      
      begin
        for r in ASSET_LIST( v_locale
                         , v_doctype_list
                         , v_publicationOffset
                         )
        loop
          <!--dbms_output.put_line('CursorASSET_LIST: o='||r.ctn||', l='||v_locale||', dt='||v_doctype_list||', cha='||v_channel||'.');-->
          UPDATE CUSTOMER_LOCALE_EXPORT cle
          set FLAG=1
          where customer_id = v_channel
            and locale = v_locale
            and ctn = r.ctn
          ;
        end loop;
            
        for r in OBJECTASSET_LIST(v_locale
                               ,  v_doctype_list )
        loop
          <!--dbms_output.put_line('CursorOBJECTASSET_LIST: o='||r.ctn||', l='||v_locale||', dt='||v_doctype_list||', cha='||v_channel||'.');-->
          UPDATE CUSTOMER_LOCALE_EXPORT cle
          set FLAG=1
          where customer_id = v_channel
            and locale = v_locale
            and ctn = r.ctn;
        end loop;
      end;
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>

</xsl:stylesheet>