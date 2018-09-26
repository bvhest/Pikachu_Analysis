<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"  xmlns:my="http://www.philips.com/nvrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" extension-element-prefixes="my str"   xmlns:str="http://exslt.org/strings"
  exclude-result-prefixes="str">
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:param name="filename"/>
  
  <!-- -->    
   <xsl:template match="root">
	   <xsl:copy>			
			<xsl:apply-templates select="node()|@*"/>
	   </xsl:copy>
  </xsl:template>  
  <!-- -->    

  <xsl:template match="Products">
		<xsl:variable name="vProductsAttrs">
			<ProductAttrs>
				<xsl:copy-of select="@*"/>
			</ProductAttrs>
		</xsl:variable>   
    <xsl:variable name="vProducts" select="Product"/>
    <!-- Retrieve all store locales into all-locales (note: will contain duplicates) -->
    <xsl:variable name="all-locales">       
      <xsl:for-each select="Product/@StoreLocales">
        <xsl:for-each select="tokenize(.,',')">
          <locale><xsl:copy-of select="."/></locale>    
        </xsl:for-each>
      </xsl:for-each>        
    </xsl:variable>
    <!-- Eliminate duplicates and store in distinct-locales -->
    <xsl:variable name="distinct-locales">
      <xsl:for-each select="$all-locales/locale[not(text()=preceding-sibling::locale/text())]">
        <xsl:copy-of select="."/>
      </xsl:for-each>
    </xsl:variable>
    
    <!-- Iterate over the list of distinct store locales - create a <Products> element per locale -->
    <xsl:for-each select="$distinct-locales/locale">
      <xsl:variable name="vLocale" select="."/>
			<Products>      
        <xsl:copy-of select="$vProductsAttrs/ProductAttrs/@*[not(local-name()='targetLocale' or local-name()='l')]"/>
        <xsl:attribute name="l" select="."/>
				<xsl:attribute name="targetLocale" select="."/>
        
      <originalentriesattributes>
        <xsl:for-each select="$vProductsAttrs/ProductAttrs/@*">
          <xsl:element name="{local-name()}"><xsl:value-of select="."/></xsl:element>
        </xsl:for-each>
        <filename><xsl:value-of select="$filename"/></filename>
        <fileobjectcount><xsl:value-of select="count($vProducts)"/></fileobjectcount>
      </originalentriesattributes>        
        
        
        <xsl:for-each select="$vProducts">
          <xsl:if test="contains(./@StoreLocales,$vLocale)">
            <xsl:copy-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </Products>
    </xsl:for-each>
  </xsl:template>  
  <!-- -->
  <xsl:template match="Categorization">
			<xsl:variable name="vCategorization">
					<xsl:copy-of select="."/>
			</xsl:variable> 
		   <xsl:for-each select="tokenize(@StoreLocales, ',' ) ">
			   <Categorization>
				   <xsl:copy-of select="$vCategorization/Categorization/@*[not(local-name()='targetLocale' or local-name()='l' or local-name()='StoreLocales')]"/>
					<xsl:attribute name="l" select="."/>
					<xsl:attribute name="targetLocale" select="."/>
                <originalentriesattributes>
                  <xsl:for-each select="$vCategorization/Categorization/@*[not(local-name() = 'Category' or local-name() = 'routingCode')]">
                    <xsl:element name="{local-name()}"><xsl:value-of select="."/></xsl:element>
                  </xsl:for-each>
                  <filename><xsl:value-of select="$filename"/></filename>
                  <category><xsl:value-of select="$vCategorization/Categorization/Catalog/CatalogCode"/></category>
                  <routingCode><xsl:value-of select="concat('Default/',$vCategorization/Categorization/Catalog/CatalogCode)"/></routingCode>
                  <fileobjectcount><xsl:value-of select="count($vCategorization)"/></fileobjectcount>
                </originalentriesattributes>   
      
   				   <xsl:copy-of select="$vCategorization/Categorization/node()"/>
			   </Categorization>				   
		   </xsl:for-each>
  </xsl:template>  
  <!-- -->
    <xsl:template match="PackagingText">
			<xsl:variable name="vContent">
					<xsl:copy-of select="."/>
			</xsl:variable> 
		   <xsl:for-each select="tokenize(@StoreLocales, ',' ) ">
			   <PackagingText>
				   <xsl:copy-of select="$vContent/PackagingText/@*[not(local-name()='targetLocale' or local-name()='languageCode' or local-name()='StoreLocales')]"/>
					<xsl:attribute name="languageCode" select="."/>
					<xsl:attribute name="targetLocale" select="."/>
                <originalentriesattributes>
                  <xsl:for-each select="$vContent/PackagingText/@*">
                    <xsl:element name="{local-name()}"><xsl:value-of select="."/></xsl:element>
                  </xsl:for-each>
                  <filename><xsl:value-of select="$filename"/></filename>
                  <fileobjectcount><xsl:value-of select="count($vContent/PackagingText)"/></fileobjectcount>
                </originalentriesattributes>             
          
   				   <xsl:copy-of select="$vContent/PackagingText/node()"/>
			   </PackagingText>				   
		   </xsl:for-each>
  </xsl:template>  
  
  <!-- -->

  <xsl:template match="Nodes">
		<xsl:variable name="vNodesAttrs">
			<NodeAttrs>
				<xsl:copy-of select="@*"/>
			</NodeAttrs>
		</xsl:variable>   
    <xsl:variable name="vNodes" select="Node"/>
    <!-- Retrieve all store locales into all-locales (note: will contain duplicates) -->
    <xsl:variable name="all-locales">       
      <xsl:for-each select="Node/@StoreLocales">
        <xsl:for-each select="tokenize(.,',')">
          <locale><xsl:copy-of select="."/></locale>    
        </xsl:for-each>
      </xsl:for-each>        
    </xsl:variable>
    <!-- Eliminate duplicates and store in distinct-locales -->
    <xsl:variable name="distinct-locales">
      <xsl:for-each select="$all-locales/locale[not(text()=preceding-sibling::locale/text())]">
        <xsl:copy-of select="."/>
      </xsl:for-each>
    </xsl:variable>
    
    <!-- Iterate over the list of distinct store locales - create a <Nodes> element per locale -->
    <xsl:for-each select="$distinct-locales/locale">
      <xsl:variable name="vLocale" select="."/>
			<Nodes>      
        <xsl:copy-of select="$vNodesAttrs/NodeAttrs/@*[not(local-name()='targetLocale' or local-name()='l')]"/>
        <xsl:attribute name="l" select="."/>
				<xsl:attribute name="targetLocale" select="."/>        
        <originalentriesattributes>
          <xsl:for-each select="$vNodesAttrs/NodeAttrs/@*">
            <xsl:element name="{local-name()}"><xsl:value-of select="."/></xsl:element>
          </xsl:for-each>
          <filename><xsl:value-of select="$filename"/></filename>
          <fileobjectcount><xsl:value-of select="count($vNodes)"/></fileobjectcount>
        </originalentriesattributes>                        
        <xsl:for-each select="$vNodes">
          <xsl:if test="contains(./@StoreLocales,$vLocale)">
            <xsl:copy-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </Nodes>
    </xsl:for-each>
  </xsl:template>    
  
  
</xsl:stylesheet>