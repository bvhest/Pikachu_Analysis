<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:param name="channel"/>
<xsl:param name="locale"/>
<xsl:param name="exportdate"/>
<xsl:param name="sourceCT"/>
<!-- -->
<xsl:template match="/">
  <!-- default = PMT_Master, otherwise select from sourceCT variabele -->
  <xsl:variable name="source_master" select="if ($sourceCT!='') then concat($sourceCT,'_Master') else 'PMT_Master'"/>

  <xsl:element name="Products">
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="product">
      select o.object_id id
          , 'PMT_Master' content_type
          , 'ENG' as language
          , 'CONSUMER' categorization_catalogtype
          , o.data
      from octl o 

      inner join CUSTOMER_LOCALE_EXPORT cle
         on cle.ctn = o.object_id
        and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
        and cle.locale = 'MASTER'
        and cle.flag=1        
      where o.content_type = '<xsl:value-of select="$source_master"/>'
        and o.localisation = 'master_global'                
      </sql:query>
      <sql:execute-query>
        <sql:query name="cat">
                    select distinct c.groupcode, c.groupname, c.categorycode, c.categoryname, c.subcategorycode, c.subcategoryname, c.catalogcode, c.bgroupname, c.bgroupcode
                      from categorization c
                inner join vw_object_categorization oc 
                        on oc.subcategory = c.subcategorycode  
                       and oc.catalogcode = c.catalogcode        
                     where oc.object_id   = '<sql:ancestor-value name="id" level="1"/>'
                       and oc.catalogcode = '<sql:ancestor-value name="categorization_catalogtype" level="1"/>'
                       --and rownum = 1
                    UNION  
                    select distinct c.groupcode, c.groupname, c.categorycode, c.categoryname, c.subcategorycode, c.subcategoryname, c.catalogcode, c.bgroupname, c.bgroupcode
                      from categorization c
                inner join vw_object_categorization oc 
                        on oc.subcategory = c.subcategorycode  
                       and oc.catalogcode = c.catalogcode        
                     where oc.object_id   = '<sql:ancestor-value name="id" level="1"/>'
                       and oc.catalogcode = 'ProductTree'
                       --and rownum = 1
        </sql:query>
      </sql:execute-query>
    </sql:execute-query>
  </xsl:element>
</xsl:template>
<!-- -->
</xsl:stylesheet>
