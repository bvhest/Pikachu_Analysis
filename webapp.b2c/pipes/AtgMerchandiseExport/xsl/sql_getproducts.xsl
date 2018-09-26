<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    exclude-result-prefixes="sql xsl">

  <xsl:param name="channel" />
  <xsl:param name="locale" />
  <xsl:param name="contentType" />

  <xsl:template match="/">
    <xsl:variable name="wsf_ct">
      <xsl:choose>
        <xsl:when test="$channel=('AtgMerchandise','ShopAtgMerchandise')">
          <xsl:text>WebSiteFiltering</xsl:text>
        </xsl:when>
        <xsl:when test="$channel='CareAtgMerchandise'">
          <xsl:text></xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>WebSiteFiltering_Translated</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="wsf_locale">
      <xsl:choose>
        <xsl:when test="$channel=('AtgMerchandise','ShopAtgMerchandise')">
          <xsl:text>master_global</xsl:text>
        </xsl:when>
        <xsl:when test="$channel='CareAtgMerchandise'">
          <xsl:text></xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$locale" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <Products>
      <sql:execute-query>
        <sql:query name="product">
          select o.object_id id
          ,TO_CHAR (o.lastmodified_ts, 'yyyy-mm-dd"T"hh24:mi:ss') AS lm
          ,TO_CHAR (o.masterlastmodified_ts, 'yyyy-mm-dd"T"hh24:mi:ss') AS mlm
          ,'<xsl:value-of select="$locale" />' as locale
          ,'<xsl:value-of select="substring-after($locale,'_')" />' as COUNTRY
          ,TO_CHAR(co.sop,'yyyy-mm-dd"T"hh24:mi:ss') as sop
          ,TO_CHAR(co.eop,'yyyy-mm-dd"T"hh24:mi:ss') as eop
          ,decode(co.deleted, 1, 'true', 0, 'false') as deleted
          ,TO_CHAR(co.delete_after_date,'yyyy-mm-dd"T"hh24:mi:ss') as delete_after_date
          ,cc.catalog_type catalog
          ,cc.catalog_type  categorization_catalogtype      
          ,nvl(cle.lasttransmit,to_date('1900-01-01','YYYY-MM-DD')) as lastexportdate
        <xsl:if test="$wsf_ct != '' and $wsf_locale != ''">
          ,wsf.data as fans_data
        </xsl:if>

          from CUSTOMER_LOCALE_EXPORT cle
          
          inner join octl o
             on o.content_type='<xsl:value-of select="$contentType" />'
            and o.localisation = cle.locale
            and o.object_id=cle.ctn
            
          inner join channels c 
             on c.name = '<xsl:value-of select="$channel" />'
             
          inner join channel_catalogs cc 
             on cc.customer_id = c.id 
            and cc.locale= cle.locale 
          
          <xsl:choose>
            <xsl:when test="$locale='master_global' ">
              inner join mv_cat_obj co
                 on co.object_id = o.object_id 
                and co.catalog = cc.catalog_type
            </xsl:when>
            <xsl:otherwise>
              inner join mv_cat_obj_country co
                 on co.object_id = o.object_id 
                and co.country = '<xsl:value-of select="substring-after($locale,'_')" />'
                and co.catalog = cc.catalog_type
           </xsl:otherwise>
          </xsl:choose> 
		  <!-- Added to avoid duplicates when multiple brands available start -->
		  <xsl:if test="$channel='AtgMerchandise'">
          inner join object_master_data omd
             on omd.object_id      = o.object_id
            and (omd.division      = cc.division 
              or cc.division       = 'ALL'
                )
            and (omd.brand         = cc.brand 
              or cc.brand          = 'ALL'
                )
        </xsl:if>
		<!-- Added to avoid duplicates when multiple brands available end -->
          <xsl:if test="$wsf_ct != '' and $wsf_locale != ''">
            left outer join octl wsf
              on wsf.content_type = '<xsl:value-of select="$wsf_ct" />'
             and wsf.localisation = '<xsl:value-of select="$wsf_locale" />'
             and wsf.object_id = o.object_id
          </xsl:if>
          where cle.CUSTOMER_ID='<xsl:value-of select="$channel" />'
            and cle.locale='<xsl:value-of select="$locale" />'
            and cle.flag=1

          order by o.object_id
        </sql:query>
        <sql:execute-query>
          <sql:query name="cat">
               select c.groupcode, c.groupname, c.categorycode, c.categoryname, c.subcategorycode, c.subcategoryname
                 from categorization c
           inner join vw_object_categorization oc 
                   on oc.subcategory = c.subcategorycode  
                  and oc.catalogcode = c.catalogcode        
                where oc.object_id   = '<sql:ancestor-value name="id" level="1"/>'
                  and oc.catalogcode = '<sql:ancestor-value name="categorization_catalogtype" level="1"/>'
          </sql:query>
        </sql:execute-query>
      </sql:execute-query>
    </Products>
  </xsl:template>
</xsl:stylesheet>
