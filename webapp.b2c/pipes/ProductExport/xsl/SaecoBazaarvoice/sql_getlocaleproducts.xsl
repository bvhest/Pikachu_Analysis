<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:param name="country"/>
  <xsl:param name="exportdate"/>
  
   <!-- xsl:variable name="DoctypesDoc" select="document(../../../cmc2/xml/doctypeAttributes)"/ -->  
  <xsl:variable name="fulldate"><xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/>T<xsl:value-of select="substring($exportdate,10,2)"/>:<xsl:value-of select="substring($exportdate,12,2)"/>:00</xsl:variable> 
  <xsl:variable name="doctype-channel" select="$channel"/>

  <xsl:template match="/">
  <root>

      <sql:execute-query>
        <sql:query name="Cat-tree">
          select cle.ctn ID
               --, o.masterlastmodified_ts MASTERLASTMODIFIED
               --, o.lastmodified_ts LASTMODIFIED
               --, cast(((o.lastmodified_ts - cast('01-JAN-1970' as date)) * 86400) -7200 as integer)  as TIMESTAMP
               --, nvl(cle.lasttransmit,to_date('1900-01-01','YYYY-MM-DD')) as lastexportdate
		           --, o.object_id categorization_catalogtype
		           , cle.locale
               , lc.groupcode, lc.groupname
               , lc.categorycode, lc.categoryname
               , lc.subcategorycode, lc.subcategoryname
               
          FROM CUSTOMER_LOCALE_EXPORT cle 

          INNER JOIN localized_subcat lc 
             ON lc.locale = cle.locale
            AND lc.catalogcode = cle.ctn
          
          WHERE cle.customer_id='<xsl:value-of select="$channel"/>'
            and cle.locale = '<xsl:value-of select="$locale"/>'
            and cle.flag = 1
          
          -- Send only catg entries that contain products and are in the configured brands and divisions
            and exists (
              select oc.object_id from vw_object_categorization oc
              inner join object_master_data omd
                 on omd.object_id=oc.object_id
              inner join channels ch
                 on ch.name='<xsl:value-of select="$channel"/>'
              inner join channel_catalogs cc
                 on cc.customer_id=ch.id
                and cc.enabled=1
                and cc.locale='<xsl:value-of select="$locale"/>'
                and (cc.brand = 'ALL' or cc.brand=omd.brand)
                and (cc.division = 'ALL' or cc.division=omd.division)
              inner join mv_cat_obj_country co
                 on co.object_id=oc.object_id
                and co.country='<xsl:value-of select="$country"/>'
              where cc.catalog_type=co.catalog
                and lc.subcategorycode=oc.subcategory
            )
          
          order by lc.groupcode, lc.categorycode, lc.subcategorycode
        </sql:query>
        </sql:execute-query>
  
      <sql:execute-query>
        <sql:query name="Product">
          SELECT sub.id, sub.masterlastmodified, sub.lastmodified, sub.timestamp
               , sub.lastexportdate, sub.catalog_type, sub.locale
               , sub.sop, sub.eop, sub.sos, sub.eos
               , sub.deleted
               , sub.data
          FROM (
                SELECT distinct 
                       o.object_id ID
                     , o.masterlastmodified_ts masterlastmodified
                     , o.lastmodified_ts lastmodified
                     , cast(((o.lastmodified_ts - cast('01-JAN-1970' as date)) * 86400) -7200 as integer) as timestamp
                     , nvl(cle.lasttransmit,to_date('1900-01-01','YYYY-MM-DD')) as lastexportdate
                     , cc.catalog_type
                     , decode(cc.catalog_type, 'CONSUMER', 1, 'NONCONSUMER', 2, 3) as catalog_type_rank
                     , min(decode(cc.catalog_type, 'CONSUMER', 1, 'NONCONSUMER', 2, 3)) over(
                          partition by o.object_id
                       ) as min_rank
                     , o.localisation locale
                     , TO_CHAR(mv.sop,'yyyy-mm-dd"T"hh24:mi:ss') as sop
                     , TO_CHAR(mv.eop,'yyyy-mm-dd"T"hh24:mi:ss') as eop
                     , TO_CHAR(mv.sos,'yyyy-mm-dd"T"hh24:mi:ss') as sos
                     , TO_CHAR(mv.eos,'yyyy-mm-dd"T"hh24:mi:ss') as eos
                     , case when mv.deleted=1 or mv.eop &lt; sysdate then 
                          1 
                        else 
                          0 
                        end as deleted
                     , o.data 
                FROM CUSTOMER_LOCALE_EXPORT cle 
                
                INNER JOIN octl o
                <xsl:choose>
                  <xsl:when test="$locale = 'master_global'">
                   ON o.content_type = 'PMT_Master'
                  </xsl:when>
                  <xsl:otherwise>
                   ON o.content_type = 'PMT'
                  </xsl:otherwise>
                </xsl:choose> 
                  AND o.object_id = cle.ctn
                  AND o.localisation = cle.locale
                
                INNER JOIN channels c 
                   ON c.name = '<xsl:value-of select="$channel"/>' 
                
                INNER JOIN channel_catalogs cc
                   ON cc.customer_id  = c.ID
                  AND cc.locale =  cle.locale
                  AND cc.enabled = 1
                
                INNER JOIN object_master_data omd
                   ON omd.object_id = o.object_id
                
              <xsl:choose>
                <xsl:when test="$locale = 'master_global'">
                INNER JOIN mv_co_object_id mv
                   ON mv.object_id = o.object_id
                --  AND mv.deleted = 0
                </xsl:when>
                <xsl:otherwise>
                INNER JOIN mv_cat_obj_country mv
                   ON mv.object_id = o.object_id
                  AND mv.country = '<xsl:value-of select="$country"/>'
                  AND mv.catalog = cc.catalog_type
                --  AND mv.deleted = 0
                </xsl:otherwise>
              </xsl:choose>
                                
                WHERE cle.customer_id='<xsl:value-of select="$channel"/>'
                  AND cle.locale = '<xsl:value-of select="$locale"/>'
                  AND cle.flag = 1
                  AND (cc.brand = 'ALL' or cc.brand=omd.brand)
                  AND (cc.division = 'ALL' or cc.division=omd.division)
            ) sub
          WHERE catalog_type_rank=min_rank
        </sql:query>
        <sql:execute-query>
          <sql:query name="cat">
               select c.catalogcode, c.groupcode, c.groupname, c.categorycode, c.categoryname, c.subcategorycode, c.subcategoryname
                 from categorization c
                inner join vw_object_categorization oc 
                   on oc.subcategory = c.subcategorycode  
                  and oc.catalogcode = c.catalogcode        
                where oc.object_id   = '<sql:ancestor-value name="id" level="1"/>'
                  and oc.catalogcode = '<sql:ancestor-value name="catalog_type" level="1"/>'
          </sql:query>
        </sql:execute-query>
        <sql:execute-query>
          <sql:query name="family">
               select oc.object_id, c.subcategoryname
                 from categorization c
                inner join vw_object_categorization oc 
                   on oc.subcategory = c.subcategorycode  
                  and oc.catalogcode = c.catalogcode        
                where oc.object_id   = '<sql:ancestor-value name="id" level="1"/>'
                  and oc.catalogcode = 'MARKETING'
                  and c.categorycode = 'FAMILY'
          </sql:query>
        </sql:execute-query>        
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
