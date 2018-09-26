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
               , al.ACCESS_RIGHTS, al.MODIFIED, al.PUBLISHER
               , al.INTERNALRESOURCEIDENTIFIER, al.SECURERESOURCEIDENTIFIER, al.PUBLICRESOURCEIDENTIFIER
               , al.FORMAT, al.EXT
          from asset_lists al

          inner join customer_locale_export cle
             on al.object_id || '|' || al.doctype = cle.ctn
            and al.locale = cle.locale

          where cle.locale = '<xsl:value-of select="$locale" />'
            and cle.customer_id = '<xsl:value-of select="$channel" />'
            and cle.flag = 1
            and al.deleted = 0
          -- Order is important for numbering the result file
          order by object_id
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
