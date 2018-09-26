<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="channel">test</xsl:param>
	<xsl:param name="locale">en_UK</xsl:param>
	<!-- -->
	<xsl:template match="/">
		<root>
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query>
select 'ENG' as language, TO_CHAR(d.sop,'yyyy-mm-dd"T"hh24:mi:ss'), TO_CHAR(d.eop,'yyyy-mm-dd"T"hh24:mi:ss'), mp.DATA
  from MASTER_PRODUCTS mp
 inner join (select lc.ctn as id
                  , min(lc.sop) as sop
                  , max(lc.eop) as eop
               from mv_local_catalog lc
              group by lc.ctn
             ) d 
    on d.id = mp.id
 inner join CUSTOMER_LOCALE_EXPORT cle 
    on cle.ctn          = mp.id 
 where cle.locale       = '<xsl:value-of select="$locale"/>' 
   and cle.customer_id  = '<xsl:value-of select="$channel"/>' 
   and cle.flag         = 1
order by mp.id
      </sql:query>
			</sql:execute-query>
		</root>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
