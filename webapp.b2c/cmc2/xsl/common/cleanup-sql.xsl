<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">

	<xsl:template match="sql:rowset[sql:error]">
			<sql-status>failed</sql-status>
			<sql-error><xsl:copy-of copy-namespaces="no" select="sql:error/node()"/></sql-error>
	</xsl:template>
	
	<xsl:template match="sql:rowset[sql:row/sql:returncode]">
			<sql-status>success</sql-status>
			<sql-returncode><xsl:copy-of copy-namespaces="no" select="sql:row/sql:returncode/node()"/></sql-returncode>
	</xsl:template>
    
    <!-- Stored procedure / PL-SQL results -->
    <xsl:template match="sql:rowset[empty(*)]">
        <sql-status>success</sql-status>
        <sql-returncode/>
    </xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>