<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
	xmlns:dir="http://apache.org/cocoon/directory/2.0" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>  

  <xsl:template match="/">
  <root>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
select distinct cc.locale
  from channel_catalogs cc
 inner join channels c 
    on c.id = cc.customer_id
 where c.name = '<xsl:value-of select="$channel"/>' 
   and cc.enabled = 1
   <!-- Solution to run single locale -->
   <xsl:if test="$locale != ''">
    and cc.locale = '<xsl:value-of select="$locale"/>'
   </xsl:if>
 order by cc.locale
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>