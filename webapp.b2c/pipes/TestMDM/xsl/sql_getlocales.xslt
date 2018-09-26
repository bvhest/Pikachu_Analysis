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
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
	  select distinct ce.LOCALE
from CHANNEL_EXPORT ce
inner join CHANNELS c on c.id = ce.customer_id
where c.Name = '<xsl:value-of select="$channel"/>' and ce.EXPORTENABLEFLAG = 1
order by ce.LOCALE
<!--
select LOCALE
from LOCALE_LANGUAGE
order by LOCALE
-->
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>