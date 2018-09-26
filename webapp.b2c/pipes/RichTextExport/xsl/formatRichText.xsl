<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql">
	<xsl:param name="timestamp"/>
	<xsl:variable name="processTimestamp" select="concat(substring($timestamp,1,4),'-',substring($timestamp,5,2),'-',substring($timestamp,7,2),'T',substring($timestamp,9,2),':',substring($timestamp,11,2),':',substring($timestamp,13,2))"/>
<!--	
	 <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
-->

	<xsl:template match="/">
		<root docTimestamp="{$processTimestamp}">
			<RichTextItems>
				<xsl:for-each-group select="/ProductsMsg/sql:rowset/sql:row/sql:data/object/RichTexts/RichText//Item" group-by="@code">
					<xsl:sort select="@code"/>
					<RichTextItem type="{../@type}" >
						<ItemCode>
							<xsl:value-of select="@code"/>
						</ItemCode>
						<ItemReferenceName>
							<xsl:value-of select="@referenceName"/>
						</ItemReferenceName>
						<Head>
							<xsl:value-of select="Head"/>
						</Head>
					</RichTextItem>
				</xsl:for-each-group>
			</RichTextItems>
		</root>
	</xsl:template>

	<!--  -->
</xsl:stylesheet>
