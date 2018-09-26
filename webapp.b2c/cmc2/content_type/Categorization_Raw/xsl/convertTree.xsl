<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ChildCategories">
    <xsl:apply-templates select="@*|node()" />
  </xsl:template>

  <xsl:template match="ExtendedCategorization|ChildProducts|Products" />

  <xsl:template match="FixedCategorization">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
      <!--Move extended into fixed space -->
      <xsl:apply-templates select="../ExtendedCategorization/Node" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ExtendedCategorization/Node[ChildCategories]">
    <Group>
      <GroupCode><xsl:value-of select="@Code" /></GroupCode>
      <GroupReferenceName><xsl:value-of select="@Name" /></GroupReferenceName>
      <GroupName><xsl:value-of select="@Name" /></GroupName>
      <GroupRank><xsl:value-of select="@Rank" /></GroupRank>
      <xsl:for-each select="ChildCategories/Node">
        <Category>
	        <xsl:if test="@type != '' ">
	            <xsl:attribute name="type" select="@type"/>
	        </xsl:if>  
          <CategoryCode><xsl:value-of select="@Code" /></CategoryCode>
          <CategoryReferenceName><xsl:value-of select="@Name" /></CategoryReferenceName>
          <CategoryName><xsl:value-of select="@Name" /></CategoryName>
          <CategorySeoName><xsl:value-of select="@CategorySeoName" /></CategorySeoName>
          <CategoryRank><xsl:value-of select="@Rank" /></CategoryRank>
          <xsl:apply-templates select="node()" />
        </Category>
      </xsl:for-each>
    </Group>
  </xsl:template>

  <xsl:template match="ExtendedCategorization/Node/ChildCategories/Node/ChildCategories/Node[ChildCategories]">
    <L3>
      <L3Code><xsl:value-of select="@Code" /></L3Code>
      <L3ReferenceName><xsl:value-of select="@Name" /></L3ReferenceName>
      <L3Name><xsl:value-of select="@Name" /></L3Name>
      <L3Rank><xsl:value-of select="@Rank" /></L3Rank>
      <xsl:apply-templates select="node()" />
    </L3>
  </xsl:template>

  <xsl:template match="ExtendedCategorization/Node/ChildCategories/Node/ChildCategories/Node/ChildCategories/Node[ChildCategories]">
    <L4>
      <L4Code><xsl:value-of select="@Code" /></L4Code>
      <L4ReferenceName><xsl:value-of select="@Name" /></L4ReferenceName>
      <L4Name><xsl:value-of select="@Name" /></L4Name>
      <L4Rank><xsl:value-of select="@Rank" /></L4Rank>
      <xsl:apply-templates select="node()" />
    </L4>
  </xsl:template>
  <xsl:template match="ExtendedCategorization/Node/ChildCategories/Node/ChildCategories/Node/ChildCategories/Node/ChildCategories/Node[ChildCategories]">
    <L5>
      <L5Code><xsl:value-of select="@Code" /></L5Code>
      <L5ReferenceName><xsl:value-of select="@Name" /></L5ReferenceName>
      <L5Name><xsl:value-of select="@Name" /></L5Name>
      <L5Rank><xsl:value-of select="@Rank" /></L5Rank>
      <xsl:apply-templates select="node()" />
    </L5>
  </xsl:template>
  <xsl:template match="ExtendedCategorization/Node/ChildCategories/Node/ChildCategories/Node/ChildCategories/Node/ChildCategories/Node/ChildCategories/Node[ChildCategories]">
    <L6>
      <L6Code><xsl:value-of select="@Code" /></L6Code>
      <L6ReferenceName><xsl:value-of select="@Name" /></L6ReferenceName>
      <L6Name><xsl:value-of select="@Name" /></L6Name>
      <L6Rank><xsl:value-of select="@Rank" /></L6Rank>
      <xsl:apply-templates select="node()" />
    </L6>
  </xsl:template>


  <xsl:template match="Node[not(ChildCategories)]">
    <SubCategory status="Active">
      <SubCategoryCode><xsl:value-of select="@Code" /></SubCategoryCode>
      <SubCategoryReferenceName><xsl:value-of select="@Name" /></SubCategoryReferenceName>
      <SubCategoryName><xsl:value-of select="@Name" /></SubCategoryName>
      <SubCategoryRank><xsl:value-of select="@Rank" /></SubCategoryRank>
      <xsl:apply-templates select="node()" />
    </SubCategory>
  </xsl:template>

  <xsl:template match="/ProductTree">
    <Categorization DocTimeStamp="{@DocTimeStamp}">
      <Catalog Language="en" IsMaster="false">
        <CatalogCode>ProductTree</CatalogCode>
        <CatalogName>ProductTree</CatalogName>
        <CatalogType />
        <FixedCategorization>
          <xsl:for-each select="ProductDivision">
            <xsl:variable name="rank" select="position()" />
            <xsl:call-template name="ProductDivision">
              <xsl:with-param name="rank" select="$rank" />
            </xsl:call-template>
          </xsl:for-each>
        </FixedCategorization>
      </Catalog>
    </Categorization>
  </xsl:template>

  <xsl:template name="ProductDivision">
    <xsl:param name="rank" />
    <ProductDivision>
      <ProductDivisionCode><xsl:value-of select="ProductDivisionCode" /></ProductDivisionCode>
      <ProductDivisionName><xsl:value-of select="ProductDivisionName" /></ProductDivisionName>
      <ProductDivisionRank><xsl:value-of select="$rank" /></ProductDivisionRank>
      <xsl:for-each select="BusinessGroup">
        <xsl:variable name="rank" select="position()" />
        <xsl:call-template name="BusinessGroup">
          <xsl:with-param name="rank" select="$rank" />
        </xsl:call-template>
      </xsl:for-each>
    </ProductDivision>
  </xsl:template>

  <xsl:template name="BusinessGroup">
    <xsl:param name="rank" />
    <BusinessGroup>
      <BusinessGroupCode><xsl:value-of select="BusinessGroupCode" /></BusinessGroupCode>
      <BusinessGroupName><xsl:value-of select="BusinessGroupName" /></BusinessGroupName>
      <BusinessGroupRank><xsl:value-of select="$rank" /></BusinessGroupRank>
      <xsl:for-each select="BusinessUnit">
        <xsl:variable name="rank" select="position()" />
        <xsl:call-template name="BusinessUnit">
          <xsl:with-param name="rank" select="$rank" />
        </xsl:call-template>
      </xsl:for-each>
    </BusinessGroup>
  </xsl:template>

  <xsl:template name="BusinessUnit">
    <xsl:param name="rank" />
    <Group>
      <GroupCode><xsl:value-of select="BusinessUnitCode" /></GroupCode>
      <GroupReferenceName><xsl:value-of select="BusinessUnitName" /></GroupReferenceName>
      <GroupName><xsl:value-of select="BusinessUnitName" /></GroupName>
      <GroupRank><xsl:value-of select="$rank" /></GroupRank>
      <xsl:for-each select="MainArticleGroup">
        <xsl:variable name="rank" select="position()" />
        <xsl:call-template name="MainArticleGroup">
          <xsl:with-param name="rank" select="$rank" />
        </xsl:call-template>
      </xsl:for-each>
    </Group>
  </xsl:template>

  <xsl:template name="MainArticleGroup">
    <xsl:param name="rank" />
    <Category>
      <xsl:if test="@type != '' ">
          <xsl:attribute name="type" select="@type"/>
      </xsl:if>  
      <CategoryCode><xsl:value-of select="MainArticleGroupCode" /></CategoryCode>
      <CategoryReferenceName><xsl:value-of select="MainArticleGroupName" /></CategoryReferenceName>
      <CategoryName><xsl:value-of select="MainArticleGroupName" /></CategoryName>
      <CategorySeoName><xsl:value-of select="@CategorySeoName" /></CategorySeoName>
      <CategoryRank><xsl:value-of select="$rank" /></CategoryRank>
      <xsl:for-each select="ArticleGroup">
        <xsl:variable name="rank" select="position()" />
        <xsl:call-template name="ArticleGroup">
          <xsl:with-param name="rank" select="$rank" />
        </xsl:call-template>
      </xsl:for-each>
    </Category>
  </xsl:template>

  <xsl:template name="ArticleGroup">
    <xsl:param name="rank" />
    <SubCategory status="active">
      <SubCategoryCode><xsl:value-of select="ArticleGroupCode" /></SubCategoryCode>
      <SubCategoryReferenceName><xsl:value-of select="ArticleGroupName" /></SubCategoryReferenceName>
      <SubCategoryName><xsl:value-of select="ArticleGroupName" /></SubCategoryName>
      <SubCategoryRank><xsl:value-of select="$rank" /></SubCategoryRank>
    </SubCategory>
  </xsl:template>
</xsl:stylesheet>
