<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- -->
	<xsl:template match="node()|@*" mode="primary">
		<xsl:apply-templates select="@*|node()" mode="primary"/>
	</xsl:template>
	<xsl:template match="node()|@*" mode="auxiliary">
		<xsl:apply-templates select="@*|node()" mode="auxiliary"/>
	</xsl:template>	
	<xsl:template match="node()|@*" mode="multi">
		<xsl:apply-templates select="@*|node()" mode="multi"/>
	</xsl:template>
	
	<xsl:template match="gsa-template">
		<root>
			<xsl:apply-templates mode="primary"/>
			<xsl:apply-templates mode="auxiliary"/>
			<xsl:apply-templates mode="multi"/>
		</root>
	</xsl:template>
	<xsl:template match="table[@type='primary'][@shared-table-sequence=('','1')]" mode="primary">
		<table name="{@name}" type="{@type}">
			<column name="{@id-column-name|@id-column-names}"/>
			<xsl:for-each select="property">
				<xsl:if test="@column-name != ../@id-column-name|../@id-column-names">
					<column name="{@column-name}"/>
				</xsl:if>
			</xsl:for-each>
		</table>
	</xsl:template>
	<xsl:template match="table[@type='auxiliary'][@shared-table-sequence=('','1')]" mode="auxiliary">
		<table name="{@name}" type="{@type}">
			<column name="{@id-column-name|@id-column-names}"/>
			<xsl:for-each select="property">
				<xsl:if test="@column-name != ../@id-column-name|@id-column-names">
					<column name="{@column-name}"/>
				</xsl:if>
			</xsl:for-each>		
		</table>
	</xsl:template>
	<xsl:template match="table[@type='multi'][@shared-table-sequence=('','1')]" mode="multi">
		<xsl:variable name="table" select="."/>
					<table name="{@name}" type="{@type}" data-type="{property/@data-type}"
		append="{if (property/@name='translations') then 'true' else 'false'}">
						<xsl:for-each select="property">
							<xsl:variable name="property" select="."/>
							<xsl:choose>
								<xsl:when test="@data-type='map' ">
									<column name="{$table/@id-column-name}"/>
									<column name="{$property/@column-name}"/>
									<column name="{$table/@multi-column-name}"/>
								</xsl:when>
								<xsl:when test="@data-type='list' ">
									<column name="{$table/@id-column-name}"/>
									<column name="{$table/@multi-column-name}"/>
									<column name="{$property/@column-name}"/>
								</xsl:when>
								<xsl:when test="@data-type='set' ">
									<column name="{$table/@id-column-name}"/>
									<column name="{$property/@column-name}"/>										
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</table>		
		<xsl:apply-templates/>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
