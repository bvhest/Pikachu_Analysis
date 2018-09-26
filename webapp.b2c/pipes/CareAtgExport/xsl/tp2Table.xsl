<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="doctypesfilepath"/>
	<!--  -->
	<xsl:variable name="catalog" select="document('customCatalogCombined.xml')"/>
	<xsl:variable name="boolean">
		<option value="true" code="1"/>
		<option value="false" code="0"/>
		<option value="yes" code="1"/>
		<option value="no" code="0"/>
	</xsl:variable>
	<!-- -->
	<xsl:template match="node()|@*">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="add-item">
		<xsl:variable name="currentNode" select="."/>
		<xsl:for-each select="$catalog/gsa-template/item-descriptor[@name=$currentNode/@item-descriptor]/table">
			
			<xsl:variable name="table" select="."/>
			<xsl:choose>
				<xsl:when test="@type='auxiliary' or @type='primary' ">
					<table name="{@name}">
					<row>
						<column name="{@id-column-name}">
								<xsl:value-of select="$currentNode/@id"/>
						</column>
						<xsl:for-each select="property">
								<xsl:variable name="propertyName" select="@name"/>
								<xsl:if test="@column-name != ../@id-column-name">
									<column name="{@column-name}">
										<xsl:variable name="propertyValue" select="$currentNode/set-property[@name=$propertyName]"/>
										<xsl:choose>
											<xsl:when test="@data-type='enumerated'">
												<xsl:value-of select="option[@value=$propertyValue]/@code"/>
											</xsl:when>
											<xsl:when test="@data-type='boolean'">
												<xsl:value-of select="$boolean/option[@value=$propertyValue]/@code"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$propertyValue"/>
											</xsl:otherwise>
										</xsl:choose>							
									</column>
								</xsl:if>
						</xsl:for-each>
					</row>
					</table>
				</xsl:when>
				<xsl:when test="@type='multi' ">
					<table name="{@name}">
						<xsl:for-each select="property">
							<xsl:variable name="property" select="."/>
							<xsl:choose>
								<xsl:when test="@data-type='map' ">
								<xsl:for-each select="tokenize($currentNode/set-property[@name=$property/@name],',')">
								<row>
									<column name="{$table/@id-column-name}">
										<xsl:value-of select="$currentNode/@id"/>
									</column>
									<column name="{$property/@column-name}">
										<xsl:value-of select="substring-after(.,'=') "/>
									</column>
									<column name="{$table/@multi-column-name}">
										<xsl:value-of select="substring-before(.,'=') "/>
									</column>
									</row>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="@data-type='list' ">
									<xsl:for-each select="tokenize($currentNode/set-property[@name=$property/@name],',')">
									<row>
									<column name="{$table/@id-column-name}">
										<xsl:value-of select="$currentNode/@id"/>
									</column>
									<column name="{$table/@multi-column-name}">
										<xsl:value-of select="position() "/>
									</column>
									<column name="{$property/@column-name}">
										<xsl:value-of select="."/>
									</column>
									</row>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="@data-type='set' ">
									<xsl:for-each select="tokenize($currentNode/set-property[@name=$property/@name],',')">
									<row>
									<column name="{$table/@id-column-name}">
										<xsl:value-of select="$currentNode/@id"/>
									</column>
									<column name="{$property/@column-name}">
										<xsl:value-of select="."/>
									</column>
									</row>
									</xsl:for-each>			
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</table>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="set-property">
		<xsl:variable name="currentNode" select="."/>
		<column name="{$currentNode/@name}">
			<xsl:value-of select="."/>
		</column>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
