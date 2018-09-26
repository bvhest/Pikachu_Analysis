<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel">test</xsl:param>
  <xsl:param name="locale">en_UK</xsl:param>
  <xsl:param name="country"/>  
  
  <!-- new content type parameter needed for ATG PCT export -->
  <xsl:param name="sourceCT"/>

  <!-- -->
  <xsl:template match="/">
    <!--
       | default = PMT, otherwise select from sourceCT variabele.
     -->
    <xsl:variable name="source" select="if ($sourceCT!='') then $sourceCT else 'PMT'" />
    <!--
       | Note: PCT_Localised currently does not exist (2009-10-13), 
       -->
    <xsl:variable name="source-localised" select="if ($sourceCT='PCT') then 'PCT_Master' else 'PMT_Localised'" />

    <Products>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="product">
  -- The subselect can return double products if channel.catalog = 'ALL'
  -- Use extra join on MASTER_PRODUCTS to get the data,
  -- because the group by cannot be done with the data column
select sub1.object_id id
     , 'ENG' as language
     , sub1.sop
     , sub1.eop
     , sub1.sos
     , sub1.eos
     , sub1.priority
     , sub1.deleted
     , sub1.content_type
     , (select max(local_going_price) from catalog_objects catObj where catObj.object_id = sub1.object_id
            and catObj.country = '<xsl:value-of select="$country"/>'
            and catObj.customer_id = catalogtype      
         ) local_going_price
     , decode(sub1.deleteafterdate,'1900-01-01T00:00:00','') deleteafterdate,
        (case
          -- B2C catalogs
          when sub1.catalogtype in ('CARE','CONSUMER','PROFESSIONAL','NORELCO')
            then sub1.catalogtype
          -- default catalog: Consumer
          else
            'CONSUMER'
         end
        ) catalogtype
     ,
        (case
          -- B2C catalogs
          when sub1.catalogtype in ('CARE')
            then sub1.catalogtype
          -- default catalog: Consumer
          else
            'CONSUMER'
         end
        ) categorization_catalogtype
     , o.data
     , pmt.data pmt <!-- for assetlist/objectassetlist/productreference data -->
 from (
          select distinct o.object_id
               , TO_CHAR(min(co.sop),'yyyy-mm-dd"T"hh24:mi:ss') as sop
               , TO_CHAR(max(co.eop),'yyyy-mm-dd"T"hh24:mi:ss') as eop
               , TO_CHAR(min(co.sos),'yyyy-mm-dd"T"hh24:mi:ss') as sos
               , TO_CHAR(max(co.eos),'yyyy-mm-dd"T"hh24:mi:ss') as eos
               , max(co.priority) as priority
               , case when min(nvl(co.deleted,0)) = 0
                      then null
                      else TO_CHAR(max(nvl(co.delete_after_date,to_date('19000101','YYYYMMDD'))),'yyyy-mm-dd"T"hh24:mi:ss')
                      end as deleteafterdate
               , min(nvl(co.deleted,0)) as deleted
               , max(co.customer_id) as catalogtype
               , o.localisation
               , o.content_type
            from octl o 
      inner join catalog_objects co 
              on co.object_id=o.object_id
             and o.content_type = '<xsl:value-of select="$source-localised"/>'
<xsl:choose>
  <xsl:when test="$source != 'PCT'">               
             and o.status = 'Final Published'
             and o.localisation = 'master_' || co.country
  </xsl:when>
  <xsl:otherwise>
             and o.localisation = 'master_global'
  </xsl:otherwise>
</xsl:choose>
             and co.country = '<xsl:value-of select="substring-after($locale,'_')"/>'
      inner join LOCALE_LANGUAGE ll 
              on co.COUNTRY=ll.country
             and ll.locale='<xsl:value-of select="$locale"/>'        
      inner join CUSTOMER_LOCALE_EXPORT cle 
              on cle.ctn=o.object_id
             and cle.locale=ll.locale
             and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
             and cle.flag=1
      inner join channels ch 
              on ch.name = cle.CUSTOMER_ID      
      inner join channel_catalogs cc
              on cc.customer_id = ch.id            
           where (ch.catalog='ALL' or co.CUSTOMER_ID = cc.catalog_type)
             and cc.masterlocaleenabled=1
        group by o.content_type, o.object_id, ll.language, o.localisation
      ) sub1
      inner join octl o
              on o.object_id = sub1.object_id
             and o.localisation = sub1.localisation
             and o.content_type = sub1.content_type
       left outer join (select o.object_id
                             , o.data
                          from octl o
                         where o.localisation = '<xsl:value-of select="$locale"/>'
                           and o.content_type = '<xsl:value-of select="$source"/>'
                        ) pmt
                    on pmt.object_id = sub1.object_id
        order by sub1.object_id
          </sql:query>
        <sql:execute-query>
          <sql:query name="cat">
               select c.groupcode, c.groupname, c.categorycode, c.categoryname, c.subcategorycode, c.subcategoryname, c.catalogcode, c.bgroupname, c.bgroupcode
                 from categorization c
           inner join vw_object_categorization oc 
                   on oc.subcategory = c.subcategorycode  
                  and oc.catalogcode = c.catalogcode        
                where oc.object_id   = '<sql:ancestor-value name="id" level="1"/>'
                  and oc.catalogcode = '<sql:ancestor-value name="categorization_catalogtype" level="1"/>'
                  and rownum = 1 
               UNION   
               select c.groupcode, c.groupname, c.categorycode, c.categoryname, c.subcategorycode, c.subcategoryname, c.catalogcode, c.bgroupname, c.bgroupcode
                 from categorization c
           inner join vw_object_categorization oc 
                   on oc.subcategory = c.subcategorycode  
                  and oc.catalogcode = c.catalogcode        
                where oc.object_id   = '<sql:ancestor-value name="id" level="1"/>'
                  and oc.catalogcode = 'ProductTree'
                  and rownum = 1
          </sql:query>
        </sql:execute-query>
       </sql:execute-query>
    </Products>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
