<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:param name="channel"/>
  <xsl:param name="country"/>
  <xsl:param name="locale"/>
  <xsl:param name="exportdate"/>
  <xsl:param name="selectall">no</xsl:param>  
  <xsl:param name="selectsubcat">no</xsl:param>  
  <xsl:param name="kvpdocpath"/>
  <!-- new content type parameter needed for ATG PCT export -->
  <xsl:param name="sourceCT"/>
  
  <xsl:variable name="fulldate"><xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/>T<xsl:value-of select="substring($exportdate,10,2)"/>:<xsl:value-of select="substring($exportdate,12,2)"/>:00</xsl:variable>
  
  <xsl:variable name="publicationOffset" select="7"/>
  
  <xsl:template match="/">
    <root>
      <!-- clear all-->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
          update customer_locale_export
             set flag=0
           where customer_id='<xsl:value-of select="$channel"/>'
             and locale='<xsl:value-of select="$locale"/>'
             and flag != 0
        </sql:query>
      </sql:execute-query>
      
      <xsl:call-template name="select"/>
    </root>
  </xsl:template>
  
  <xsl:template name="select">        
    <!-- default = PMT, otherwise select from sourceCT variabele.
     +-->
    <xsl:variable name="source" select="if ($sourceCT != '') then $sourceCT else 'PMT'" />

    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        insert into customer_locale_export(customer_id, locale, ctn, flag)
             select distinct
                      '<xsl:value-of select="$channel"/>'
                    , o.localisation
                    , o.object_id
                    , 0
               from OCTL o
         inner join CHANNELS ch
                 on ch.name =  '<xsl:value-of select="$channel"/>'
         inner join channel_catalogs cc
                 on ch.id = cc.customer_id
                and cc.locale = o.localisation
                and (cc.ENABLED = 1 or cc.masterlocaleenabled = 1)
                and o.content_type = '<xsl:value-of select="$source"/>'
                and o.localisation='<xsl:value-of select="$locale"/>'
<xsl:if test="not($source='PCT')">               
                and o.status = 'Final Published'
</xsl:if>               
         inner join catalog_objects co
                 on co.object_id = o.object_id
                and co.CUSTOMER_ID=cc.catalog_type
                and co.COUNTRY='<xsl:value-of select="substring-after($locale,'_')"/>'
    left outer join CUSTOMER_LOCALE_EXPORT cle
                 on o.object_ID=cle.ctn
                and o.localisation=cle.locale
                and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
              where cle.CUSTOMER_ID is NULL
      </sql:query>
    </sql:execute-query>
    
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="select-products">
        update CUSTOMER_LOCALE_EXPORT CLE
             set flag=1
           where locale = '<xsl:value-of select="$locale"/>'
             and customer_id = '<xsl:value-of select="$channel"/>'
             and ctn in (
                    select o.object_id
                    from channels ch
                    
                    inner join channel_catalogs cc
                       on cc.customer_id=ch.id
                    
                    inner join object_master_data omd
                       on (cc.division='ALL' or omd.division=cc.division)
                    
                    inner join octl o
                       on o.object_id=omd.object_id
                      and o.localisation=cc.locale
                      
                    where ch.name='<xsl:value-of select="$channel"/>'
                      and cc.enabled=1
                      and (cc.localeenabled=1 or cc.masterlocaleenabled=1)
                      and o.content_type='<xsl:value-of select="$source"/>'
                      and o.localisation='<xsl:value-of select="$locale"/>'
                    <xsl:if test="$source != 'PCT'">               
                      and o.status = 'Final Published'
                    </xsl:if>               
                      
                      and exists (
                        select 1 from catalog_objects
                        where object_id=o.object_id
                        and country='<xsl:value-of select="substring-after($locale,'_')"/>'
                        and customer_id=cc.catalog_type
                    <xsl:if test="$selectall != 'yes'">
                        and sop - ch.PUBLICATIONOFFSET_SOP &lt; sysdate
                        and eop + ch.PUBLICATIONOFFSET_EOP &gt; sysdate
                    </xsl:if>                  
                      )
                    <xsl:if test="$selectall != 'yes'">
                      and (cle.lasttransmit is null or o.lastmodified_ts &gt; cle.lasttransmit)
                    </xsl:if>
                )
    </sql:query>
  </sql:execute-query>
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="select-products-refs">
        update CUSTOMER_LOCALE_EXPORT CLE
             set flag=1
           where locale = '<xsl:value-of select="$locale"/>'
             and customer_id = '<xsl:value-of select="$channel"/>'
             and flag=0
             and ctn in (
                    select o.object_id
                    from channels ch
                  
                    inner join channel_catalogs cc
                       on cc.customer_id=ch.id
                    
                    inner join object_master_data omd
                       on (cc.division='ALL' or omd.division=cc.division)
                    
                    inner join octl o
                       on o.object_id=omd.object_id
                      and o.localisation=cc.locale
                      
                    where ch.name='<xsl:value-of select="$channel"/>'
                      and cc.enabled=1
                      and (cc.localeenabled=1 or cc.masterlocaleenabled=1)
                      and o.content_type='PMT_Refs'
                      and o.localisation='master_global'
                      and o.status = 'Final Published'
                      
                      and exists (
                        select 1 from catalog_objects
                        where object_id=o.object_id
                        and country='<xsl:value-of select="substring-after($locale,'_')"/>'
                        and customer_id=cc.catalog_type
                    <xsl:if test="$selectall != 'yes'">
                        and sop - ch.PUBLICATIONOFFSET_SOP &lt; sysdate
                        and eop + ch.PUBLICATIONOFFSET_EOP &gt; sysdate
                    </xsl:if>                  
                      )
                    <xsl:if test="$selectall != 'yes'">
                      and (cle.lasttransmit is null or o.lastmodified_ts &gt; cle.lasttransmit)
                    </xsl:if>
                )
      </sql:query>
    </sql:execute-query>
  </xsl:template>
</xsl:stylesheet>