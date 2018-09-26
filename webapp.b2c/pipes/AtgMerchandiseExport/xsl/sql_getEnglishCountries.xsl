<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="channel">test</xsl:param>
  <xsl:param name="explodeAll" select="'yes'"/>

  <xsl:variable name="l-explode-all" select="if ($explodeAll = 'yes' or $explodeAll = '') then true() else false()"/>
  
  <xsl:template match="/">
  <root>
 	  <sql:execute-query>
  		<sql:query>
        <xsl:choose>
          <xsl:when test="$l-explode-all">
            select distinct substr(l.locale,4,2) country_code
            from locale_language l
            inner join channel_catalogs cc
               on l.locale = cc.locale
            inner join channels c 
               on cc.customer_id = c.id 
            where c.name = '<xsl:value-of select="$channel"/>'
              and cc.enabled = 1
              and substr(l.locale,1,2) != 'en'
              and not exists (select 1 from locale_language ll where ll.locale = 'en_'||substr(l.locale,4,2))
          </xsl:when>
          <xsl:otherwise>
            select distinct ll.country country_code, ll.locale
            from channel_catalogs cc
            inner join channels c
               on c.id=cc.customer_id
            inner join locale_language ll
               on ll.locale=cc.locale
            where c.name='<xsl:value-of select="$channel"/>'
              and cc.enabled=1
              and cc.masterlocaleenabled=1
              and substr(cc.locale,1,2) != 'en'
              and not exists (select 1 from locale_language ll where ll.locale = 'en_'||substr(cc.locale,4,2))
          </xsl:otherwise>
        </xsl:choose>
  		</sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>