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
  <xsl:param name="locale"/>
  <xsl:param name="exportdate"/>
  <xsl:param name="assetlocaletype"/>
  <xsl:param name="ctn"/>
  <!-- -->
  <xsl:variable name="publicationOffset"><xsl:value-of select="if ($channel='FlixMediaAssets') then '45' else '7'"/></xsl:variable>
  <!-- -->
  <xsl:template match="/">
  <root assetlocaletype="{$assetlocaletype}">
  <!-- clear all-->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
UPDATE CUSTOMER_LOCALE_EXPORT
set FLAG=0
where
  CUSTOMER_ID='<xsl:value-of select="$channel"/>'
  and LOCALE='<xsl:value-of select="$locale"/>'
  and FLAG=1
      </sql:query>
    </sql:execute-query>
    <!-- Add a row for each new AssetList -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        <xsl:choose>
          <xsl:when test="$assetlocaletype = 'local'">
            INSERT INTO CUSTOMER_LOCALE_EXPORT(CUSTOMER_ID, LOCALE, CTN, FLAG)
                  SELECT distinct
                '<xsl:value-of select="$channel"/>',
                '<xsl:value-of select="$locale"/>',
                o.object_ID,
                0
              from locale_language ll
              inner join catalog_objects co
                 on ll.country = co.country
                and ll.locale = '<xsl:value-of select="$locale"/>'
              inner join channel_catalogs cc
                 on co.customer_id = cc.catalog_type
                and cc.enabled = 1
                and cc.locale = ll.locale
              inner join octl o
                 on co.object_id = o.object_id
                and o.content_type = 'AssetList'
                and o.status != 'PLACEHOLDER'
                and o.localisation = ll.locale
              inner join channels c
                 on cc.customer_id = c.id
                and c.name = '<xsl:value-of select="$channel"/>'
              left outer join customer_locale_export cle
                 on cle.customer_id='<xsl:value-of select="$channel"/>'
                and cle.locale = ll.locale
                and cle.ctn=o.object_id
              where cle.ctn is null
              <xsl:if test="$ctn != ''">
                and o.object_id = '<xsl:value-of select="$ctn"/>'
              </xsl:if>
          </xsl:when>
          <xsl:when test="$assetlocaletype = 'global'">
            INSERT INTO CUSTOMER_LOCALE_EXPORT(CUSTOMER_ID, LOCALE, CTN, FLAG)
                  SELECT distinct
                '<xsl:value-of select="$channel"/>',
                '<xsl:value-of select="$locale"/>',
                o.object_ID,
                0
              from locale_language ll
              inner join catalog_objects co
                 on ll.country = co.country
              inner join channel_catalogs cc
                 on co.customer_id = cc.catalog_type
                and cc.enabled = 1
                and cc.locale = ll.locale
              inner join octl o
                 on co.object_id = o.object_id
                and o.content_type = 'AssetList'
                and o.status != 'PLACEHOLDER'
                and o.localisation = '<xsl:value-of select="$locale"/>'
              inner join channels c
                 on cc.customer_id = c.id
                and c.name = '<xsl:value-of select="$channel"/>'
              left outer join customer_locale_export cle
                 on cle.customer_id='<xsl:value-of select="$channel"/>'
                and cle.locale = o.localisation
                and cle.ctn=o.object_id
              where cle.ctn is null
              <xsl:if test="$ctn != ''">
                and o.object_id = '<xsl:value-of select="$ctn"/>'
              </xsl:if>
          </xsl:when>
        </xsl:choose>
      </sql:query>
    </sql:execute-query>
    <!-- set flag to 1 if the export was before the last modified date -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        <xsl:choose>
          <xsl:when test="$assetlocaletype = 'local'">
            UPDATE CUSTOMER_LOCALE_EXPORT cle
            set
              FLAG=1
            where customer_id = '<xsl:value-of select="$channel"/>'
            and locale = '<xsl:value-of select="$locale"/>'
            and ctn in
            (
             select distinct o.object_id
               from locale_language ll
              inner join catalog_objects co
                 on ll.country = co.country
                and ll.locale = '<xsl:value-of select="$locale"/>'
              inner join channel_catalogs cc
                 on co.customer_id = cc.catalog_type
                and cc.enabled = 1
                and cc.locale = ll.locale
              inner join customer_locale_export cle2
                 on cle2.locale = ll.locale
                and cle2.locale = '<xsl:value-of select="$locale"/>'
                and cle2.customer_id = '<xsl:value-of select="$channel"/>'
                and cle2.ctn = co.object_id
              inner join octl o
                 on co.object_id = o.object_id
                and o.content_type = 'AssetList'
                and o.status != 'PLACEHOLDER'
                and o.localisation = ll.locale
              inner join channels c
                 on cc.customer_id = c.id
                and c.name = '<xsl:value-of select="$channel"/>'
              where (co.sop-to_number('<xsl:value-of select="$publicationOffset"/>')) &lt; sysdate
                and co.eop &gt; sysdate
                and nvl(co.deleted,0) = 0
                and (o.LASTMODIFIED_TS &gt; cle2.LASTTRANSMIT  or cle2.LASTTRANSMIT is NULL)                
              <xsl:if test="$ctn != ''">
                and o.object_id = '<xsl:value-of select="$ctn"/>'
              </xsl:if>
            )
         </xsl:when>
          <xsl:when test="$assetlocaletype = 'global'">
            UPDATE CUSTOMER_LOCALE_EXPORT cle
            set
              FLAG=1
            where customer_id = '<xsl:value-of select="$channel"/>'
            and locale = '<xsl:value-of select="$locale"/>'
            and ctn in
            (
             select distinct o.object_id
               from locale_language ll
              inner join catalog_objects co
                 on ll.country = co.country
              inner join channel_catalogs cc
                 on co.customer_id = cc.catalog_type
                and cc.enabled = 1
                and cc.locale = ll.locale
              inner join customer_locale_export cle2
                 on cle2.locale = '<xsl:value-of select="$locale"/>'
                and cle2.customer_id = '<xsl:value-of select="$channel"/>'
                and cle2.ctn = co.object_id
              inner join octl o
                 on co.object_id = o.object_id
                and o.content_type = 'AssetList'
                and o.status != 'PLACEHOLDER'
                and o.localisation = '<xsl:value-of select="$locale"/>'
              inner join channels c
                 on cc.customer_id = c.id
                and c.name = '<xsl:value-of select="$channel"/>'
              where (co.sop-to_number('<xsl:value-of select="$publicationOffset"/>')) &lt; sysdate
                and co.eop &gt; sysdate
                and nvl(co.deleted,0) = 0
                and (o.LASTMODIFIED_TS &gt; cle2.LASTTRANSMIT  or cle2.LASTTRANSMIT is NULL)
                <!-- Temp Solution to override the disk space issue for Scene7-->
                <xsl:if test="$channel = 'Scene7'">
                    and rownum &lt;= 5000
                </xsl:if>
                <xsl:if test="$ctn != ''">
                  and o.object_id = '<xsl:value-of select="$ctn"/>'
                </xsl:if> 
            )
          </xsl:when>
        </xsl:choose>
      </sql:query>
    </sql:execute-query>
  <!-- -->
  </root>
</xsl:template>
</xsl:stylesheet>