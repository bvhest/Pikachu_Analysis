<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="param1"/>
	<xsl:template match="/">
		<root>
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query name="channels">
select name
from Channels
where location='<xsl:value-of select="$param1"/>'
      </sql:query>
				<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
					<sql:query name="list">
update CUSTOMER_LOCALE_EXPORT
set lasttransmit=null
where CUSTOMER_ID='<sql:ancestor-value name="name" level="1"/>'
	      </sql:query>
				</sql:execute-query>
			</sql:execute-query>
		</root>
	</xsl:template>
</xsl:stylesheet>
