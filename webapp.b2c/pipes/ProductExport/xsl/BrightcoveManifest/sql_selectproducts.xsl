<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  exclude-result-prefixes="sql xsl">

  <xsl:param name="channel" />
  <xsl:param name="country" />
  <xsl:param name="locale" />
  <xsl:param name="exportdate" />
  <xsl:param name="selectall" select="'no'" />
  <xsl:param name="selectsubcat" select="'no'" />
  <xsl:param name="kvpdocpath" />
  <!-- new content type parameter needed for ATG PCT export -->
  <xsl:param name="sourceCT" />

  <xsl:variable name="q">
    <xsl:text>'</xsl:text>
  </xsl:variable>

  <xsl:variable name="doctypes" select="document('../../../../cmc2/xml/doctype_attributes.xml')/doctypes" />
  <xsl:variable name="fulldate">
    <xsl:value-of select="substring($exportdate,1,4)" />
    <xsl:text>-</xsl:text>
    <xsl:value-of select="substring($exportdate,5,2)" />
    <xsl:text>-</xsl:text>
    <xsl:value-of select="substring($exportdate,7,2)" />
    <xsl:text>T</xsl:text>
    <xsl:value-of select="substring($exportdate,10,2)" />
    <xsl:text>:</xsl:text>
    <xsl:value-of select="substring($exportdate,12,2)" />
    <xsl:text>:00</xsl:text>
  </xsl:variable>

  <xsl:variable name="doctype-channel" select="$channel" />

  <xsl:template match="/">
    <xsl:variable name="brightcoveDoctypes">
      <xsl:value-of select="'('" />
      <xsl:for-each select="$doctypes/doctype[@BrightcoveAssets='yes'][@suffix=('mp4','flv')]/@code">
        <xsl:if test="position() != 1">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:value-of select="concat($q,.,$q)" />
      </xsl:for-each>
      <xsl:value-of select="')'" />
    </xsl:variable>
    <root>    
      <!-- clear all-->
      <sql:execute-query>
        <sql:query name="clear-flags">
          update customer_locale_export
          set flag=0
          where customer_id='<xsl:value-of select="$channel" />'
          and locale='<xsl:value-of select="$locale" />'
          and flag != 0
        </sql:query>
      </sql:execute-query>
      
      <!-- Insert new products for product related assets (AssetList) -->
      <sql:execute-query>
        <sql:query name="insert-new-products-al">
          insert into customer_locale_export(customer_id, locale, ctn, flag)
          select distinct
            '<xsl:value-of select="$channel" />'
          , o.localisation
          , o.object_id
          , 0
          from OCTL o
          
          inner join CHANNELS ch
             on ch.name = '<xsl:value-of select="$channel" />'
          
          inner join channel_catalogs cc
             on ch.id = cc.customer_id
            and cc.locale = o.localisation
            and cc.ENABLED = 1
          
          left outer join CUSTOMER_LOCALE_EXPORT cle
            on cle.ctn = o.object_ID
           and cle.locale = cc.locale
           and cle.CUSTOMER_ID= ch.name
          
          inner join asset_lists al 
             on al.object_id = o.object_id 
            and al.doctype in <xsl:value-of select="$brightcoveDoctypes" />
            and al.locale = o.localisation 
            and al.md5 is not null
          <xsl:choose>
            <xsl:when test="$locale = 'master_global'">
              where cle.CUSTOMER_ID is NULL
                and o.localisation='<xsl:value-of select="$locale" />'
                and o.content_type = 'PMT_Master'
                and o.status in ('Preliminary Published','Final Published')
            </xsl:when>
            <xsl:otherwise>
              inner join mv_co_object_id_country co
                 on co.object_id = o.object_id
                and co.country = '<xsl:value-of select="substring-after($locale,'_')" />'
                and co.deleted = 0
                and co.eop &gt; sysdate
              
              where cle.CUSTOMER_ID is NULL
                and o.localisation='<xsl:value-of select="$locale" />'
                and o.content_type = 'PMT'
                and o.status = 'Final Published'
            </xsl:otherwise>
          </xsl:choose>
        </sql:query>
      </sql:execute-query>
    
    	<!-- Insert new products for object related assets (ObjectAssetList) -->
      <sql:execute-query>
        <sql:query name="insert-new-products-oal">
          insert into customer_locale_export(customer_id, locale, ctn, flag)
          select distinct
            '<xsl:value-of select="$channel" />'
          , o.localisation
          , o.object_id
          , 0
          
          from OCTL o
          
          inner join CHANNELS ch
             on ch.name = '<xsl:value-of select="$channel" />'

          inner join channel_catalogs cc
             on ch.id = cc.customer_id
            and cc.locale = o.localisation
            and cc.ENABLED = 1
          
          left outer join CUSTOMER_LOCALE_EXPORT cle
            on cle.ctn = o.object_ID
           and cle.locale = cc.locale
           and cle.CUSTOMER_ID= ch.name
          
          inner join octl_relations r 
             on r.output_content_type = o.content_type 
            and r.output_object_id = o.object_id 
            and r.output_localisation = o.localisation 
            and r.input_content_type = 'ObjectAssetList' 
            and r.input_localisation = o.localisation
            
          inner join asset_lists al 
             on al.object_id = r.input_object_id 
            and al.locale = r.input_localisation 
            and al.doctype in <xsl:value-of select="$brightcoveDoctypes" />
            and al.md5 is not null
          <xsl:choose>
            <xsl:when test="$locale = 'master_global'">
              where cle.CUSTOMER_ID is NULL
                and o.localisation='<xsl:value-of select="$locale" />'
                and o.content_type = 'PMT_Master'
                and o.status in ('Preliminary Published','Final Published')
            </xsl:when>
            <xsl:otherwise>
              inner join mv_co_object_id_country co
                 on co.object_id = o.object_id
                and co.country = '<xsl:value-of select="substring-after($locale,'_')" />'
                and co.deleted = 0
                and co.eop &gt; sysdate
              
              where cle.CUSTOMER_ID is NULL
                and o.localisation='<xsl:value-of select="$locale" />'
                and o.content_type = 'PMT'
                and o.status = 'Final Published'
            </xsl:otherwise>
          </xsl:choose>
        </sql:query>
      </sql:execute-query>
      <!--  -->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="flag-products">
          update CUSTOMER_LOCALE_EXPORT
          set flag=1
          where locale = '<xsl:value-of select="$locale" />'
            and customer_id = '<xsl:value-of select="$channel" />'
            and ctn in (
              select distinct cle.ctn
              from octl o
          
              inner join channels c
                 on c.name = '<xsl:value-of select="$channel" />'

              inner join channel_catalogs cc
                 on cc.customer_id = c.ID
                and cc.locale = o.localisation
                and cc.enabled = 1
                
              inner join customer_locale_export cle
                 on cle.locale = cc.locale
                and cle.customer_id = c.name
                and cle.ctn = o.object_id
              <xsl:if test="$selectall != 'yes'">
                and nvl(cle.lasttransmit,to_date('1900-01-01','YYYY-MM-DD')) &lt; o.lastmodified_ts
              </xsl:if>
              
              inner join vw_object_categorization oc
                 on oc.object_id = o.object_id
                and oc.catalogcode = cc.catalog_type
          
              inner join categorization c
                 on oc.subcategory = c.subcategorycode
                and c.catalogcode = oc.catalogcode
              <xsl:choose>
                <xsl:when test="$locale = 'master_global'">
                  where o.localisation='<xsl:value-of select="$locale" />'
                    and o.content_type = 'PMT_Master'
                    and o.status in ('Preliminary Published','Final Published')
                </xsl:when>
                <xsl:otherwise>
                  inner join mv_co_object_id_country co
                     on co.object_id = o.object_id
                    and co.country = '<xsl:value-of select="substring-after($locale,'_')" />'
                    and co.deleted = 0
                    and co.eop &gt; sysdate
                  
                  where o.localisation='<xsl:value-of select="$locale" />'
                    and o.content_type = 'PMT'
                    and o.status = 'Final Published'
                </xsl:otherwise>
              </xsl:choose>
          )
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>

</xsl:stylesheet>