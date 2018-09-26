<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:saxon="http://saxon.sf.net/"
	exclude-result-prefixes="sql xsl">
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="ts"/>
	<xsl:variable name="translatedAttributes" select="//globalDocs/translatedAttributes/root/translatedAttribute"/> 
	<xsl:variable name="division" select="//globalDocs/division"/>
	<xsl:variable name="CatalogCode" select="//CatalogCode"/>

	<xsl:template match="root">
			<xsl:apply-templates select="@*|node()"/>
	</xsl:template>   
  
	<!--  -->
  <xsl:template match="entries">
    <entries>   
	    <xsl:attribute name="docStatus" select="'translationExport'"/>
  		<xsl:attribute name="docTimeStamp"><xsl:value-of select="concat(substring(@ts,1,8),'T',substring(@ts,9,4))"/></xsl:attribute>
  		<xsl:attribute name="preview">xucdm-combined-multi-view.xsl</xsl:attribute>
  		<xsl:attribute name="priority">3</xsl:attribute>
  		<xsl:attribute name="routingCode">Default/<xsl:value-of select="$CatalogCode"/></xsl:attribute>
  		<xsl:attribute name="routingName">Default</xsl:attribute>
  		<xsl:attribute name="sourceLocale">en_US</xsl:attribute>
  		<xsl:attribute name="targetLocale"><xsl:value-of select="@l"/></xsl:attribute>
  		<xsl:attribute name="translationTagVersion">1.0</xsl:attribute>          
  		<xsl:attribute name="type">xUCDM-cat</xsl:attribute>    
			<xsl:attribute name="workflow"><xsl:value-of select="'CL_CMC'"/></xsl:attribute>            
      <xsl:apply-templates select="@*[not(local-name()='routingCode')]|node()"/>
    </entries>     
   </xsl:template>
    
  <xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template> 
  
	<xsl:template match="Categorization">
		<xsl:variable name="lastModified" select="../../../@ts"/>
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*[not(local-name()='DocTimeStamp')]"/>
			<xsl:attribute name="docStatus">translationExport</xsl:attribute>
			<xsl:attribute name="docTimeStamp"><xsl:value-of select="concat(substring($lastModified,1,8),'T',substring($lastModified,9,4))"/></xsl:attribute>
			<xsl:attribute name="preview">xucdm-combined-multi-view.xsl</xsl:attribute>
			<xsl:attribute name="priority">3</xsl:attribute>
			<xsl:attribute name="routingCode">Default</xsl:attribute>
			<xsl:attribute name="routingName">Default</xsl:attribute>
			<xsl:attribute name="sourceLocale">en_US</xsl:attribute>
			<xsl:attribute name="targetLocale"><xsl:value-of select="/entries/@l"/></xsl:attribute>
			<xsl:attribute name="translationTagVersion">1.0</xsl:attribute>          
			<xsl:attribute name="type">xUCDM-cat</xsl:attribute>
			<xsl:attribute name="workflow"><xsl:value-of select="'CL_CMC'"/></xsl:attribute>            
			<xsl:variable name="catalog" select="../../@category"/>
			<xsl:apply-templates select="node()" mode="parse">
        <xsl:with-param name="catalog" select="$catalog"/>
      </xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	<!--  -->

	<!--  -->  

	<!--  -->  
	<xsl:template match="@*|node()" mode="parse">
    <xsl:param name="catalog"/>
		<xsl:variable name="nodeName" select="local-name()"/>
		<!-- Check if current node is translated attribute by retrieving a translated attribute from the translated attributes list for which the name is equal to the current node name -->
		<!-- Only return the first match. VersionElementName is listed three times in the translated attribute list for instance. We only want one result -->
		<xsl:variable name="translatedAttribute" select="$translatedAttributes[@name eq $nodeName][position() = 1]"/>
		<xsl:choose>
			<!-- Check if current node is a translated attribute and if it's not empty. (Empty nodes are not translated) -->
			<xsl:when test="count($translatedAttribute) > 0 and string() != ''">
				<!-- This is a translated element. Replace the current element by the newly created element enriched with translation meta attributes. And process the child elements -->
				<xsl:copy copy-namespaces="no">
					<!-- Generate a key attribute. The value consists of a key and the corresponding code which can be obtained by evaluating the xpath expression in the codeXPath attribute -->
					<xsl:attribute name="key">
            <xsl:choose>
              <xsl:when test="local-name() = 'CatalogName'">
                <xsl:value-of select="$catalog"/>
              </xsl:when>
              <xsl:when test="local-name() = 'GroupSeoName' or local-name() = 'CategorySeoName' or local-name() = 'SubCategorySeoName'">
                <xsl:value-of select="$catalog"/>_<xsl:value-of select="saxon:evaluate($translatedAttribute/@codeXPath)"/>
                <xsl:text>_SEONAME</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$catalog"/>_<xsl:value-of select="saxon:evaluate($translatedAttribute/@codeXPath)"/>
              </xsl:otherwise>                
            </xsl:choose>
          </xsl:attribute>			            
					<!-- Now copy all the meta attributes -->
					<xsl:copy-of copy-namespaces="no" select="$translatedAttribute/metaAttributes/@*"/>
					<!-- Process all child elements -->
					<xsl:apply-templates select="node()" mode="parse">
            <xsl:with-param name="catalog" select="$catalog"/>
          </xsl:apply-templates>          
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<!-- This is not a translated element. Just shallow copy the element and process the child attributes and elements -->
				<xsl:copy copy-namespaces="no">
					<xsl:apply-templates select="@*|node()" mode="parse">
            <xsl:with-param name="catalog" select="$catalog"/>
          </xsl:apply-templates>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--  -->
  
</xsl:stylesheet>
