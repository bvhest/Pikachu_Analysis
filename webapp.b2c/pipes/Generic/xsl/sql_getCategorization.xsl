<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
xmlns:dir="http://apache.org/cocoon/directory/2.0"
 xmlns:sql="http://apache.org/cocoon/SQL/2.0">
 	<xsl:output method="xml" version="2.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
		
	<xsl:template match="/root">
		<xsl:element name="{name()}">
			<xsl:copy-of select="@*" copy-namespaces="no"/>
			<xsl:apply-templates select="sql:rowset"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="sql:rowset">
				<xsl:apply-templates select="sql:row"/>
	</xsl:template>

	<xsl:template match="sql:row">
			<xsl:apply-templates select="sql:data"/>
	</xsl:template>

	<xsl:template match="sql:data">
			<xsl:apply-templates select="Product"/>
	</xsl:template>

	
	<xsl:template match="Product">
		<xsl:element name="{name()}">
		<xsl:attribute name="StartOfPublication"><xsl:value-of select="replace(../../sql:sop,' ','T')"/></xsl:attribute>
		<xsl:attribute name="EndOfPublication"><xsl:value-of select="replace(../../sql:eop,' ','T')"/></xsl:attribute>
			<xsl:copy-of select="@*" copy-namespaces="no"/>
			<xsl:for-each select="./*">
				<xsl:copy-of select="." copy-namespaces="no"/>
			</xsl:for-each>
			<sql:execute-query>
				<sql:query>
select sc.GROUPCODE, sc.GROUPNAME, sc.CATEGORYCODE, sc.CATEGORYNAME, sc.SUBCATEGORYCODE, sc.SUBCATEGORYNAME 
from SUBCAT_PRODUCTS sp
inner join SUBCAT sc on sp.SUBCATEGORYCODE = sc.SUBCATEGORYCODE
where sp.ID = '<xsl:value-of select="./CTN"/>'      
</sql:query>
			</sql:execute-query>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
