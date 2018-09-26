<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:param name="channel"/>
	<xsl:param name="locale"/>
	<xsl:template match="sql:*"/>
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="/Products">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<sql:execute-query>
				<sql:query name="timestamp">
			select cle.ctn,to_char(nvl(cle.lasttransmit,to_date('1900-01-01','YYYY-MM-DD')),'YYYY-MM-DD"T"hh24:mi:ss' ) as lastexportdate 
			from customer_locale_export cle
			 where cle.customer_id = '<xsl:value-of select="$channel"/>'
			and cle.locale='<xsl:value-of select="$locale"/>'
		</sql:query>
			</sql:execute-query>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
