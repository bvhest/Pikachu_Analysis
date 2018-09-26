<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >

  <xsl:param name="ct" /> 
  <xsl:param name="locale" /> 
  <!--xsl:variable name="ts" select="/sql:rowset/sql:row/sql:lastrun_ts"/--> 
 
  <xsl:template match="/">
    <root
      ct="{$ct}"
      l="{$locale}"
      >

      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
select al.*
  from ASSET_LISTS al 
  left outer join CUSTOMER_LOCALE_EXPORT cle 
    on cle.customer_id = '<xsl:value-of select="$ct"/>' 
   and cle.ctn         = al.object_id 
   and cle.locale      = al.locale
 where al.doctype = 'GIM' 
   and al.locale = '<xsl:value-of select="$locale"/>' 
   and al.deleted = 0 
   and (   al.lastmodified > cle.lasttransmit 
        or cle.lasttransmit is null 
       ) 
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>