<?xml version="1.0" encoding="UTF-8"?>
	<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="includeXml" as="xs:string">false</xsl:param>
	<xsl:param name="translatedAttributesDoc"/>
	<xsl:variable name="translatedAttributes" select="document($translatedAttributesDoc)//translatedAttribute"/>
	<!-- -->
	<xsl:template match="/TranslationOverrideRequest">
<root>
	<xsl:copy copy-namespaces="no" select="./Request/@skipMaxProductsCheck"/>
		<xsl:variable name="masterText" select="Request/TranslationInfo/SourceEnglish"/>
		<xsl:variable name="language" select="Request/@targetLanguage"/>
		<xsl:variable name="single">&apos;</xsl:variable>
		<xsl:variable name="twice">&apos;&apos;</xsl:variable>
		<sql:execute-query>
			<sql:query>
SELECT rlp.id, rlp.locale<xsl:if test="$includeXml ='true'">,mp.data</xsl:if>
FROM raw_localized_products rlp, master_products mp
WHERE
    rlp.locale = '<xsl:value-of select="$language"/>' AND 
	rlp.id = mp.id AND 
	existsNode(xmltype.createxml(mp.data), <xsl:text>'/Product[</xsl:text>
		<xsl:for-each select="$translatedAttributes">
			<xsl:value-of select="@path"/><xsl:text>="</xsl:text><xsl:value-of select="replace($masterText,$single,$twice)"/><xsl:text>"</xsl:text>
			<xsl:if test="position() != last()"> or </xsl:if>
		</xsl:for-each>
		<xsl:text>]') = 1</xsl:text>
			</sql:query>
		</sql:execute-query>
</root>
	</xsl:template>
</xsl:stylesheet>