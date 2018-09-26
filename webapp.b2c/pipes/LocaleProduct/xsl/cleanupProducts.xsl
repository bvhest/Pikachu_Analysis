<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"  
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:sql-disabled="http://apache.org/cocoon/SQL/2.0/disabled" 
                xmlns:i="http://apache.org/cocoon/include/1.0" 
                exclude-result-prefixes="sql xsl i">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!--  -->

	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

    <xsl:template match="sql-disabled:*">
       <xsl:element name="{concat('sql:',local-name())}">
         <xsl:apply-templates select="node()|@*"/>
       </xsl:element>
    </xsl:template>

    <xsl:template match="id"/>
</xsl:stylesheet>
