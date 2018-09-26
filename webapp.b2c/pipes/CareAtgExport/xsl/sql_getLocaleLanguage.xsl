<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:template match="/">
		<root>
			<sql:execute-query>
				<sql:query>select locale,ccr_language_code, languagecode from locale_language</sql:query>
			</sql:execute-query>
		</root>
	</xsl:template>
</xsl:stylesheet>
