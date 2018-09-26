<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
<root>
		<sql:execute-query>
			<sql:query>
select distinct locale
from language_translations
where 
	enabled = 1 
	and isdirect = 0
order by locale	
			</sql:query>
		</sql:execute-query>
</root>
	</xsl:template>
</xsl:stylesheet>