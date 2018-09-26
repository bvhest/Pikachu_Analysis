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
    <xsl:variable name="source" select="if ($sourceCT!='') then $sourceCT else 'PMT_Master'" />

    <xsl:param name="subcat"/>
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        insert into customer_locale_export(customer_id, locale, ctn, flag)
          select distinct
                    '<xsl:value-of select="$channel"/>'
                  , 'MASTER'
                  , o.object_id
                  , 0
          from channels ch
          
          inner join channel_catalogs cc
             on cc.customer_id=ch.id
             
          inner join object_master_data omd
             on (cc.division='ALL' or omd.division=cc.division)
          
          inner join mv_cat_obj co
             on co.object_id = omd.object_id
            and (ch.catalog = 'ALL' or co.catalog=cc.catalog_type)
          
          inner join octl o
             on o.object_id=co.object_id

          left outer join CUSTOMER_LOCALE_EXPORT cle
               on o.object_ID=cle.ctn
              and cle.locale='MASTER'
              and cle.CUSTOMER_ID=ch.name
              
          where cle.CUSTOMER_ID is NULL
            and ch.name='<xsl:value-of select="$channel"/>'
            and cc.enabled=1
            and (cc.localeenabled=1 or cc.masterlocaleenabled=1)
            and o.content_type='PMT_Master'
            and o.localisation='master_global'
            and o.status='Final Published'
      </sql:query>
    </sql:execute-query>
    <!--  -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        update CUSTOMER_LOCALE_EXPORT CLE
           set flag=1
         where locale = 'MASTER'
           and customer_id = '<xsl:value-of select="$channel"/>'
           and ctn in (
              select co.object_id
              from channels ch
              
              inner join channel_catalogs cc
                 on cc.customer_id=ch.id
                 
              inner join object_master_data omd
                 on (cc.division='ALL' or omd.division=cc.division)
              
              inner join mv_cat_obj co
                 on co.object_id = omd.object_id
                and (ch.catalog = 'ALL' or co.catalog=cc.catalog_type)
              
              inner join octl o
                 on o.object_id=co.object_id
                 
              where ch.name='<xsl:value-of select="$channel"/>'
                and cc.enabled=1
                and (cc.localeenabled=1 or cc.masterlocaleenabled=1)
                and co.sop - ch.PUBLICATIONOFFSET_SOP &lt; sysdate
                and co.eop + ch.PUBLICATIONOFFSET_EOP &gt; sysdate
                and o.content_type='PMT_Master'
                and o.localisation='master_global'
                and o.status='Final Published'

                and (cle.lasttransmit is null or o.lastmodified_ts &gt; cle.lasttransmit)
                )
      </sql:query>
    </sql:execute-query>
  </xsl:template>
</xsl:stylesheet>