<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="channel" />
  <xsl:param name="locale" />
  <xsl:param name="ts" />

  <xsl:template match="/">
    <root>
      <!-- 
        Store md5 from the ASSET_LISTS table in the remark field.
      -->
      <sql:execute-query>
        <sql:query>
          merge into customer_locale_export cle
          using (
            select al.asset_id
                 , al.locale
                 , al.md5
            from asset_lists al
            
            where al.locale='<xsl:value-of select="$locale" />'
            -- Only for records that were not modified after this run was started
            and al.lastmodified &lt; to_date('<xsl:value-of select="$ts" />','yyyymmddhh24miss')
          ) al
          on (
                al.asset_id=cle.ctn
            and al.locale=cle.locale
            and cle.customer_id='<xsl:value-of select="$channel" />'
            and cle.flag=1
            and cle.ctn like '%|%'
          )
          when matched then
            update set remark=al.md5
          
        </sql:query>
      </sql:execute-query>
      <!-- 
        Reset flag to 0.
        Set lasttransmit.
      -->
      <sql:execute-query>
        <sql:query>
          UPDATE CUSTOMER_LOCALE_EXPORT
          set FLAG=0,
              LASTTRANSMIT=to_date('<xsl:value-of select="$ts" />','yyyymmddhh24miss')
          where CUSTOMER_ID='<xsl:value-of select="$channel" />'
            and LOCALE='<xsl:value-of select="$locale" />'
            and FLAG=1
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>