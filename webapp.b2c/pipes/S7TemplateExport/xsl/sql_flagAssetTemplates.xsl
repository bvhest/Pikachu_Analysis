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
  <xsl:variable name="quot">'</xsl:variable>
  <xsl:variable name="template-config-keys-list" select="string-join(for $i in distinct-values(Templates/keys/key/keyname) return concat($quot,$i,$quot),',')"/>
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
    <!-- Add a row for each new Key/AssetTemplate -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        <xsl:choose>
          <xsl:when test="$assetlocaletype = 'global'">
            INSERT INTO CUSTOMER_LOCALE_EXPORT(CUSTOMER_ID, LOCALE, CTN, FLAG)
                  SELECT distinct
                '<xsl:value-of select="$channel"/>',
                '<xsl:value-of select="$locale"/>',
                o.object_ID,
                0
               from keyvaluepairs k
              inner join octl o
                 on K.CTN = o.object_id
                and o.content_type = 'AssetTemplate'
                and o.status != 'PLACEHOLDER'
                and o.localisation = '<xsl:value-of select="$locale"/>'
              left outer join customer_locale_export cle
                 on cle.customer_id='<xsl:value-of select="$channel"/>'
                and cle.locale = o.localisation
                and cle.ctn=o.object_id
              where k.key in (<xsl:value-of select="$template-config-keys-list"/>)
                and cle.ctn is null                
          </xsl:when>
        </xsl:choose>
      </sql:query>
    </sql:execute-query>
    <!-- set flag to 1 if key/assetslist has changed since last export -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        <xsl:choose>
          <xsl:when test="$assetlocaletype = 'global'">
            UPDATE CUSTOMER_LOCALE_EXPORT cle
            set
              FLAG=1
            where customer_id = '<xsl:value-of select="$channel"/>'
            and locale = '<xsl:value-of select="$locale"/>'
            and ctn in
            (
             select distinct o.object_id
               from keyvaluepairs k
              inner join octl o
                 on k.ctn = o.object_id
                and o.content_type = 'AssetTemplate'
                and o.localisation = '<xsl:value-of select="$locale"/>'               
              inner join customer_locale_export cle2
                 on cle2.customer_id = '<xsl:value-of select="$channel"/>'              
                and cle2.locale = o.localisation
                and cle2.ctn = o.object_id
              where k.key in (<xsl:value-of select="$template-config-keys-list"/>)
                and (k.lastmodified &gt; cle2.lasttransmit
                 or o.lastmodified_ts &gt; cle2.lasttransmit
                 or cle2.lasttransmit is null)
            )
          </xsl:when>
        </xsl:choose>
      </sql:query>
    </sql:execute-query>
  </root>
</xsl:template>
</xsl:stylesheet>