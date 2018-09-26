<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"   >
	<xsl:template match="/">
		<root>
			<xsl:apply-templates select="root/sql:rowset[3]/sql:row"/>
		</root>
	</xsl:template>
	<xsl:template match="sql:row">
		<cinclude:include>
			<xsl:attribute name="src" select="concat('cocoon:/purgeBatchedFiles.', sql:batch_number)" />
		</cinclude:include>
	</xsl:template>
</xsl:stylesheet>