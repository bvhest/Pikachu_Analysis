<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:param name="channel"/>
  <xsl:param name="processDeletions"/>
  <xsl:param name="nrOfThreads"/>
    
  <xsl:variable name="publicationOffset" select="'7'"/>
  <!-- <xsl:variable name="l-nr-threads" select="if ($nrOfThreads != '') then $nrOfThreads else 1"/> -->
  <xsl:variable name="l-nr-threads">
    <xsl:choose>
      <xsl:when test="$nrOfThreads != ''">
        <xsl:value-of select="$nrOfThreads"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>1</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="doctype-list">
    <xsl:text>'</xsl:text>
    <xsl:value-of select='string-join(/doctypes/doctype[attribute::*[local-name()=$channel]="yes"]/@code, "&apos;,&apos;")'/>
    <xsl:text>'</xsl:text>
  </xsl:variable>
  
  <xsl:template match="/">
    <root>
      <!-- clear all-->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
         <sql:query name="clear cle-table">
            UPDATE CUSTOMER_LOCALE_EXPORT cle
               SET cle.flag         = 0
                 , cle.batch        = 0
             WHERE cle.customer_id  = '<xsl:value-of select="$channel"/>'
               AND (cle.flag != 0 OR cle.batch != 0) -- no need to do unnecessary updates
         </sql:query>
      </sql:execute-query>
      
      <!--
        For product movies insert new CLE records or flag the existing records
        - when MD5 is modified
        - when MD5 is empty but asset mod date is after last export date
        - for active products (offset days in advance)
        
        Assumes that all movies are locale based.
      -->
      <sql:execute-query>
        <sql:query name="flag cle-prd-records">
          merge into customer_locale_export cle 
          using (
            select a.asset_resource_ref, min(a.md5) as md5, min(a.lastmodified) as lastmodified
            from asset_lists a
            
            inner join locale_language l
               on l.locale = a.locale
               
            inner join mv_co_object_id_country co
               on co.object_id=a.object_id
              and co.country=l.country_code
            
            where a.doctype in (<xsl:value-of select="$doctype-list"/>)
              and a.product_asset=1
              and a.deleted=0
              and co.deleted=0
              and co.sop - <xsl:value-of select="$publicationOffset"/> &lt; sysdate

            group by a.asset_resource_ref
          ) al
          on (
            cle.ctn=al.asset_resource_ref
          )
          when not matched then
            insert (
                cle.customer_id
              , cle.locale
              , cle.ctn
              , cle.lasttransmit
              , cle.flag
              , cle.batch
              , cle.remark
            ) values (
                'Scene7Videos'
              , 'n/a'
              , al.asset_resource_ref
              , to_date('1900-01-01','yyyy-mm-dd')
              , 1
              , 0
              , ''
            )
          when matched then
            update set
                flag=1
            where (nvl(al.md5,'null') != 'null' and nvl(cle.remark,'null') != al.md5)
               or (nvl(al.md5,'null') = 'null' and cle.lasttransmit &lt; al.lastmodified)

          log errors into err$_cle
            ('Key:chan=<xsl:value-of select="$channel"/>'||',obj='||al.asset_resource_ref)
            reject limit unlimited
        </sql:query>
      </sql:execute-query>

      <!--
        For non-product movies insert new CLE records or flag the existing records
        - when MD5 is modified
        - when MD5 is empty but asset mod date is after last export date
        
        Assumes that all movies are locale based.
      -->
      <sql:execute-query>
        <sql:query name="flag cle-obj-records">
          merge into customer_locale_export cle 
          using (
            select a.asset_resource_ref, min(a.md5) as md5, min(a.lastmodified) as lastmodified
            from asset_lists a
            
            where a.doctype in (<xsl:value-of select="$doctype-list"/>)
              and a.product_asset=0
              and a.deleted=0

            group by a.asset_resource_ref
          ) al
          on (
            cle.ctn=al.asset_resource_ref
          )
          when not matched then
            insert (
                cle.customer_id
              , cle.locale
              , cle.ctn
              , cle.lasttransmit
              , cle.flag
              , cle.batch
              , cle.remark
            ) values (
                'Scene7Videos'
              , 'n/a'
              , al.asset_resource_ref
              , to_date('1900-01-01','yyyy-mm-dd')
              , 1
              , 0
              , ''
            )
          when matched then
            update set
                flag=1
            where (nvl(al.md5,'null') != 'null' and nvl(cle.remark,'null') != al.md5)
               or (nvl(al.md5,'null') = 'null' and cle.lasttransmit &lt; al.lastmodified)
          
          log errors into err$_cle
            ('Key:chan=<xsl:value-of select="$channel"/>'||',obj='||al.asset_resource_ref)
            reject limit unlimited
        </sql:query>
      </sql:execute-query>

      <!-- 
        Flag assets that were sent previously but
        - that have no active record in asset_lists
        - that were not sent as deleted (marked by the remark column)
        flag is set to 2 to mark deleted assets. 
      -->
      <xsl:if test="$processDeletions='true'">
        <sql:execute-query>
          <sql:query name="flag deleted assets">
            update customer_locale_export cle
            set flag=2
            where cle.customer_id='<xsl:value-of select="$channel"/>'
              and cle.remark != 'DELETED'
              and not exists (
                select 1 from asset_lists al
                where al.asset_resource_ref = cle.ctn
                and al.deleted = 0
              )
          </sql:query>
        </sql:execute-query>
      </xsl:if>
      
      <!--
        Set the batch number on CLE records flagged for export (non-deleted assets only.)
        Number of threads determines the number of batches.
      -->
      <sql:execute-query>
        <sql:query name="set cle-batch-numbers">
          update customer_locale_export
          set batch=mod(rownum, <xsl:value-of select="$l-nr-threads"/>)+1
          where customer_id='<xsl:value-of select="$channel"/>'
          and flag=1
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>