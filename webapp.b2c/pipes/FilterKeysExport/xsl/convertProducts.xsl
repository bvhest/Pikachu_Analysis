<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql">
  
  <xsl:import href="../../common/xsl/xucdm-product-external.xsl"/>  
  <xsl:variable name="imagepath">noimagepath</xsl:variable> 
  
  <!--  -->
  <xsl:template match="sql:id|sql:language|sql:sop|sql:eop|sql:catalog|sql:groupcode|sql:groupname|sql:fans_data"/>
  <!--  -->
  <xsl:template match="sql:categorycode|sql:categoryname|sql:subcategorycode|sql:subcategoryname"/>
  <!--  -->
  <xsl:template match="sql:rowset[@name='cat']"/>
  <!--  -->
  <xsl:template name="OptionalHeaderAttributes">

    <xsl:attribute name="StartOfPublication" select="../../sql:sop"/>
    <xsl:attribute name="EndOfPublication" select="../../sql:eop"/>
    <xsl:attribute name="ListPrice"/>
    <xsl:attribute name="LocalGoingPrice" select="../../sql:local_going_price"/>
    <xsl:attribute name="OnlinePrice"/>
    <xsl:attribute name="Priority" select="../../sql:priority"/>
    <xsl:attribute name="BuyOnline" select="../../sql:buy_online"/>
    <xsl:attribute name="Deleted" select="../../sql:deleted"/>
    <xsl:attribute name="DeleteAfterDate" select="../../sql:delete_after_date"/>
    <xsl:attribute name="DivisionCode" select="../../sql:division"/>
    <!-- xsl:attribute name="MasterDescriptorBrandedFeatureString" select="../../sql:master_data/Product/NamingString/DescriptorBrandedFeatureString"/-->
    <xsl:attribute name="Catalog" select="../../sql:catalog"/>
    <xsl:attribute name="Locale" select="../../sql:locale"/>
    <xsl:attribute name="Country" select="../../sql:country"/>
    <xsl:variable  name="vlastexportdate" select="../../sql:lastexportdate"/>
    <xsl:attribute name="LastExportDate"><xsl:value-of select="concat(substring($vlastexportdate,1,10),'T',substring($vlastexportdate,12,8))"/></xsl:attribute>
  </xsl:template>
  <!--  -->
  <xsl:template name="OptionalFooterData">
       <xsl:param name="ctn" />
        <xsl:param name="language" />
        <xsl:param name="locale" />
    <xsl:for-each select="../../sql:fans_data/Product/NavigationGroup">
      <NavigationGroup>
        <xsl:apply-templates select="NavigationGroupCode|NavigationGroupName|NavigationGroupRank"/>
        <xsl:apply-templates select="NavigationAttribute">
          <xsl:sort data-type="number" select="NavigationAttribributeRank"/>
        </xsl:apply-templates>
      </NavigationGroup>
    </xsl:for-each>
  </xsl:template>
  <!--  -->
  <xsl:template match="NavigationAttribute">
    <NavigationAttribute>
      <xsl:apply-templates select="NavigationAttributeCode|NavigationAttributeName|NavigationAttributeRank"/>
      <xsl:apply-templates select="NavigationValue">
        <xsl:sort data-type="number" select="NavigationValueRank[1]"/>
      </xsl:apply-templates>
    </NavigationAttribute>
  </xsl:template>
  <!--  -->
  <xsl:template name="docatalogdata">
		<xsl:param name="sop" />
        <xsl:param name="eop" />
        <xsl:param name="sos" />
        <xsl:param name="eos" />
        <xsl:param name="rank" />
        <xsl:param name="deleted" />
        <xsl:param name="deleteafterdate"/>
   </xsl:template>
   
  <!--  -->
  <xsl:template name="docategorization">
   <xsl:param name="cats" />
   </xsl:template>
   
  <!--  -->
  <xsl:template name="OptionalHeaderData"> 
	  <xsl:param name="ctn"/>
        <xsl:param name="language"/>
        <xsl:param name="locale"/>
        <xsl:param name="division"/>
    <xsl:for-each select="../../sql:rowset[@name='cat']/sql:row">
      <Categorization>
        <GroupCode>
          <xsl:value-of select="sql:groupcode"/>
        </GroupCode>
        <GroupName>
          <xsl:value-of select="sql:groupname"/>
        </GroupName>
        <CategoryCode>
          <xsl:value-of select="sql:categorycode"/>
        </CategoryCode>
        <CategoryName>
          <xsl:value-of select="sql:categoryname"/>
        </CategoryName>
        <SubcategoryCode>
          <xsl:value-of select="sql:subcategorycode"/>
        </SubcategoryCode>
        <SubcategoryName>
          <xsl:value-of select="sql:subcategoryname"/>
        </SubcategoryName>
        <CatalogCode>
          <xsl:value-of select="sql:catalogcode"/>
        </CatalogCode>
      </Categorization>
    </xsl:for-each>
  </xsl:template>
  
    <xsl:template name="doAssets">
    <xsl:param name="id"/>
    <xsl:param name="language"/>
    <xsl:param name="locale"/>
    <xsl:param name="lastModified"/>
    <xsl:param name="catalogtype"/>
    </xsl:template>
   
  <!--  -->
</xsl:stylesheet>
