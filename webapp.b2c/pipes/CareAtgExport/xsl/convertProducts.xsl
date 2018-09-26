<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!--  -->
  <xsl:template match="sql:id|sql:language|sql:sop|sql:eop|sql:catalog|sql:groupcode|sql:groupname|sql:asset_data"/>
  <!--  -->
  <xsl:import href="../../common/xsl/xucdm-internal.xsl"/>
  <!--  -->  
  <xsl:include href="../../../cmc2/xsl/common/cmc2.function.xsl"/>
  <!--  -->
  <xsl:param name="doctypesfilepath"/>
  <!--  -->
  <xsl:variable name="doctypesfile" select="document($doctypesfilepath)"/>
  <xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>
  <xsl:variable name="nonimagepath" select="'http://www.p4c.philips.com/cgi-bin/dcbint/get?id='"/>  
  <!--  -->
  <xsl:template match="sql:categorycode|sql:categoryname|sql:subcategorycode|sql:subcategoryname"/>
  <!--  -->
  <xsl:template match="sql:rowset[@name='cat']"/>
  <!--  -->
  <xsl:template name="OptionalHeaderAttributes">
    <xsl:attribute name="StartOfPublication" select="../../sql:sop"/>
    <xsl:attribute name="EndOfPublication" select="../../sql:eop"/>
    <xsl:attribute name="Deleted" select="../../sql:deleted"/>
    <xsl:attribute name="DeleteAfterDate" select="../../sql:delete_after_date"/>
    <xsl:attribute name="DivisionCode" select="../../sql:division"/>
    <xsl:attribute name="Catalog" select="../../sql:catalog"/>
  </xsl:template>
  <!--  -->
  <!--  Empty CSValueName -->  
  <xsl:template match="Product[count(CSChapter/CSItem/CSValue/CSValueCode) != count(CSChapter/CSItem/CSValue/CSValueName)]"/>
  <!--  Empty ProductName (bug in PFS) -->  
  <!--
  <xsl:template match="Product[ProductName='' and (not(NamingString/Descriptor/DescriptorName) or NamingString/Descriptor/DescriptorName = '')]"/>
-->
 
  <xsl:template name="OptionalFooterData">
    <xsl:for-each select="NavigationGroup">
      <NavigationGroup>
        <xsl:apply-templates select="NavigationGroupCode|NavigationGroupName|NavigationGroupRank"/>
        <xsl:apply-templates select="NavigationAttribute">
          <xsl:sort data-type="number" select="NavigationAttribributeRank"/>
        </xsl:apply-templates>      
      </NavigationGroup>
    </xsl:for-each>
    <xsl:apply-templates select="HasSoftwareAsset"/>
  </xsl:template>
  <!--  -->
  <xsl:template match="Asset">
<!-- care allow all assets to go through
	  <xsl:if test="ResourceType=$doctypesfile/doctypes/doctype[@ATG='yes']/@code and (PublicResourceIdentifier != '' 
                                                     or 
                                                   (   (not(PublicResourceIdentifier) or PublicResourceIdentifier = '') 
                                                        and 
                                                       (starts-with(Format,'image') or starts-with(Format,'movie')  or starts-with(Format,'video') or ResourceType='P3D' ) 
                                                   ) )">
-->
				<xsl:copy copy-namespaces="no">
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
<!--	care allow all assets to go through	  
	  </xsl:if>
-->
  </xsl:template>
  
  <xsl:template name="Assets">  
    <AssetList locale="{../../sql:locale}">
      <xsl:apply-templates select="AssetList/Asset"/>
    </AssetList>
	<xsl:apply-templates select="ObjectAssetList"/>
  </xsl:template>
  <!--  -->  
  <xsl:template match="NavigationAttribute">
    <NavigationAttribute>
      <xsl:apply-templates select="NavigationAttributeCode|NavigationAttributeName|NavigationAttributeRank"/>
      <xsl:apply-templates select="NavigationValue">
        <xsl:sort data-type="number" select="NavigationValueRank"/>
      </xsl:apply-templates>
    </NavigationAttribute>
  </xsl:template>  
  <!--  -->  
  <xsl:template name="OptionalHeaderData">
      <Categorization>
        <GroupCode>
          <xsl:value-of select="../../sql:groupcode"/>
        </GroupCode>
        <GroupName>
          <xsl:value-of select="../../sql:groupname"/>
        </GroupName>
        <CategoryCode>
          <xsl:value-of select="../../sql:categorycode"/>
        </CategoryCode>
        <CategoryName>
          <xsl:value-of select="../../sql:categoryname"/>
        </CategoryName>
        <SubcategoryCode>
          <xsl:value-of select="../../sql:subcategorycode"/>
        </SubcategoryCode>
        <SubcategoryName>
          <xsl:value-of select="../../sql:subcategoryname"/>
        </SubcategoryName>
      </Categorization>
      <CCR-ProductImage><xsl:value-of select="ProductImage"/></CCR-ProductImage>
  </xsl:template>
  <!--  -->
</xsl:stylesheet>
