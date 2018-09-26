<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="channel"/>
	<xsl:param name="locale"/>
	<xsl:param name="table"/>
	<xsl:param name="join"/>
	<xsl:template match="/">

		<root>
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query name="product">
				<xsl:choose>
					<xsl:when test="$join eq 'INNER'">
						select LP.ID
						from LOCALIZED_PRODUCTS LP INNER JOIN MASTER_PRODUCTS MP on LP.ID = MP.ID
						inner join CUSTOMER_LOCALE_EXPORT CLE on LP.ID = CLE.CTN and LP.LOCALE = CLE.LOCALE
						where LP.locale = '<xsl:value-of select="$locale"/>'
						and CLE.CUSTOMER_ID = '<xsl:value-of select="$channel"/>'
						and CLE.FLAG = 1
						<!-- and LP.id like '50PF9%' -->
						order by ID
					</xsl:when>
				</xsl:choose>
				</sql:query>
				<!--sql:execute-query>
					<sql:query name="cat">
select sc.GROUPCODE, sc.GROUPNAME, sc.CATEGORYCODE, sc.CATEGORYNAME, sc.SUBCATEGORYCODE, sc.SUBCATEGORYNAME
from SUBCAT_PRODUCTS sp
inner join SUBCAT sc on sp.SUBCATEGORYCODE = sc.SUBCATEGORYCODE
where sp.ID = '<sql:ancestor-value name="id" level="1"/>'</sql:query>
				</sql:execute-query-->
			</sql:execute-query>
		</root>
	</xsl:template>
</xsl:stylesheet>
