<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  exclude-result-prefixes="sql xsl">
  <xsl:param name="channel" />
  <xsl:param name="locale" />

  <xsl:template match="/">
    <root>
    
      <sql:execute-query>
        <sql:query name="RetrieveAssetsInfo">
          select al.OBJECT_ID, al.doctype, al.lang, al.LICENSE
               , al.MODIFIED, al.PUBLISHER
               , al.INTERNALRESOURCEIDENTIFIER, al.PUBLICRESOURCEIDENTIFIER
               , al.FORMAT
          from asset_lists al

          inner join customer_locale_export cle
             on al.asset_id = cle.ctn
            and al.locale = cle.locale
            and cle.locale = '<xsl:value-of select="$locale" />'
            and cle.flag = 1
            and cle.ctn like '%|%'
            and cle.customer_id = '<xsl:value-of select="$channel" />'
          where 
           al.deleted = 0            
            
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
