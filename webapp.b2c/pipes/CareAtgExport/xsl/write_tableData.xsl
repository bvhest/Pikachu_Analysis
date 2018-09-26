<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0" >
<xsl:param name="path"/>
	<xsl:variable name="field-delimiter">
		<xsl:text>|</xsl:text>
	</xsl:variable>
	<xsl:variable name="record-delimiter">
		<xsl:text>&#x0A;</xsl:text>
	</xsl:variable>
	<xsl:template match="node()|@*">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="import-items">
		<xsl:variable name="currentNode" select="."/>
		<xsl:for-each-group select="table" group-by="@name">
			<xsl:variable name="tableName" select="current-grouping-key()"/>
			<table name="{$tableName}">
				<source:write>
					<source:source>
						<xsl:value-of select="concat($path,'/',$tableName,'.dat')"/>
					</source:source>
					<source:fragment>
					<root>
						<xsl:for-each select="current-group()">
							<xsl:for-each select="row">
							<xsl:for-each select="column">
								<xsl:if test="position() != 1">
									<xsl:value-of select="$field-delimiter"/>
								</xsl:if>
									<xsl:value-of select=" if (.='__NULL__') then '' else ."/>
							</xsl:for-each>
							<xsl:value-of select="$record-delimiter"/>
						</xsl:for-each>
						</xsl:for-each>
					</root>	
					</source:fragment>
				</source:write>
			</table>
		</xsl:for-each-group>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
