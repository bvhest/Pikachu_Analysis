<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:saxon="http://saxon.sf.net/"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="sql xsl">
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ts"/>
  <xsl:param name="workflow"/>  
  <xsl:variable name="translatedAttributes" select="//globalDocs/translatedAttributes/root/translatedAttribute"/> 
  <xsl:variable name="division" select="//entries/entry[1]/content/PackagingText/@division"/>

  <xsl:template match="root">
      <xsl:apply-templates select="@*|node()"/>
  </xsl:template>   
  
  <!--  -->
  <xsl:template match="entries">
    <entries>      
      <xsl:apply-templates select="@*[not(local-name()='category' or local-name()='routingCode' or local-name()='routingName')]"/>
      <xsl:attribute name="category"><xsl:value-of select="entry[1]/content/PackagingText/@category"/></xsl:attribute>      
      <xsl:attribute name="docStatus" select="'translationExport'"/>
      <xsl:attribute name="docTimeStamp"><xsl:value-of select="concat(substring(@ts,1,8),'T',substring(@ts,9,4))"/></xsl:attribute>
      <xsl:attribute name="preview">xucdm-combined-multi-view.xsl</xsl:attribute>
      <xsl:attribute name="priority">1</xsl:attribute>
      <xsl:attribute name="routingCode"><xsl:value-of select="entry[1]/content/PackagingText/@routingCode"/></xsl:attribute>
      <xsl:attribute name="routingName"><xsl:value-of select="entry[1]/content/PackagingText/@routingName"/></xsl:attribute>
      <xsl:attribute name="sourceLocale">en_US</xsl:attribute>
      <xsl:attribute name="targetLocale"><xsl:value-of select="@l"/></xsl:attribute>
      <xsl:attribute name="translationTagVersion">1.0</xsl:attribute>          
      <xsl:attribute name="type">xUCDM-package</xsl:attribute>
      <xsl:attribute name="workflow"><xsl:value-of select="if($workflow!='') then $workflow else 'CL_CMC'"/></xsl:attribute>      
      <xsl:apply-templates select="node()"/>
    </entries>     
   </xsl:template>
    
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template> 
  
  <xsl:template match="PackagingText">
    <xsl:variable name="lastModified" select="../../../@ts"/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*[not(local-name()='DocTimeStamp')]"/>
      <xsl:attribute name="docStatus">translationExport</xsl:attribute>
      <xsl:attribute name="docTimeStamp"><xsl:value-of select="concat(substring($lastModified,1,8),'T',substring($lastModified,9,4))"/></xsl:attribute>
      <xsl:attribute name="preview">xucdm-combined-multi-view.xsl</xsl:attribute>
      <xsl:attribute name="priority">1</xsl:attribute>
      <xsl:attribute name="routingCode"><xsl:value-of select="@routingCode"/></xsl:attribute>
      <xsl:attribute name="routingName"><xsl:value-of select="@routingName"/></xsl:attribute>
      <xsl:attribute name="sourceLocale">en_US</xsl:attribute>
      <xsl:attribute name="targetLocale"><xsl:value-of select="/entries/@l"/></xsl:attribute>
      <xsl:attribute name="translationTagVersion">1.0</xsl:attribute>          
      <xsl:attribute name="type">xUCDM-package</xsl:attribute>
      <xsl:attribute name="workflow"><xsl:value-of select="if($workflow!='') then $workflow else 'CL_CMC'"/></xsl:attribute>                        
      <xsl:if test="/entries/@seo = 'yes'">
         <xsl:attribute name="seo" select="'yes'" />
      </xsl:if>
      <xsl:apply-templates select="node()" mode="parse"/>
    </xsl:copy>
  </xsl:template>
  <!--  -->  
  <xsl:template match="@*|node()" mode="parse">
    <xsl:variable name="nodeName" select="local-name()"/>
    <!-- Check if current node is translated attribute by retrieving a translated attribute from the translated attributes list for which the name is equal to the current node name -->
    <!-- Only return the first match. VersionElementName is listed three times in the translated attribute list for instance. We only want one result -->
    <xsl:variable name="translatedAttribute" select="if($translatedAttributes[@name eq $nodeName and @itemDescription = current()/../@itemDescription])
                                                     then $translatedAttributes[@name eq $nodeName and @itemDescription = current()/../@itemDescription][position() = 1]
                                                     else $translatedAttributes[@name eq $nodeName][position() = 1]"/>
    <xsl:choose>
      <!-- Check if current node is a translated attribute and if it's not empty. (Empty nodes are not translated) -->
      <xsl:when test="count($translatedAttribute) > 0 and string() != ''">
        <!-- This is a translated element. Replace the current element by the newly created element enriched with translation meta attributes. And process the child elements -->
        <source>
          <xsl:copy-of select="." copy-namespaces="no"/>
        </source>
        <xsl:copy copy-namespaces="no">
        <xsl:attribute name="key"><xsl:value-of select="'Package'"/></xsl:attribute>                  
        <!-- Now copy all the meta attributes -->
        <xsl:copy-of copy-namespaces="no" select="$translatedAttribute/metaAttributes/@*"/>
        <xsl:if test="../@itemDescription = $translatedAttribute/@itemDescription">
          <xsl:copy-of select="$translatedAttribute/@cpyw"/>
        </xsl:if>
        <xsl:attribute name="maxlength" select="number(ceiling(current()/../@maxLength * 1.30))" as="xs:integer"/>
          <!-- Process all child elements -->
          <xsl:apply-templates select="node()" mode="parse"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <!-- This is not a translated element. Just shallow copy the element and process the child attributes and elements -->
        <xsl:copy copy-namespaces="no">
          <xsl:apply-templates select="@*|node()" mode="parse"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--  -->
  
</xsl:stylesheet>