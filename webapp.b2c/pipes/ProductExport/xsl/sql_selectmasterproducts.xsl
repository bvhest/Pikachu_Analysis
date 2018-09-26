<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="channel"/>
  <xsl:param name="exportdate"/>
  <xsl:param name="selectall">no</xsl:param>
  <xsl:param name="selectsubcat">no</xsl:param>
  <xsl:param name="kvpdocpath"/>
  <!-- new content type parameter needed for ATG PCT export -->
  <xsl:param name="sourceCT"/>
  <xsl:param name="secureURL"/>

  <!-- -->
  <xsl:variable name="fulldate"><xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/>T<xsl:value-of select="substring($exportdate,10,2)"/>:<xsl:value-of select="substring($exportdate,12,2)"/>:00</xsl:variable>
  <xsl:variable name="kvpDoc" select="if(doc-available(concat('../',$kvpdocpath))) then doc(concat('../',$kvpdocpath)) else ()"/>
  <!-- -->
  <xsl:template match="/">
    <root>
      <!-- clear all-->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
          update customer_locale_export
             set flag=0
           where customer_id='<xsl:value-of select="$channel"/>'
             and locale='MASTER'
             and flag != 0
        </sql:query>
      </sql:execute-query>
      <!-- -->
      <xsl:choose>
        <xsl:when test="$selectsubcat = 'yes'">
          <xsl:call-template name="selectsubcats"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="select">
            <xsl:with-param name="subcat" select="''"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template name="selectsubcats">
    <xsl:for-each select="//subcat">
      <xsl:call-template name="select">
        <xsl:with-param name="subcat" select="."/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <!-- -->
  <xsl:template name="select">
    <!-- default = PMT, otherwise select from sourceCT variabele.
     +-->
    <xsl:variable name="source" select="if ($sourceCT!='') then $sourceCT else 'PMT'" />

    <xsl:param name="subcat"/>
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        insert into customer_locale_export(customer_id, locale, ctn, flag)
             select distinct
                      '<xsl:value-of select="$channel"/>'
                    , 'MASTER'
                    , o.object_id
                    , 0
               from OCTL o
<xsl:if test="$subcat != '' and string-length($subcat) gt 0">
         inner join vw_object_categorization oc
                 on oc.object_id = o.object_id
                and oc.subcategory = '<xsl:value-of select="."/>'
                and oc.source != 'ProductTree'
                and oc.catalogcode = 'MASTER'
</xsl:if>
         inner join CHANNELS ch
                 on ch.name =  '<xsl:value-of select="$channel"/>'
         inner join channel_catalogs cc
                 on ch.id = cc.customer_id
                and cc.locale = o.localisation
                and cc.enabled = 1
                and o.content_type = '<xsl:value-of select="$source"/>'
<xsl:if test="$source= 'PMT'">               
                and o.status = 'Final Published'
</xsl:if>               
         inner join catalog_objects co
                 on co.object_id = o.object_id
                and ((ch.catalog = 'ALL' and co.customer_id != 'CARE') or co.CUSTOMER_ID=cc.catalog_type)
                and co.COUNTRY= substr(cc.locale,4,2)
    left outer join CUSTOMER_LOCALE_EXPORT cle
                 on o.object_ID=cle.ctn
                and cle.locale='MASTER'
                and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
              where cle.CUSTOMER_ID is NULL
               -- and o.object_id like '42PFL%'
      </sql:query>
    </sql:execute-query>
    <!--  -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        update CUSTOMER_LOCALE_EXPORT CLE
           set flag=1
         where locale = 'MASTER'
           and customer_id = '<xsl:value-of select="$channel"/>'
           and ctn in
                    (select o.object_id
                       from octl o
<xsl:if test="$subcat != '' and string-length($subcat) gt 0">
                     inner join vw_object_categorization oc
                             on oc.object_id = o.object_id
                            and oc.subcategory = '<xsl:value-of select="."/>'
                            and oc.source != 'ProductTree'
                            and oc.catalogcode = 'MASTER'
</xsl:if>
                 inner join channels ch
                         on ch.name =  '<xsl:value-of select="$channel"/>'
                 inner join channel_catalogs cc
                         on ch.id = cc.customer_id
                        and cc.locale = o.localisation
                        and cc.enabled = 1
                        and o.content_type = '<xsl:value-of select="$source"/>'
<xsl:if test="$source= 'PMT'">               
                        and o.status = 'Final Published'
</xsl:if>               
                 inner join object_master_data omd
                         on o.object_id = omd.object_id
<xsl:if test="$source= 'PMT'">               
                        and omd.division = cc.division
</xsl:if>               
                        and omd.product_type = cc.product_type
<xsl:if test="$kvpDoc/keyvaluepairs">
                 inner join keyvaluepairs kvp
                         on omd.object_id = kvp.ctn
                 inner join (
<xsl:for-each select="$kvpDoc/keyvaluepairs/keyvaluepair">
select '<xsl:value-of select="key"/>' key<xsl:if test="value != ''">,'<xsl:value-of select="value"/>' value</xsl:if> from dual <xsl:if test="following-sibling::*"> union
</xsl:if></xsl:for-each>) keyvalues
                         on upper(kvp.key) = upper(keyvalues.key)
<xsl:if test="$kvpDoc/keyvaluepairs/keyvaluepair/value[text()!='']">                         
                        and upper(kvp.value) = upper(keyvalues.value)
</xsl:if>                        
</xsl:if>
                 inner join catalog_objects co
                         on co.object_id = o.object_id
                        and co.COUNTRY=substr(o.localisation,4,2)
                        and ((ch.catalog = 'ALL' and co.customer_id != 'CARE') or co.CUSTOMER_ID=cc.catalog_type)
<xsl:if test="$selectall != 'yes'">
  <xsl:choose>
    <xsl:when test="$subcat != '' and string-length($subcat) gt 0">
                        and co.eop &gt; sysdate
                        and co.deleted = 0
                        and co.country is not null
    </xsl:when>
    <xsl:otherwise>
                        and co.sop - ch.PUBLICATIONOFFSET_SOP &lt; sysdate
                        and co.eop + ch.PUBLICATIONOFFSET_EOP &gt; sysdate
    </xsl:otherwise>
  </xsl:choose>
                      
                      
    <xsl:choose>
    <xsl:when test="$secureURL = 'yes'">
    <!-- New condition for secureURL 'yes' -->
    
                           where( (cle.lasttransmit is null or o.lastmodified_ts &gt; cle.lasttransmit)
                           or 
                           (co.sop - 7 &gt;  cle.lasttransmit  and  sysdate &gt; co.sop -7)) 
    </xsl:when>
    <xsl:otherwise> 
    <!-- Existing conidtion -->
                            where (cle.lasttransmit is null or o.lastmodified_ts &gt; cle.lasttransmit)
    </xsl:otherwise>    
    </xsl:choose>                       
                      
</xsl:if>
                     )
      </sql:query>
    </sql:execute-query>
  </xsl:template>
</xsl:stylesheet>