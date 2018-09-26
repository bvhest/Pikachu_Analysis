<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:param name="full"/>

  <xsl:variable name="full-export" select="if ($full = 'true') then true() else false()"/>
  
  <xsl:template match="/">
    <root>
      <!-- clear all-->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="reset-flags">
          <!-- Reset flag and force resending if full is requested -->
          update customer_locale_export
             set flag=0
           <xsl:if test="$full-export">
           , lasttransmit = null
           </xsl:if>
           where customer_id='<xsl:value-of select="$channel"/>'
             and locale='<xsl:value-of select="$locale"/>'
           <xsl:if test="not($full-export)">
             and flag != 0
           </xsl:if>
        </sql:query>
      </sql:execute-query>

      <xsl:call-template name="select"/>
    </root>
  </xsl:template>

  <xsl:template name="select">        
    <xsl:variable name="source" select="'ProductMasterData'" />

    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="new-products">
        insert into customer_locale_export(customer_id, locale, ctn, flag)
             select distinct
                      '<xsl:value-of select="$channel"/>'
                    , o.localisation
                    , o.object_id
                    , 2   <!-- New products are flagged with 2 -->
               from OCTL o
               inner join CHANNELS ch
                       on ch.name =  '<xsl:value-of select="$channel"/>'
               inner join channel_catalogs cc
                       on ch.id = cc.customer_id
                      and cc.locale = o.localisation
                      and (cc.ENABLED = 1 or cc.masterlocaleenabled = 1)
                      and o.content_type = '<xsl:value-of select="$source"/>'
                      and o.localisation='<xsl:value-of select="$locale"/>'
               inner join catalog_objects co
                       on co.object_id = o.object_id
                      and co.catalog_id=ch.catalog
               left outer join CUSTOMER_LOCALE_EXPORT cle
                            on o.object_ID=cle.ctn
                           and o.localisation=cle.locale
                           and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
               where cle.CUSTOMER_ID is NULL
              --BHE testcase: and o.object_id like '29PT55%' or o.object_id = '42PFL3312/10'
      </sql:query>
    </sql:execute-query>
    <!--  -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="existing-products">
        update CUSTOMER_LOCALE_EXPORT CLE
             set  flag=1
           where locale = '<xsl:value-of select="$locale"/>'
             and customer_id = '<xsl:value-of select="$channel"/>'
             and ctn in (select o.object_id
                           from octl o
                     inner join channels ch
                             on ch.name =  '<xsl:value-of select="$channel"/>'
                     inner join channel_catalogs cc
                             on ch.id = cc.customer_id
                            and cc.locale = o.localisation
                            and (cc.ENABLED = 1 or cc.masterlocaleenabled = 1)
                            and o.content_type = '<xsl:value-of select="$source"/>'
                            and o.localisation='<xsl:value-of select="$locale"/>'
                     inner join catalog_objects co
                             on co.object_id = o.object_id
                            and co.catalog_id=ch.catalog
                     where (cle.lasttransmit is null or o.lastmodified_ts &gt; cle.lasttransmit)
                     and cle.flag = 0
                   )
             -- and cle.ctn like '29PT55%' or cle.ctn = '42PFL3312/10'
             -- and rownum &lt;= 500
      </sql:query>
    </sql:execute-query>
  </xsl:template>
</xsl:stylesheet>