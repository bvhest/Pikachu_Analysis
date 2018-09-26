<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="channel"/>
  <xsl:param name="country"/>
  <xsl:param name="locale"/>
  <xsl:param name="exportdate"/>
  <xsl:variable name="fulldate"><xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/>T<xsl:value-of select="substring($exportdate,10,2)"/>:<xsl:value-of select="substring($exportdate,12,2)"/>:00</xsl:variable>
  <!-- -->
  <xsl:template match="/">
  <root>
  <!-- clear all-->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        update customer_locale_export
           set flag=0
         where customer_id='<xsl:value-of select="$channel"/>'
           and locale='<xsl:value-of select="$locale"/>'
      </sql:query>
    </sql:execute-query>
    <!-- add all new products from channel catalog(s)-->
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
                and cc.enabled = 1
                and o.content_type = 'PMT'
                and o.localisation='<xsl:value-of select="$locale"/>'
                and o.status = 'Final Published'
         inner join catalog_objects co
                 on co.object_id = o.object_id
                and ((ch.catalog = 'ALL' and co.customer_id != 'CARE') or co.CUSTOMER_ID=cc.catalog_type)
                and co.COUNTRY='<xsl:value-of select="substring-after($locale,'_')"/>'
         inner join object_master_data omd
                 on o.object_id = omd.object_id       
                and (omd.division = cc.division or cc.division='ALL')
                and (omd.brand = cc.brand or cc.brand ='ALL')  
    left outer join CUSTOMER_LOCALE_EXPORT cle
                 on o.object_ID=cle.ctn
                and o.localisation=cle.locale
                and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
              where cle.CUSTOMER_ID is NULL
      </sql:query>
    </sql:execute-query>
  <!-- set flag to 1 if the export was before the last modified date -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
update CUSTOMER_LOCALE_EXPORT CLE
   set  flag=1
 where locale = '<xsl:value-of select="$locale"/>'
   and customer_id = '<xsl:value-of select="$channel"/>'
   and ctn in
            (select o.object_id
               from octl o
         inner join channels ch
                 on ch.name =  '<xsl:value-of select="$channel"/>'
         inner join channel_catalogs cc
                 on ch.id = cc.customer_id
                and cc.locale = o.localisation
                and cc.enabled = 1
                and o.content_type = 'PMT'
                and o.localisation='<xsl:value-of select="$locale"/>'
                and o.status = 'Final Published'
         inner join object_master_data omd
                 on o.object_id = omd.object_id
                and (omd.division = cc.division or cc.division='ALL')
                and (omd.brand = cc.brand or cc.brand ='ALL')
                and omd.product_type = cc.product_type                                
         inner join catalog_objects co
                 on co.object_id = o.object_id
                and co.COUNTRY='<xsl:value-of select="substring-after($locale,'_')"/>'
                and ((ch.catalog = 'ALL' and co.customer_id != 'CARE') or co.CUSTOMER_ID=cc.catalog_type)
                and co.sop - 45 &lt; sysdate
                and co.eop + 7 &gt; sysdate
              )
      </sql:query>
    </sql:execute-query>
  <!-- -->
  </root>
</xsl:template>
</xsl:stylesheet>