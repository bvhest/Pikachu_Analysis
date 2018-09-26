<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <!--
    Overrides default stylesheet to trigger export on modified performer-accessory relationships
    by joining to the OBJECT_RELATIONS table.
    Since the performer CTNs of accessory products are exported an accessory product has to be re-exported
    if anything changes in its relations to the performers. (New relationship was added or relationshop was deleted.)
  -->
  
  <xsl:param name="channel"/>
  <xsl:param name="country"/>
  <xsl:param name="locale"/>
  <xsl:param name="exportdate"/>
  <xsl:param name="selectall"/>

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
    <!-- default = PMT, otherwise select from sourceCT variabele. -->
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
                and cc.enabled = 1 and cc.localeenabled = 1
                and o.content_type = '<xsl:value-of select="$source"/>'
                and o.localisation='<xsl:value-of select="$locale"/>'
                and o.status = 'Final Published'
         inner join catalog_objects co
                 on co.object_id = o.object_id
                and ((ch.catalog = 'ALL' and co.customer_id != 'CARE') or co.CUSTOMER_ID=cc.catalog_type)
                and co.COUNTRY='<xsl:value-of select="substring-after($locale,'_')"/>'
                and co.deleted=0
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
             and ctn in (select distinct o.object_id
                           from octl o
                           
                     inner join channels ch
                             on ch.name =  '<xsl:value-of select="$channel"/>'
                             
                     inner join channel_catalogs cc
                             on ch.id = cc.customer_id
                            and cc.locale = o.localisation
                            and cc.enabled = 1 and cc.localeenabled = 1
                            and o.content_type = '<xsl:value-of select="$source"/>'
                            and o.localisation='<xsl:value-of select="$locale"/>'
                            and o.status = 'Final Published'
                            
                     inner join object_master_data omd
                             on o.object_id = omd.object_id
                            and (omd.division = cc.division or cc.division='ALL')
                            
                     -- Join the products performer ctns
                     left outer join object_relations prd_acc
                             on prd_acc.rel_type='PRD_ACC'
                            and prd_acc.object_id_tgt=o.object_id
                            
                     inner join catalog_objects co
                             on co.object_id = o.object_id
                            and co.COUNTRY='<xsl:value-of select="substring-after($locale,'_')"/>'
                            and ((ch.catalog = 'ALL' and co.customer_id != 'CARE') or co.CUSTOMER_ID=cc.catalog_type)
                            and co.deleted=0
<xsl:if test="$selectall != 'yes'">
                            and (co.sop - to_number('<xsl:value-of select="$publicationOffset"/>')) &lt; sysdate
                            and (co.eop + 7) &gt; sysdate
                          where (cle.lasttransmit is null or o.lastmodified_ts &gt; cle.lasttransmit
                              -- product-accessory relation was added or removed
                              or (prd_acc.lastmodified_ts is not null and prd_acc.lastmodified_ts &gt; cle.lasttransmit)
                              )
</xsl:if>
                          )
      </sql:query>
    </sql:execute-query>
  </xsl:template>
</xsl:stylesheet>
