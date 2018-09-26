<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:assets="http://www.w3.org/1999/XSL/Transform/assets"
				>
  
<xsl:output method="xml" version="1.0" encoding="UTF-8" />  

<xsl:param name="sourceDir"/>
<xsl:param name="directoryName" />
<xsl:param name="ctn" />
  <!-- Merges the assets from multiple ProductMsg and includes the cache contents for the CTN.
  - ProductMsg attributes are set to the most recent found in the input
  -->   
  
	  <xsl:template match="node()|@*" >
		<xsl:copy copy-namespaces="no">
		  <xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	  </xsl:template>
  
	<xsl:template match="//directory">
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
		  <source:source>
			<xsl:value-of select="concat($sourceDir,'/',$directoryName,'/',$ctn)" />
			<xsl:text>.xml</xsl:text>
		  </source:source>
		  <source:fragment>
		  <ProductsMsg>
		  <xsl:attribute name="docTimestamp" select="ProductsMsg[1]/@docTimestamp"/>
		<xsl:attribute name="version" select="ProductsMsg[1]/@version"/>
		  <Product>
			<CTN><xsl:value-of select="replace($ctn,'_','/')" /></CTN>
			<xsl:apply-templates select="ProductsMsg/Product/Asset" />
			</Product>
			</ProductsMsg>
		  </source:fragment>
		</source:write>
	</xsl:template>
  
	<xsl:template match="Asset">
	  <xsl:copy copy-namespaces="no">
		  <xsl:for-each select="child::node()">
			<xsl:copy-of select="."/> 
		  </xsl:for-each>
		</xsl:copy>		
  	</xsl:template>
		
</xsl:stylesheet>