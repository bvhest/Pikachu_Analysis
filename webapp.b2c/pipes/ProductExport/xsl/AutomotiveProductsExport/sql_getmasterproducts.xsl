<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:param name="exportdate"/>
  <!-- new content type parameter needed for ATG PCT export -->
  <xsl:param name="sourceCT"/>
  
  <!-- Secure URL implementation -->
  <xsl:param name="secureURL"/>  
  <xsl:param name="secureURL-minRange"/>
  <xsl:param name="secureURL-maxRange"/>
    <xsl:variable name="minRange" select="if ($secureURL-minRange != '') then $secureURL-minRange else '7'" />	
	<xsl:variable name="maxRange" select="if ($secureURL-maxRange != '') then $secureURL-maxRange else '45'" />
	
  <!-- -->
  <xsl:variable name="fulldate">
  <xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/>T<xsl:value-of select="substring($exportdate,10,2)"/>:<xsl:value-of select="substring($exportdate,12,2)"/>:00</xsl:variable>
  <!-- -->
  <xsl:template match="/">
    <!-- default = PMT, otherwise select from sourceCT variabele.
     +-->
    <xsl:variable name="source_master" select="if ($sourceCT!='') then concat($sourceCT,'_Master') else 'PMT_Master'" />

    <Products>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="product">
       select sub1.object_id id
            , 'ENG' as language
            , sub1.sop
            , sub1.eop
            , sub1.sos
            , sub1.eos
            , sub1.priority
            , sub1.deleted
            , sub1.content_type
            , decode(sub1.deleteafterdate,'1900-01-01T00:00:00','',sub1.deleteafterdate) deleteafterdate,
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
        from ( select co.object_id
                     , TO_CHAR(min(co.sop),'yyyy-mm-dd"T"hh24:mi:ss') as sop
                     , TO_CHAR(max(co.eop),'yyyy-mm-dd"T"hh24:mi:ss') as eop
                     , TO_CHAR(min(co.sos),'yyyy-mm-dd"T"hh24:mi:ss') as sos
                     , TO_CHAR(max(co.eos),'yyyy-mm-dd"T"hh24:mi:ss') as eos
                     , case when min(nvl(co.deleted,0)) = 0
                                 then null
                            else TO_CHAR(max(nvl(co.delete_after_date,to_date('19000101','YYYYMMDD'))),'yyyy-mm-dd"T"hh24:mi:ss')
                            end as deleteafterdate
                     , min(nvl(co.deleted,0)) as deleted
                     , max(co.priority) as priority
                     ,max(co.customer_id) as catalogtype
                     , '<xsl:value-of select="$source_master"/>' content_type
                     , o.localisation
                  from octl o 
            inner join catalog_objects co 
                    on co.object_id=o.object_id
                   and o.content_type = '<xsl:value-of select="$source_master"/>'
<xsl:if test="$source_master != 'PCT_Master'">               
                   and o.status = 'Final Published'
</xsl:if>     
            inner join vw_object_categorization oc
                 on oc.object_id    = co.object_id
            inner join categorization c
                  on oc.subcategory=c.subcategorycode 
                  and oc.catalogcode=c.catalogcode
                  and c.groupcode='AUTOMOTIVE_GR'
				  and oc.deleted=0
            inner join CUSTOMER_LOCALE_EXPORT cle on
                cle.ctn=o.object_id
                and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
                and cle.locale = 'MASTER'
                and cle.flag=1            
            inner join channels ch on
                ch.name = cle.CUSTOMER_ID      
            inner join channel_catalogs cc
                 on cc.customer_id = ch.id            
            where ch.catalog='ALL' or co.CUSTOMER_ID = cc.catalog_type
			and c.catalogcode=cc.catalog_type
            group by co.object_id,o.localisation
          ) sub1
     inner join octl o
             on o.object_id = sub1.object_id
            and o.localisation = sub1.localisation
            and o.content_type = sub1.content_type
       order by sub1.object_id
          </sql:query>
        <sql:execute-query>
          <sql:query name="cat">
                  select distinct c.groupcode, c.groupname, c.categorycode, c.categoryname, c.subcategorycode, c.subcategoryname, c.catalogcode, c.bgroupname, c.bgroupcode
                    from categorization c
             inner join vw_object_categorization oc 
                      on oc.subcategory = c.subcategorycode  
                     and oc.catalogcode = c.catalogcode 
                     and c.groupcode='AUTOMOTIVE_GR'					 
                   where oc.object_id   = '<sql:ancestor-value name="id" level="1"/>'
                     and oc.catalogcode = '<sql:ancestor-value name="categorization_catalogtype" level="1"/>'
                     and rownum = 1
                  UNION  
                  select distinct c.groupcode, c.groupname, c.categorycode, c.categoryname, c.subcategorycode, c.subcategoryname, c.catalogcode, c.bgroupname, c.bgroupcode
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
