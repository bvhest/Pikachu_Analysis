<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	
	<xsl:template match="sql:rowset">
		<html>
			<head/>
			<body>
				<table border="1">
					<xsl:apply-templates/>
				</table>
			</body>			
		</html>
	</xsl:template>	
	
	<xsl:template match="sql:row">
		<xsl:if test="position()=1">
		<tr>
			<xsl:apply-templates mode="header"/>
		</tr>
		</xsl:if>
		<tr>
			<xsl:apply-templates/>
		</tr>		
	</xsl:template>	
	
	<xsl:template match="sql:*" mode="header">
		<th><xsl:value-of select="local-name()"/></th>
	</xsl:template>
	
	<xsl:template match="sql:*">
		<td><xsl:value-of select="."/></td>
	</xsl:template>
	
</xsl:stylesheet>