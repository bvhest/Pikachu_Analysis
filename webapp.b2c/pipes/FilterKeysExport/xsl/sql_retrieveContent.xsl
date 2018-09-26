<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:template match="/">
    <Products>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="product">
            select    mp.ID                        
                 , ll.LANGUAGE
                 , '<xsl:value-of select="$locale"/>' as locale
                 , CC.COUNTRY as COUNTRY
                 , TO_CHAR(CC.sop,'yyyy-mm-dd"T"hh24:mi:ss') as sop
                 , TO_CHAR(CC.eop,'yyyy-mm-dd"T"hh24:mi:ss') as eop
                 , decode(cc.buy_online, 1, 'true', 0, 'false') as buy_online
                 , cc.priority as priority
                 , decode(cc.deleted, 1, 'true', 0, 'false') as deleted
                 , TO_CHAR(cc.delete_after_date,'yyyy-mm-dd"T"hh24:mi:ss') as delete_after_date
                 , decode(mp.division, 'CE', 'PCE', 'DAP', 'DAP','Lighting','PCE') as division
                 , CC.CUSTOMER_ID AS catalog
                 , nvl(cle.lasttransmit,to_date('1900-01-01','YYYY-MM-DD')) as lastexportdate
                 , mp.data as data
                 , rmp.data as fans_data
              from master_products mp 
   left outer join raw_master_products rmp 
                on rmp.ctn                = mp.id 
        inner join customer_catalog cc
                on mp.id                  = cc.ctn
        inner join (select language, locale, country from locale_language where locale = '<xsl:value-of select="$locale"/>') ll
                on ll.country             = cc.country
        inner join channel_catalogs chan_cats 
                on chan_cats.division     = cc.division
               and chan_cats.catalog_type = cc.customer_id
        inner join customer_locale_export cle 
                on cle.ctn                = mp.id 
             where mp.status             in ('Final Published','MasterBlaster')
               and rmp.data_type          = 'websitefiltering'
               and cc.country             = '<xsl:value-of select="substring-after($locale,'_')"/>'
               and cc.deleted            != 1
               and cc.eop              &gt; SYSDATE
               and chan_cats.locale       = '<xsl:value-of select="$locale"/>'
               and chan_cats.customer_id  = (select id 
                                               from channels 
                                              where name = '<xsl:value-of select="$channel"/>'
                                            )
               and cle.locale             = '<xsl:value-of select="$locale"/>'
               and cle.customer_id        = '<xsl:value-of select="$channel"/>' 
               and cle.flag               = 1
               and cle.locale             = ll.locale
             order by mp.id</sql:query>
        <sql:execute-query>
          <sql:query name="cat">
          <!-- What to do here for FLAGSHIPSHOP?  There are no cats with catalogcode = 'FLAGSHIPSHOP' so the below query returns zero rows -->
select sc.groupcode, sc.groupname, sc.categorycode, sc.categoryname, sc.subcategorycode, sc.subcategoryname, sc.catalogcode
 from subcat_products sp
inner join subcat sc on sp.subcategorycode = sc.subcategorycode
where sp.id           = '<sql:ancestor-value name="id" level="1"/>'
  and sc.catalogcode  = '<sql:ancestor-value name="catalog" level="1"/>'
  and sc.catalogcode in (select distinct cc.catalog_type 
                           from channel_catalogs cc 
                     inner join channels c 
                             on cc.customer_id   = c.id 
                          where c.name           = '<xsl:value-of select="$channel"/>' 
                            and cc.locale        = '<xsl:value-of select="$locale"/>' 
                            and cc.enabled       = 1
                        )
        </sql:query>
      </sql:execute-query>                    
      </sql:execute-query>
    </Products>
  </xsl:template>
</xsl:stylesheet>
