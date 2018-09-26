<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                exclude-result-prefixes="sql xsl">
  <!--
  FileName    :  sql_getlocaleproducts.xsl
  Author      :  CJ
  Description :  Fetch IceCatRichContent information from DB and fileStore
  XSD         :  xUCDM_product_external_1_1_2
  Date        :  30-MAY-2014
  ***************
  Change History
  ***************************************************************************
  NO          Author          Date          Description
  ***************************************************************************
  01          CJ              30-MAY-2014   Added additional code to fetch 
                                            ProductReference -Performer.
  ***************************************************************************
  -->
  
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <!-- new content type parameter needed for ATG PCT export -->
  <xsl:param name="sourceCT"/>

  <!-- -->
  <xsl:template match="/">
    <!-- default = PMT, otherwise select from sourceCT variabele.
     +-->
    <xsl:variable name="source" select="if ($sourceCT != '') then $sourceCT else 'PMT'" />

    <Products>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="product">
    select
        sub1.object_id id,
        sub1.language,
        sub1.sop, sub1.eop,
        sub1.sos, sub1.eos,
        sub1.priority,
        decode(sub1.deleteafterdate,'1900-01-01T00:00:00','',sub1.deleteafterdate) deleteafterdate,
        sub1.deleted,
        sub1.content_type,
        sub1.localisation,
        (case
          -- B2C catalogs
          when sub1.catalogtype in ('CARE','CONSUMER','PROFESSIONAL','NORELCO')
            then sub1.catalogtype         
          -- default catalog: Consumer
          else
            'CONSUMER'
         end
        ) catalogtype,
        sub1.local_going_price,
        (case
          -- B2C catalogs
          when sub1.catalogtype in ('CARE')
            then sub1.catalogtype
          -- default catalog: Consumer
          else
            'CONSUMER'
         end
        ) categorization_catalogtype,
        o.data , o2.data wsf 
        from (
            select distinct
                o.object_id,
                ll.LANGUAGE,
                TO_CHAR(min(co.sop),'yyyy-mm-dd"T"hh24:mi:ss') as sop,
                TO_CHAR(max(co.eop),'yyyy-mm-dd"T"hh24:mi:ss') as eop,
                TO_CHAR(min(co.sos),'yyyy-mm-dd"T"hh24:mi:ss') as sos,
                TO_CHAR(max(co.eos),'yyyy-mm-dd"T"hh24:mi:ss') as eos,
                case when min(nvl(co.deleted,0)) = 0 
                          then null
                     else TO_CHAR(max(nvl(co.delete_after_date,to_date('19000101','YYYYMMDD'))),'yyyy-mm-dd"T"hh24:mi:ss') 
                     end as deleteafterdate,                
                min(nvl(co.deleted,0)) as deleted,      
                max(co.priority) as priority,
                max(co.customer_id) as catalogtype,
                max(co.local_going_price) as local_going_price,
                o.localisation,
                '<xsl:value-of select="$source"/>' content_type
            from octl o
            inner join LOCALE_LANGUAGE ll on o.LOCALisation = ll.LOCALE
                and o.content_type='<xsl:value-of select="$source"/>'
                and o.localisation='<xsl:value-of select="$locale"/>'
                and o.status != 'PLACEHOLDER'
            inner join catalog_objects co on
                co.object_id=o.object_id
                and co.COUNTRY=ll.country
            inner join CUSTOMER_LOCALE_EXPORT cle on
                cle.ctn=o.object_id
                and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
                and cle.locale=o.localisation
                and cle.flag=1
            inner join channels ch on
                ch.name = cle.CUSTOMER_ID  
            inner join channel_catalogs cc
                 on cc.customer_id = ch.id            
            where ch.catalog='ALL' or co.CUSTOMER_ID = cc.catalog_type
            group by o.object_id, ll.language, o.status, o.localisation
          ) sub1
          inner join octl o
                on o.object_id = sub1.object_id
                and o.localisation = sub1.localisation
                and o.content_type = sub1.content_type
          left outer join octl o2
                 on o2.object_id = o.object_id
                and o2.content_type = 'PMT_Refs' 
                and o2.status = 'Final Published' 
          order by sub1.object_ID
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
</xsl:stylesheet>
