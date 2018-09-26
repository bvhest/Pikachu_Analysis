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
  
  <!--  -->
  
  <xsl:template match="entries">
    <entries>
      <xsl:attribute name="docStatus" select="'translationExport'"/>
      <!--xsl:attribute name="batchnumber" select="@batchnumber"/-->
      <xsl:attribute name="docTimeStamp"><xsl:value-of select="concat(substring(@ts,1,8),'T',substring(@ts,9,4))"/></xsl:attribute>
       <xsl:attribute name="preview"><xsl:value-of select="'xucdm-combined-multi-view.xsl'"/></xsl:attribute>
      <xsl:attribute name="priority"><xsl:value-of select="@priority"/></xsl:attribute>
      <xsl:attribute name="category"><xsl:value-of select="entry[1]/@category"/></xsl:attribute>      
      <xsl:attribute name="routingCode"><xsl:value-of select="entry[1]/@routingCode"/></xsl:attribute>
      <xsl:attribute name="routingName"><xsl:value-of select="entry[1]/@routingName"/></xsl:attribute>
      <xsl:attribute name="sourceLocale"><xsl:value-of select="'en_US'"/></xsl:attribute>
      <xsl:attribute name="targetLocale"><xsl:value-of select="@l"/></xsl:attribute>
      <xsl:attribute name="translationTagVersion"><xsl:value-of select="'1.6'"/></xsl:attribute>          
      <xsl:attribute name="type"><xsl:value-of select="'xUCDM-RangeText'"/></xsl:attribute>
      <xsl:attribute name="workflow"><xsl:value-of select="'CL_CMC'"/></xsl:attribute>      
      <xsl:attribute name="translationOrg"><xsl:value-of select="'SDL'"/></xsl:attribute>
      <xsl:attribute name="copywritingOrg"><xsl:value-of select="'SDL'"/></xsl:attribute>      
      <xsl:apply-templates select="@*[not(local-name()='routingCode' or local-name()='routingName' or local-name()='category')]|node()"/>
    </entries>     
   </xsl:template>
  
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>  
  
  <xsl:template match="Node">
    <xsl:variable name="lastModified" select="../../@ts"/>
    <xsl:element name="Node">
    <!--
      <xsl:attribute name="Division" select="$division"/>
      <xsl:attribute name="Brand" select="NamingString/MasterBrand/BrandCode"/>
      -->
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="node()" mode="RangeText"/>
    </xsl:element>
  </xsl:template>
  <!--  -->
  <xsl:template match="node()|@*" mode="RangeText">
    <xsl:variable name="nodeName" select="local-name()"/>
    <xsl:variable name="objecttype" select="'RangeText'"/>
    <!-- Check if current node is translated attribute by retrieving a translated attribute from the translated attributes list for which the name is equal to the current node name -->
    <!-- Only return the first match. VersionElementName is listed three times in the translated attribute list for instance. We only want one result -->
    
    <!-- PMT_Translated: 
    <xsl:variable name="translatedAttribute" select="$translatedAttributes[@name eq $nodeName][position() = 1]"/>
    -->
    <!-- Range: -->
    <xsl:variable name="translatedAttribute" select="if($translatedAttributes[@name eq $nodeName and @itemDescription = concat($objecttype, '_', $nodeName)])
                                                     then $translatedAttributes[@name eq $nodeName and @itemDescription = concat($objecttype, '_', $nodeName)][position() = 1]
                                                     else $translatedAttributes[@name eq $nodeName][position() = 1]"/>    
    
    
    <xsl:choose>
      <!-- Check if current node is a translated attribute and if it's not empty. (Empty nodes are not translated) -->
      <xsl:when test="count($translatedAttribute) > 0 and string() != ''">
        <!-- This is a translated element. Replace the current element by the newly created element enriched with translation meta attributes. And process the child elements -->
        <xsl:copy copy-namespaces="no" select=".">
          <!-- Generate a key attribute. The value consists of a key and the corresponding code which can be obtained by evaluating the xpath expression in the codeXPath attribute -->
          <xsl:attribute name="key"><xsl:value-of select="$translatedAttribute/@key"/>_<xsl:value-of select="saxon:evaluate($translatedAttribute/@codeXPath)"/></xsl:attribute>
          <!-- Now copy all the meta attributes -->
          <xsl:copy-of copy-namespaces="no" select="$translatedAttribute/metaAttributes/@*"/>
          <!-- Process all child elements -->
          <xsl:apply-templates select="node()" mode="Product"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <!-- This is not a translated element. Just shallow copy the element and process the child attributes and elements -->
        <xsl:copy copy-namespaces="no" select=".">
          <xsl:apply-templates select="@*|node()" mode="RangeText"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--  -->
  
</xsl:stylesheet>