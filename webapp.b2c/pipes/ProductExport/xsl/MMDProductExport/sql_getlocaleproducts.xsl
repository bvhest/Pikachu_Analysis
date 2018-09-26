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
    select cle.ctn id,
		  ll.LANGUAGE,
		  cob.sop, 
		  cob.eop,
		  cob.sos,
		  cob.eos,
		  cob.priority,
		  cob.DELETED,
		  o.CONTENT_TYPE,
		  o.localisation,
		  cob.CUSTOMER_ID as catalogtype,
		  cob.LOCAL_GOING_PRICE,
		  cob.CUSTOMER_ID as categorization_catalogtype,
		  o.DATA

		from CUSTOMER_LOCALE_EXPORT cle 
		  inner join LOCALE_LANGUAGE ll
		    on cle.LOCALE=ll.LOCALE
		  and cle.flag=1
		  and cle.locale='<xsl:value-of select="$locale"/>'
		  and cle.customer_id='<xsl:value-of select="$channel"/>'
		  
		  inner join catalog_objects cob
		  on cob.object_id=cle.ctn
		  and cob.country=ll.country
		  and cob.customer_id='CONSUMER'
		  and cob.deleted=0
		  and sop &lt; sysdate
		  and eop &gt; sysdate
		  
		  inner join octl o
		  on o.object_id=cle.ctn
		  and o.LOCALISATION=cle.LOCALE
		  and o.CONTENT_TYPE in ('PMT')

		  inner join object_categorization oc
                on  oc.object_id=o.object_id
                and oc.deleted = 0
		  and oc.catalogcode='CONSUMER'

       	  inner join localized_subcat ls
                on ls.subcategorycode=oc.subcategory
                and ls.categorycode='MONITORS_CA'
		  and ls.subcategorycode in ('HOME_LCD_MONITORS_SU','OFFICE_LCD_MONITORS_SU')
                and ls.LOCALE = '<xsl:value-of select="$locale"/>'
                and ls.catalogcode = oc.CATALOGCODE
		  
		  inner join object_master_data omd
		  on o.object_id = omd.object_id
		  
		  and omd.PRODUCT_TYPE in
		  (select product_type from 
		  channels ch 
		  inner join channel_catalogs cc
		  on cc.customer_id = ch.id
		  and ch.name = '<xsl:value-of select="$channel"/>'
		  and cc.locale='<xsl:value-of select="$locale"/>'  and cc.catalog_type='CONSUMER')  
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
