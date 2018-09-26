<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
	xmlns:dir="http://apache.org/cocoon/directory/2.0" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="channel">test</xsl:param>
	<xsl:param name="country">test</xsl:param>
	<xsl:param name="locale">test</xsl:param>
	<xsl:param name="exportdate"></xsl:param>
	<xsl:variable name="fulldate"><xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/>T<xsl:value-of select="substring($exportdate,10,2)"/>:<xsl:value-of select="substring($exportdate,12,2)"/>:00</xsl:variable>
	<!-- -->
	<xsl:template match="/">
	<root>
	<!-- set flag to 1 if the export was before the last modified date -->
		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
			<sql:query>
UPDATE CUSTOMER_LOCALE_EXPORT cle
set 
	FLAG=0,
	LASTTRANSMIT=to_date('<xsl:value-of select="$fulldate"/>','yyyy-mm-dd"T"hh24:mi:ss')
where 
	cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
	and cle.locale='<xsl:value-of select="$locale"/>'
	and cle.FLAG=1
			</sql:query>
		</sql:execute-query>
	</root>
</xsl:template>
</xsl:stylesheet>