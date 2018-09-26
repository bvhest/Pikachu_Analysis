<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="channel"/>
  <xsl:param name="country"/>

  <xsl:template match="/">
  <root>
    <sql:execute-query>
      <sql:query name="get-catalog-data">
        <xsl:choose>
          <xsl:when test="$channel='CareAtgMerchandise'">
            select 'CARE' as catalogtype
                 , co.object_id
                 , to_char(co.sop,'yyyy-mm-dd"T"hh24:mi:ss') sop
                 , to_char(co.eop,'yyyy-mm-dd"T"hh24:mi:ss') eop
              from mv_cat_obj_country co
             where co.country= '<xsl:value-of select="$country"/>'
               and co.catalog = 'CARE' 
          </xsl:when>
          <xsl:otherwise>
            <!-- Export only according to channel_catalogs configuration -->
            select cc.catalog_type as catalogtype
                 , co.object_id
                 , to_char(co.sop,'yyyy-mm-dd"T"hh24:mi:ss') sop
                 , to_char(co.eop,'yyyy-mm-dd"T"hh24:mi:ss') eop
              from mv_cat_obj_country co
             inner join channels c
                on c.name='<xsl:value-of select="$channel"/>'
             inner join channel_catalogs cc
                on cc.customer_id=c.id
               and cc.catalog_type=co.catalog
               and substr(cc.locale,4)='<xsl:value-of select="$country"/>'
             inner join object_master_data omd
                on omd.object_id=co.object_id
               and (cc.division='ALL' or omd.division=cc.division)
               and (cc.brand='ALL' or omd.brand=cc.brand)
             where co.country='<xsl:value-of select="$country"/>'
               and cc.enabled=1
               and cc.masterlocaleenabled=1
          </xsl:otherwise>
        </xsl:choose>
      </sql:query>	  
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>