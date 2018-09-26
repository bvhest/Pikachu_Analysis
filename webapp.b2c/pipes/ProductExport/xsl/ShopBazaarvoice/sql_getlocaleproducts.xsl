<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">

  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:param name="exportdate"/>
  
   <!-- xsl:variable name="DoctypesDoc" select="document(../../../cmc2/xml/doctypeAttributes)"/ -->  
  <xsl:variable name="fulldate"><xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/>T<xsl:value-of select="substring($exportdate,10,2)"/>:<xsl:value-of select="substring($exportdate,12,2)"/>:00</xsl:variable> 

  <xsl:template match="/">
    <root>
      <sql:execute-query>
        <sql:query name="catg-tree">
          select o.object_id ID
               , o.masterlastmodified_ts MASTERLASTMODIFIED
               , o.lastmodified_ts LASTMODIFIED
               , o.localisation locale
               , o.DATA 
          from CUSTOMER_LOCALE_EXPORT cle 
  
          inner join octl o 
             on o.content_type = 'Categorization'
            and o.object_id = cle.ctn
            and o.localisation = cle.locale
  
          inner join channels c 
             on c.NAME = '<xsl:value-of select="$channel"/>' 
          
          inner join channel_catalogs cc
             on cc.customer_id  = c.ID
            and cc.locale =  cle.locale
            and cc.enabled = 1
          
          where cle.customer_id='<xsl:value-of select="$channel"/>'
            and cle.locale = '<xsl:value-of select="$locale"/>'
            and cle.flag = 1
            <!-- and rownum &lt; 2 -->
            order by cle.ctn
        </sql:query>
      </sql:execute-query>
    
      <sql:execute-query>
        <sql:query name="product">
          select distinct 
                 o.object_id
               , TO_CHAR(mv.sop,'yyyy-mm-dd"T"hh24:mi:ss') as sop
               , TO_CHAR(mv.eop,'yyyy-mm-dd"T"hh24:mi:ss') as eop
               , TO_CHAR(mv.sos,'yyyy-mm-dd"T"hh24:mi:ss') as sos
               , TO_CHAR(mv.eos,'yyyy-mm-dd"T"hh24:mi:ss') as eos
               , o.masterlastmodified_ts MASTERLASTMODIFIED
               , o.lastmodified_ts LASTMODIFIED
               , o.localisation locale
			   , mv.deleted deleted
               , o.DATA 			   
          from CUSTOMER_LOCALE_EXPORT cle 
  
          inner join octl o
          <xsl:choose>
            <xsl:when test="$locale = 'master_global'">
             on o.content_type = 'PMT_Master'</xsl:when>
            <xsl:otherwise>
             on o.content_type = 'PMT'
            </xsl:otherwise>
          </xsl:choose> 
            and o.object_id = cle.ctn
            and o.localisation = cle.locale
          
          inner join channels c 
             on c.NAME = '<xsl:value-of select="$channel"/>' 
        
          inner join channel_catalogs cc
             on cc.customer_id  = c.ID
            and cc.locale =  cle.locale
            and cc.enabled = 1
          
          inner join mv_co_object_id mv
             on mv.object_id = o.object_id
            --and mv.deleted = 0
  	
          where cle.customer_id='<xsl:value-of select="$channel"/>'
            and cle.locale = '<xsl:value-of select="$locale"/>'
            and cle.flag = 1
        order by object_id
        </sql:query>
      </sql:execute-query>
      <sql:execute-query>
        <sql:query name="product-catg">
          select oc.object_id, ll.locale, ll.islatin
               , c.catalogcode, c.groupcode, c.categorycode categorycode, c.subcategorycode subcategorycode 
               , c.groupname mastergroupname, c.categoryname mastercategoryname, c.subcategoryname mastersubcategoryname 
               , lc.groupname, lc.categoryname, lc.subcategoryname
               
          from localized_subcat lc
          
          inner join categorization c
             on c.catalogcode=lc.catalogcode
            and c.groupcode=lc.groupcode
            and c.categorycode=lc.categorycode
            and c.subcategorycode=lc.subcategorycode
             
          inner join vw_object_categorization oc 
             on oc.subcategory = lc.subcategorycode  
            and oc.catalogcode = lc.catalogcode        
          
          inner join customer_locale_export cle
             on cle.ctn = oc.object_id
            and cle.locale = lc.locale

          inner join locale_language ll
             on ll.locale='<xsl:value-of select="$locale"/>'
             
          inner join catalog_objects co
             on co.object_id=cle.ctn
            and co.customer_id=oc.catalogcode
            and co.country=ll.country_code
            --and co.deleted=0
            
          where oc.catalogcode in ('SHOPPUB','SHOPEMP','SHOPEXP','SHOPPAR')
            and lc.locale = '<xsl:value-of select="$locale"/>'
            and cle.customer_id='<xsl:value-of select="$channel"/>'
            and cle.flag = 1
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
