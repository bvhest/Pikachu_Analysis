<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                exclude-result-prefixes="sql xsl">
  <!--
  FileName    :  sql_getmasterproducts.xsl
  Author      :  CJ
  Description :  Fetch WebcollageProducts information from DB and fileStore
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
    <!--  <xsl:variable name="source_master" select="if ($sourceCT!='') then concat($sourceCT,'_Master') else 'PMT_Master'" /> -->

	 <xsl:variable name="source_master" select="PMT_Master" />

    <Products>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="product">
       	 select cle.ctn id,
                  'ENG' as language,
                  cob.sop,
                  cob.eop,
                  cob.sos,
                  cob.eos,
                  cob.priority,
                  cob.delete_after_date,
                  cob.DELETED,
                  o.CONTENT_TYPE,
                  o.localisation,
                  omd.PRODUCT_TYPE,
                  cob.CUSTOMER_ID as catalogtype,
                  cob.LOCAL_GOING_PRICE,
                  cob.CUSTOMER_ID as categorization_catalogtype,
                  o.DATA,
                  o.DATA wrf,
                  omd.product_type
                from CUSTOMER_LOCALE_EXPORT cle
                  
                  inner join catalog_objects cob
                  on cob.object_id=cle.ctn
                  <!-- and cob.customer_id='CARE' -->
                  and cob.catalog_id in ('ProductMasterDataCatalog','CARE_Master_Catalog')
                  and  cle.flag=1
                  and cle.locale='MASTER'
                  and cle.customer_id='<xsl:value-of select="$channel"/>'

	   <!-- inner join catalog_objects co
             on co.object_id = o.object_id
            on (co.catalog_id='ProductMasterDataCatalog' or co.catalog_id='CARE_Master_Catalog') -->


                  inner join octl o
                  on o.object_id=cle.ctn
                  and o.LOCALISATION='master_global'
                  and o.CONTENT_TYPE='PMT_Master'

                 inner join object_master_data omd
                  on o.object_id = omd.object_id   
	</sql:query>
        <sql:execute-query>
          <sql:query name="cat">
                  select distinct c.groupcode, c.groupname, c.categorycode, c.categoryname, c.subcategorycode, c.subcategoryname, c.catalogcode, c.bgroupname, c.bgroupcode
                    from categorization c
              inner join vw_object_categorization oc 
                      on oc.subcategory = c.subcategorycode  
                     and oc.catalogcode = c.catalogcode        
                   where oc.object_id   = '<sql:ancestor-value name="id" level="1"/>'
                     and oc.catalogcode = 'MASTER'
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
