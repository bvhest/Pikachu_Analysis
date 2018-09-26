<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
	xmlns:dir="http://apache.org/cocoon/directory/2.0" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel">test</xsl:param>

  <xsl:template match="/">
  <root>
	<!-- Get all locale codes for all languages that are involved in the translation process. Skip the non-translated languages -->
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
select distinct LANGUAGECODE
from LOCALE_LANGUAGE LL
inner join channel_catalogs CC on CC.locale = LL.locale
inner join channels C
	on CC.customer_id = C.id
where 
	C.name = '<xsl:value-of select="$channel"/>'
	and CC.enabled = 1
order by LANGUAGECODE
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>