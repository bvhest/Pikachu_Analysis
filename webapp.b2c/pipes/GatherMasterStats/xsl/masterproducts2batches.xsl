<?xml version="1.0"?>
<?altova_samplexml masterproducts2batches_test.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:req="http://apache.org/cocoon/request/2.0" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="batchsize">10</xsl:param>
	<xsl:param name="channel">test</xsl:param>
	<xsl:param name="dir">temp/</xsl:param>
	<xsl:param name="exportdate"/>
	<!-- -->
	<xsl:template match="/batch">
		<root>
			<xsl:apply-templates select="sql:rowset"/>
		</root>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:rowset">
		<root>
			<xsl:call-template name="RecursiveGrouping">
				<xsl:with-param name="list" select="sql:row"/>
				<xsl:with-param name="group" select="1"/>
		</xsl:call-template>
		</root>
	</xsl:template>
	<!-- -->
	<xsl:template name="RecursiveGrouping">
		<xsl:param name="list"/>
		<xsl:param name="group"/>
		<xsl:if test="count($list)>0">
			<xsl:call-template name="DoIt">
				<xsl:with-param name="list" select="$list[position() &lt;= $batchsize]"/>
				<xsl:with-param name="group" select="$group"/> 
			</xsl:call-template>
			<!-- If there are other groups left, calls itself -->
			<xsl:call-template name="RecursiveGrouping">
				<xsl:with-param name="list" select="$list[position() > $batchsize]"/>
				<xsl:with-param name="group" select="$group+1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- -->
	<xsl:template name="DoIt">
		<xsl:param name="list"/>
		<xsl:param name="group"/>				
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source><xsl:value-of select="$dir"/>batch.<xsl:value-of select="$exportdate"/>.<xsl:value-of select="$group"/>.xml</source:source>
			<source:fragment>
				<Products >					
					<xsl:for-each select="$list">
						<Product ctn="{sql:ctn}" lastmodified="{sql:lastmodified}" sop="{sql:sop}" eop="{sql:eop}" locale="{sql:locale}" brand="{sql:brand}" division="{sql:division}">
							<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
								<sql:query>select division, brand, data, 'Master' as locale from MASTER_PRODUCTS where id='<xsl:value-of select="sql:ctn"/>'</sql:query>
							</sql:execute-query>
						</Product>
					</xsl:for-each>
				</Products>
			</source:fragment>
		</source:write>
				
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
