<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	exclude-result-prefixes="sql xsl">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel">test</xsl:param>
  <xsl:param name="locale">en_UK</xsl:param>

  <xsl:template match="/">
  <root>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
select ll.LANGUAGE, TO_CHAR(lc.sop,'yyyy-mm-dd"T"hh24:mi:ss') sop, TO_CHAR(lc.eop,'yyyy-mm-dd"T"hh24:mi:ss') eop, lp.DATA
  from LOCALIZED_PRODUCTS lp
 inner join LOCALE_LANGUAGE ll 
    on lp.LOCALE        = ll.LOCALE
 inner join mv_LOCAL_CATALOG lc 
    on lc.CTN           = lp.ID 
   and lc.COUNTRY       = '<xsl:value-of select="substring-after($locale,'_')"/>'
 inner join CUSTOMER_LOCALE_EXPORT cle 
    on cle.ctn          = lp.ID 
   and cle.locale       = lp.LOCALE 
   and cle.CUSTOMER_ID  = '<xsl:value-of select="$channel"/>' 
   and cle.flag         = 1
 where lp.locale        = '<xsl:value-of select="$locale"/>'
 order by lp.ID
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>