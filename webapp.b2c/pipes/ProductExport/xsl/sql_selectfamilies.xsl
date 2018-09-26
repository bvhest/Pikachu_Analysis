<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="channel"/>
  <xsl:param name="country"/>
  <xsl:param name="locale"/>
  <xsl:param name="exportdate"/>
  <xsl:param name="selectall">no</xsl:param>  
  <xsl:param name="sourceCT"/>

  <xsl:variable name="fulldate"><xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/>T<xsl:value-of select="substring($exportdate,10,2)"/>:<xsl:value-of select="substring($exportdate,12,2)"/>:00</xsl:variable>

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
    <!-- default = FMT, otherwise select from sourceCT variabele -->
    <xsl:variable name="source" select="if ($sourceCT != '') then $sourceCT else 'FMT'" />

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
                and o.status = 'Final Published'
         inner join catalog_objects co
                 on co.object_id = o.object_id
                and ((ch.catalog = 'ALL' and co.customer_id != 'CARE') or co.CUSTOMER_ID=cc.catalog_type)
                and co.COUNTRY='<xsl:value-of select="substring-after($locale,'_')"/>'
    left outer join CUSTOMER_LOCALE_EXPORT cle
                 on o.object_ID=cle.ctn
                and o.localisation=cle.locale
                and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
              where cle.CUSTOMER_ID is NULL
              --BHE testcase: and o.object_id like '29PT55%' or o.object_id = '42PFL3312/10'
      </sql:query>
    </sql:execute-query>

    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
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
                            and o.status = 'Final Published'
                     inner join catalog_objects co
                             on co.object_id = o.object_id
                            and co.COUNTRY='<xsl:value-of select="substring-after($locale,'_')"/>'
                            and ((ch.catalog = 'ALL' and co.customer_id != 'CARE') or co.CUSTOMER_ID=cc.catalog_type)
<xsl:if test="$selectall != 'yes'">
                            and co.sop - 7 &lt; sysdate
                            and co.eop + 7 &gt; sysdate
                          where (cle.lasttransmit is null or o.lastmodified_ts &gt; cle.lasttransmit)
</xsl:if>
                          )
                   -- and cle.ctn like '29PT55%' or cle.ctn = '42PFL3312/10'
                   -- and rownum &lt;= 500
                   
      </sql:query>
    </sql:execute-query>
  </xsl:template>
</xsl:stylesheet>