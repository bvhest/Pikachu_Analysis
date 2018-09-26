<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="param1"/>
	<xsl:param name="channel"/>
	<xsl:template match="/">
		<root>
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query name="channels">
select name
from Channels
where ID='<xsl:value-of select="$channel"/>'</sql:query>
				<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
					<sql:query name="list">
delete
from CUSTOMER_LOCALE_EXPORT
where CUSTOMER_ID='<sql:ancestor-value name="name" level="1"/>'</sql:query>
				</sql:execute-query>
				<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
					<sql:query name="list">
delete
from Channels
where Name='<sql:ancestor-value name="name" level="1"/>'</sql:query>
				</sql:execute-query>
				<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
					<sql:query name="list">
delete
from CHANNEL_PARAM
where CHANNEL='<sql:ancestor-value name="name" level="1"/>'</sql:query>
				</sql:execute-query>
			</sql:execute-query>
		</root>
	</xsl:template>
</xsl:stylesheet>
