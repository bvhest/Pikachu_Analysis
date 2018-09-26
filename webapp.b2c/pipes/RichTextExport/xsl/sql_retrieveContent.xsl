<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="channel"/>
	<xsl:template match="/">
		<ProductsMsg>
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query name="product">
                    select o.object_id id
                         , TO_CHAR (o.lastmodified_ts, 'yyyy-mm-dd"T"hh24:mi:ss') AS lm
                         , TO_CHAR (o.masterlastmodified_ts, 'yyyy-mm-dd"T"hh24:mi:ss') AS mlm
                         , cle.locale as locale
                         , nvl(cle.lasttransmit,to_date('1900-01-01','YYYY-MM-DD')) as lastexportdate
                         , o.data
                      from CUSTOMER_LOCALE_EXPORT cle
                inner join octl o
                        on o.content_type in ('RichText_Raw','RichText')
                       and o.localisation = cle.locale
                       and o.object_id = cle.ctn
                     where cle.CUSTOMER_ID = '<xsl:value-of select="$channel"/>'
                       and cle.flag = 1
                       and NVL(o.status, 'XXX') != 'PLACEHOLDER'
			      order by o.object_id</sql:query>
			</sql:execute-query>
		</ProductsMsg>
	</xsl:template>
</xsl:stylesheet>
