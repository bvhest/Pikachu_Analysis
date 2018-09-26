<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="locale"/>
	<xsl:template match="/">
			<Locales>
				<xsl:attribute name="id"><xsl:value-of select="$locale"/></xsl:attribute>
				<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
					<sql:query name="locale">
						SELECT locale from LOCALE_LANGUAGE
						where locale = '<xsl:value-of select="$locale"/>'
					</sql:query>
				</sql:execute-query>
			</Locales>
	</xsl:template>
</xsl:stylesheet>