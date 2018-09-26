<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">
   
<!-- 
  File Name : assets_localizer_convertor.xsl
  Description : Assets Localizer converter used to merge the assets localized content from localizer tool with PMT_Translated data
  XSD : xUCDM_product_localized_marketing_1_0_2.xsd              
  
  Version       Author      Date              Remark
   ____________________________________________________
  0.1           CJ          13-MAY-2013       Base Version
  
  -->   
    
  <xsl:template match="@*|node()">
   <xsl:copy copy-namespaces="no">
     <xsl:apply-templates select="@*|node()" />
   </xsl:copy>
  </xsl:template>
   
  <xsl:template match="octl[@ct='PMT_LocContent']"/>
  <xsl:template match="octl/@ct"/>
   
  <!-- Match Assets whose doctype is present in PMT_LocContent data -->  
  <xsl:template match="octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product 
                         [CTN=ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/CTN]
                       /AssetList/Asset
                         [ResourceType = ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product/Visuals/Visual/@doctype]"> 
   <!-- Get the matching localizer content for this asset -->
   <xsl:variable name="tmpLocContent" select="ancestor::content/octl[@ct='PMT_LocContent']/sql:rowset/sql:row/sql:data/Product
                                              /Visuals/Visual[@doctype=current()/ResourceType]"/>
      <xsl:choose>
        <!-- Ignore the master asset in case of a localizer update -->
        <xsl:when test="$tmpLocContent[@operation='update' and current()/Language='']"/>
        <!-- Copy the localized asset in case of a localizer update -->
        <xsl:when test="$tmpLocContent[@operation='update']">
          <xsl:next-match />
        </xsl:when>
        <!-- Ignore all assets in case of a localizer delete -->
        <xsl:when test="$tmpLocContent[@operation ='delete']"/>
        <xsl:otherwise>
          <xsl:next-match />
        </xsl:otherwise>
      </xsl:choose>         
    
  </xsl:template>  
  
</xsl:stylesheet>