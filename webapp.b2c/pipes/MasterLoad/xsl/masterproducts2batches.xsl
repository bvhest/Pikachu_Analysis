<?xml version="1.0"?>
<?altova_samplexml masterproducts2batches_test.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:req="http://apache.org/cocoon/request/2.0" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="batchsize">10</xsl:param>
	<xsl:param name="channel"/>
	<xsl:param name="dir"/>
	<xsl:param name="exportdate"/>
	<xsl:param name="reload"/>
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
				<xsl:with-param name="list" select="sql:row[not(sql:ctn=preceding-sibling::sql:row/sql:ctn)]"/>
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
			<source:source><xsl:value-of select="$dir"/>batch.<xsl:value-of select="$exportdate"/>.<xsl:value-of select="$group"/>.<xsl:value-of select="$reload"/>.xml</source:source>
			<source:fragment>
				<Products >					
					<xsl:for-each select="$list">
						<Product-Group ctn="{sql:ctn}" runts="{sql:runts}" lastmodified="{sql:lastmodified}" mplastmodified="{sql:mplm}">
							<Master-Product>
								<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
									<sql:query>select division, brand, data, lastmodified from RAW_MASTER_PRODUCTS where ctn='<xsl:value-of select="sql:ctn"/>' and data_type='Product'</sql:query>
								</sql:execute-query>
							</Master-Product>
							<Disclaimer-Product>
								<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
									<sql:query>select division, brand, data, lastmodified from RAW_MASTER_PRODUCTS where ctn='<xsl:value-of select="sql:ctn"/>' and data_type='Disclaimer'</sql:query>
								</sql:execute-query>
							</Disclaimer-Product>
						</Product-Group>
					</xsl:for-each>
				</Products>
			</source:fragment>
		</source:write>
				
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
