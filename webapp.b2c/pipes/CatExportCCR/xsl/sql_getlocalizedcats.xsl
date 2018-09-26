<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="channel">test</xsl:param>
	<xsl:param name="locale">en_US</xsl:param>
	<xsl:param name="country">test</xsl:param>

	<!-- -->
	<xsl:template match="/">
		<root>
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query name="subcat">
select 
	ls.CATALOGCODE, 
	ls.CATALOGNAME, 
	ls.CATEGORYCODE, 
	ls.CATEGORYNAME,
	ls.CATEGORYRANK,	
	ls.GROUPCODE,
	ls.GROUPNAME, 
	ls.GROUPRANK, 	
	ls.SUBCATEGORYCODE, 
	ls.SUBCATEGORYNAME,
	ls.SUBCATEGORYRANK	
from localized_subcat ls
where ls.locale = '<xsl:value-of select="$locale"/>' 
and ls.CATALOGCODE in (
	SELECT distinct ls2.CATALOGCODE 
	from localized_subcat ls2
	left join customer_locale_export cle on 
		ls2.CATALOGCODE = cle.ctn 
		and ls2.locale = cle.LOCALE		
	where 
		ls2.LOCALE = '<xsl:value-of select="$locale"/>'
		and cle.FLAG = 1
		and (ls2.lastmodified &gt; cle.lasttransmit or cle.lasttransmit is null)		
		and cle.CUSTOMER_ID = '<xsl:value-of select="$channel"/>'
)
				</sql:query>
			</sql:execute-query>
		</root>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>