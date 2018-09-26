<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">

  <xsl:param name="channel"/>
  <xsl:param name="batchnumber"/>
  <xsl:param name="locale"/>
  <xsl:param name="delta"/>
  <xsl:param name="masterlocale"/>
   
  <xsl:template match="/">
    <Products>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="product">
         select  o.object_id ID
                ,ll.LOCALE
                ,ll.LANGUAGE
                ,TO_CHAR(co.sop,'yyyy-mm-dd"T"hh24:mi:ss') as sop
                ,TO_CHAR(co.somp,'yyyy-mm-dd"T"hh24:mi:ss') as somp
                ,TO_CHAR(co.eop,'yyyy-mm-dd"T"hh24:mi:ss') as eop
                ,decode(co.buy_online, 1, 'true', 0, 'false') as buy_online
                ,co.priority as priority
                ,co.local_going_price as local_going_price
                ,decode(co.deleted, 1, 'true', 0, 'false') as deleted
                ,TO_CHAR(co.delete_after_date,'yyyy-mm-dd"T"hh24:mi:ss') as delete_after_date
                ,decode(omd.division, 'CE', 'PCE', 'DAP', 'DAP','Lighting','PCE') as division
                ,co.customer_id as catalog
                ,nvl(cle.lasttransmit,to_date('1900-01-01','YYYY-MM-DD')) as lastexportdate
                ,o.data as data
                ,'dummy' as asset_data
            
            from customer_locale_export cle
            
            inner join octl o 
               on o.content_type='<xsl:value-of select="if ($masterlocale != '') then 'PMT_Localised' else 'PMT'"/>'
              and o.object_id=cle.ctn
            <xsl:choose>
              <xsl:when test="$masterlocale != ''">
                and o.localisation='master_<xsl:value-of select="substring($locale,4)"/>'
              </xsl:when>
              <xsl:otherwise>
                and o.localisation=cle.locale 
              </xsl:otherwise>
            </xsl:choose>
            
            inner join object_master_data omd 
               on omd.object_id = o.object_id
            
            inner join locale_language ll 
               on ll.locale = cle.locale
               
            inner join channels c 
               on c.name = cle.customer_id
               
            inner join channel_catalogs cc 
               on cc.customer_id = c.id
              and cc.locale = cle.locale
              and cc.division = omd.division
              and cc.brand = omd.brand
              and cc.enabled=1
            <xsl:if test="$masterlocale != ''">
              and cc.masterlocaleenabled=1
            </xsl:if>
            inner join catalog_objects co 
               on co.object_id = cle.ctn 
              and co.country = ll.country
              and co.customer_id = cc.catalog_type 
              and (co.eop > sysdate - 100 or co.LASTMODIFIED > sysdate - 100)
          --  and exists (select 1 from vw_object_categorization oc where oc.object_id = cle.ctn and  oc.catalogcode = co.customer_id)
           
            where cle.customer_id='<xsl:value-of select="$channel"/>'
              and cle.locale='<xsl:value-of select="$locale"/>'
            <xsl:choose>
              <xsl:when test="$delta='y'">and cle.flag=1</xsl:when>
              <xsl:otherwise>and cle.batch = <xsl:value-of select="$batchnumber"/> </xsl:otherwise>
            </xsl:choose>
          </sql:query>
        <sql:execute-query>
          <sql:query name="cat">
               select c.groupcode, c.groupname, c.categorycode, c.categoryname, c.subcategorycode, c.subcategoryname
                 from categorization c
           inner join vw_object_categorization oc 
                   on oc.subcategory = c.subcategorycode  
                  and oc.catalogcode = c.catalogcode        
                where oc.object_id   = '<sql:ancestor-value name="id" level="1"/>'
                  and oc.catalogcode = '<sql:ancestor-value name="catalog" level="1"/>'
          </sql:query>
        </sql:execute-query>
        </sql:execute-query>
    </Products>
  </xsl:template>
</xsl:stylesheet>
