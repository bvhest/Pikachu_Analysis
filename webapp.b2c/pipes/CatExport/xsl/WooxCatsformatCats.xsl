<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="cinclude xdt fn dir">
	<!-- -->


	<xsl:template match="/root">

		<Products>
			<xsl:variable name="prodTreeCTN" select="sql:rowset/sql:row[sql:bgroupcode = '6911' or (sql:bgroupcode = '6801' and sql:categorycode = 'I45')][sql:object_id!='']/concat(':',sql:object_id,':')" />
					     
					     
			<xsl:apply-templates
				select="sql:rowset/sql:row[contains(string-join($prodTreeCTN,','),concat(':',sql:object_id,':'))][sql:object_id!='']" />
				<!--  -->
				
		</Products>
	</xsl:template>


	<xsl:template match="sql:rowset/sql:row">


		<Product>
			   <xsl:attribute name="ctn" select="sql:object_id" />
			<xsl:attribute name="subcatName" select="sql:subcategoryname" />
			<xsl:attribute name="subcat" select="sql:subcategorycode" />
			<xsl:attribute name="catName" select="sql:categoryname" />
			<xsl:attribute name="cat" select="sql:categorycode" />
			<xsl:attribute name="groupName" select="sql:groupname" />
			<xsl:attribute name="group" select="sql:groupcode" />

			<xsl:choose>	
    <xsl:when test="sql:catalogcode = 'CARE'">
    	<xsl:choose>
    		<xsl:when test="sql:groupcode != 'ACCESSORIES_GR'">
    			<xsl:attribute name="tree">A_NORMAL</xsl:attribute>
    		</xsl:when>
    		<xsl:when test="sql:groupcode = 'ACCESSORIES_GR'">
    			<xsl:attribute name="tree">B_ACC</xsl:attribute>
    		</xsl:when>
    	</xsl:choose>
    </xsl:when>
    <xsl:when test="sql:catalogcode = 'MASTER'">
    	<xsl:attribute name="tree">C_CMC2</xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
    	<xsl:attribute name="tree">D_FALLBACK</xsl:attribute>
    </xsl:otherwise>
</xsl:choose>

			<xsl:attribute name="manufacturer">Gibson</xsl:attribute>
			<xsl:attribute name="brand">Philips</xsl:attribute> 
 
</Product>

	</xsl:template>




</xsl:stylesheet>