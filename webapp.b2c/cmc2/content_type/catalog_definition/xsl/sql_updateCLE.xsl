<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="timestamp"/>
  <xsl:param name="destination"/>
  <!-- -->
  <xsl:template match="/">
    <root step="updateCLE" destination="{$destination}" timestamp="{$timestamp}">
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="sql_updateCLE:1">
          -- RenderingExport: include *MARKETING catalogs
          update CUSTOMER_LOCALE_EXPORT CLE
             set lasttransmit = to_date('19000101','YYYYMMDD')
               , remark = 'LASTTRANSMIT set to 19000101 by LCBIMPORT on ' || to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') || '. PREVIOUS LASTTRANSMIT ' || lasttransmit
           where customer_id = 'RenderingExport' 
             and (locale, ctn) in (select ll.locale, co.object_id 
                                     from catalog_objects co
                               inner join locale_language ll 
                                       on co.country      = ll.country_code
                                    where co.lastModified = to_date('<xsl:value-of select="$timestamp"/>', 'yyyy-MM-dd"T"hh24:mi:ss')
                                      and customer_id    != 'CARE')
             and lasttransmit != to_date('19000101','YYYYMMDD')
        </sql:query>
      </sql:execute-query>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="sql_updateCLE:2">
          -- All others: exclude *MARKETING catalogs
          update CUSTOMER_LOCALE_EXPORT CLE
             set lasttransmit = to_date('19000101','YYYYMMDD')
               , remark = 'LASTTRANSMIT set to 19000101 by LCBIMPORT on ' || to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') || '. PREVIOUS LASTTRANSMIT ' || lasttransmit
           where rowid in (
                    select cle.rowid
                    from customer_locale_export cle
                    
                    inner join catalog_objects co
                       on co.object_id=cle.ctn
                      and co.country=substr(cle.locale,4)
                      
                    -- join on channels and channel_catalogs to touch only 
                    -- export channels that depend on the catalogs' catalog type
                    inner join channels ch
                       on ch.name=cle.customer_id
                    left outer join (
                        select distinct customer_id, catalog_type, locale from channel_catalogs
                      ) cc
                      on cc.customer_id=ch.id
                     and cc.catalog_type=co.customer_id
                     and substr(cc.locale,4)=co.country
                    
                    where 
                          co.lastmodified=to_date('<xsl:value-of select="$timestamp"/>', 'yyyy-MM-dd"T"hh24:mi:ss')
                      and cle.lasttransmit is not null and cle.lasttransmit!=to_date('1900-01-01','yyyy-mm-dd')
                      and co.customer_id!='CARE'
                      and ((cc.customer_id is not null or ch.catalog='ALL') or (cc.customer_id is null and ch.catalog=co.customer_id))
                      
                      -- Exclude channels that do not send catalog information (that is actually used)
                      -- to prevent resending unnecesary data
                      and cle.customer_id not in (
                           'AtgAssets','FSSAssets','Scene7','FlixMediaAssets'
                          ,'AtgGifting','AtgProducts','AtgMerchandise'
                          ,'ProductDescription','AmaHK','VmaHK'
                          ,'RenderingExport'
                          ,'ShopAtgExport','ShopAtgSearch'
                          ,'ObjectKeysProducts'
                          ,'Scene7Lighting'
                          ,'AtgLightingProducts','AtgLightingFamilies','ProfPMTAtgMerchandise'
                          ,'PMTRenderingExport','FMTRenderingExport'
                          ,'Products2CQ','ProductsCare2CQ','ProductsMetadata2CQ'
                          )
           )
        </sql:query>
      </sql:execute-query>      
    </root>
  </xsl:template>
</xsl:stylesheet>