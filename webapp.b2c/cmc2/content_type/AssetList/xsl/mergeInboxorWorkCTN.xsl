<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:assets="http://www.w3.org/1999/XSL/Transform/assets"
				>
  
<xsl:output method="xml" version="1.0" encoding="UTF-8" />  

<xsl:param name="sourceDir"/>
<xsl:param name="directoryName" />
<xsl:param name="ctn" />
<xsl:param name="delta" />
  <!-- Merges the assets from multiple ProductMsg and includes the cache contents for the CTN.
  
       - ProductMsg attributes are set to the most recent found in the input
       - Assets are grouped by ResourceType and Language, and subsequently sorted by ascending Modified tag. The last Asset
         in a group is therefore the most recent, and is to be copied to the output stream
  -->   
  
	  <xsl:template match="node()|@*" >
		<xsl:copy copy-namespaces="no">
		  <xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	  </xsl:template>
  
		<xsl:template match="//directory">
		 <xsl:copy copy-namespaces="no">
			<root>
			<xsl:choose>
				<xsl:when test="$delta = 'assets' ">
					<delta>
						<ProductsMsg>
						   <xsl:attribute name="docTimestamp" select="delta/ProductsMsg[1]/@docTimestamp"/>
						   <xsl:attribute name="version" select="delta/ProductsMsg[1]/@version"/>
							<Product>
								<CTN><xsl:value-of select="replace($ctn,'_','/')" /></CTN>
									 <!-- Merge all assets from inbox files + cache and copy the most recent version for every type/locale -->
								<xsl:for-each-group select="*/ProductsMsg/Product/Asset" group-by="concat(ResourceType, '-', Language)">
								  <xsl:sort select="ResourceType" order="ascending"/>
								  <xsl:sort select="Language" order="ascending"/>
								  <xsl:for-each select="current-group()">
									<xsl:sort select="Modified" order="descending"/>
									<xsl:if test="position() = 1">
									  <xsl:apply-templates select="."/>
									</xsl:if>
								  </xsl:for-each>
								</xsl:for-each-group>
							</Product>
						</ProductsMsg>
					</delta>
				  <xsl:apply-templates select="cache"/>
				</xsl:when>
				<xsl:otherwise>
					<delta>
						<ProductsMsg>
						   <xsl:attribute name="docTimestamp" select="delta/ProductsMsg[1]/@docTimestamp"/>
						   <xsl:attribute name="version" select="delta/ProductsMsg[1]/@version"/>
							<Product>
								<CTN><xsl:value-of select="replace($ctn,'_','/')" /></CTN>
									 <!-- Merge all assets from inbox files + cache and copy the most recent version for every type/locale -->
								<xsl:for-each-group select="*/ProductsMsg/Product/Asset" group-by="concat(ResourceType, '-', Language)">
								  <xsl:sort select="ResourceType" order="ascending"/>
								  <xsl:sort select="Language" order="ascending"/>
								  <xsl:for-each select="current-group()">
									<xsl:sort select="Modified" order="descending"/>
									<xsl:if test="position() = 1">
									  <xsl:apply-templates select="."/>
									</xsl:if>
								  </xsl:for-each>
								</xsl:for-each-group>
							</Product>
						</ProductsMsg>
					</delta>
					<cache>
					<xsl:apply-templates select="cache/ProductsMsg" mode="merge"/>
					</cache>
				</xsl:otherwise>
			</xsl:choose>
			</root>
		</xsl:copy>	
	</xsl:template>
  
	<xsl:template match="ProductsMsg" mode="merge">
		<xsl:copy copy-namespaces="no">
		  <xsl:apply-templates select="@*"/>
		  <xsl:apply-templates select="Product" mode="merge">
			<xsl:with-param name="cached-assets" select="following-sibling::ProductsMsg/Product/Asset"/>
		  </xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="Product" mode="merge">
		<xsl:param name="cached-assets"/>
		<xsl:copy>
		  <xsl:apply-templates select="@*|node()"/>
		  <!-- Add cached assets that are not in the inbox Product to get a full Asset list for the product -->
		  <xsl:apply-templates select="for $a in $cached-assets
									   return
										if (empty(Asset[ResourceType=$a/ResourceType][Language=$a/Language]))
										then
										  $a
										else
										  ()"/>
		</xsl:copy>
	</xsl:template>
  
</xsl:stylesheet>