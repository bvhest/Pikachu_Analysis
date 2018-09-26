<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:saxon="http://saxon.sf.net/"
    extension-element-prefixes="fn saxon sql">
    
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>
  
  <!--
    Converts Product data to a CTN with Website navigation data.
    The navigation data that is added to a product is based on XPath expressions
    in the navigation rule file.
    The XPath expressions are evaluated with a Product as their context, using
    saxon:evaluate().
    When the XPath evaluates to TRUE the navigation data is added to the product.
    
    One drawback of using saxon:evaluate() is that is has to compile eacht XPath
    expression every time it is evaluated.
    Storing compiled XPath expressions using saxon:expression() is only possible
    using a variable. It is not possible to store a compiled XPath expression in
    a temporary node tree.
    
    The mode parameter can be
      'filter' to create the FilterGroup/-Key/-Value based enrichment
      'nav' to create the NavigationAttribute/-Value based enrichment 
  -->
  <xsl:param name="mode" select="'filter'"/>
  <xsl:variable name="filters" select="/entries/globalDocs/octl/sql:rowset/sql:row/sql:data/Filters"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
    
  <xsl:template match="globalDocs">
    <xsl:copy copy-namespaces="no"/>
  </xsl:template>
  
  <xsl:template match="Product">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="CTN"/>
      <xsl:choose>
        <xsl:when test="$mode='nav'">
          <xsl:apply-templates select="/entries/globalDocs/octl/sql:rowset/sql:row/sql:data/Filters"
                               mode="enrich-nav">
            <xsl:with-param name="product" select="."/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="/entries/globalDocs/octl/sql:rowset/sql:row/sql:data/Filters"
                               mode="enrich-filter">
            <xsl:with-param name="product" select="."/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  
  <!--
    Enrich products with Filter information ** new style ** 
  -->
  <xsl:template match="Filters" mode="enrich-filter">
    <xsl:param name="product"/>
    <xsl:variable name="matching-groups">
      <xsl:apply-templates select="FilterGroup" mode="enrich-filter">
        <xsl:with-param name="product" select="$product"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:if test="fn:exists($matching-groups/*)">
      <Filters>
        <xsl:copy-of select="$matching-groups"/>
      </Filters>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="FilterGroup" mode="enrich-filter">
    <xsl:param name="product"/>
    <xsl:variable name="matching-keys">
      <xsl:apply-templates select="FilterKeys/FilterKey" mode="enrich-filter">
        <xsl:with-param name="product" select="$product"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:if test="exists($matching-keys/*)">
      <FilterGroup>
        <xsl:copy-of select="@code|@referenceName|@rank|DisplayName|Glossary"/>
        <FilterKeys>
          <xsl:copy-of select="$matching-keys"/>
        </FilterKeys>
      </FilterGroup>
    </xsl:if>
  </xsl:template>
  
  <!--
    Either the FilterKey itself has an XPath element or it has FilterValues
    with XPath elements.
  -->
  <xsl:template match="FilterKey" mode="enrich-filter">
    <xsl:param name="product"/>
    <xsl:choose>
      <xsl:when test="XPath">
        <xsl:variable name="xpath" select="fn:concat('$p1[',XPath,']')"/>
        <xsl:variable name="xpath-result" select="saxon:evaluate($xpath, $product)"/>
        <xsl:if test="$xpath-result">
          <FilterKey>
            <xsl:copy-of select="@code|@referenceName|@rank|DisplayName|Glossary"/>
          </FilterKey>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="matching-values">
          <xsl:apply-templates select="FilterValues/FilterValue" mode="enrich-filter">
            <xsl:with-param name="product" select="$product"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:if test="exists($matching-values/*)">
          <xsl-copy-of select="UnitOfSortValue"/>
          <FilterValues>
            <xsl:copy-of select="$matching-values"/>
          </FilterValues>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="FilterValue" mode="enrich-filter">
    <xsl:param name="product"/>
    <xsl:if test="fn:string-length(XPath) > 0">
      <xsl:variable name="xpath" select="fn:concat('$p1[',XPath,']')"/>
      <xsl:variable name="xpath-result" select="saxon:evaluate($xpath, $product)"/>    
      <xsl:if test="$xpath-result">
        <FilterValue>
          <xsl:copy-of select="@code|@referenceName|@rank|DisplayName|Glossary|SortValue"/>
        </FilterValue>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!--
      |
      | Enrich products with NavigationGroup information ** old style **
      | 
      -->
  <xsl:template match="Filters" mode="enrich-nav">
    <xsl:param name="product"/>
    <xsl:variable name="matching-groups">
      <xsl:apply-templates select="FilterGroup" mode="enrich-nav">
        <xsl:with-param name="product" select="$product"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:if test="fn:exists($matching-groups/*)">
      <NavigationGroup>
        <NavigationGroupCode>navigation</NavigationGroupCode>
        <NavigationGroupName>Navigation</NavigationGroupName>
        <NavigationGroupRank>1</NavigationGroupRank>
        <xsl:copy-of select="$matching-groups"/>
      </NavigationGroup>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="FilterGroup" mode="enrich-nav">
    <xsl:param name="product"/>
    <xsl:variable name="matching-keys">
      <xsl:apply-templates select="FilterKeys/FilterKey" mode="enrich-nav">
        <xsl:with-param name="product" select="$product"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:if test="exists($matching-keys/*)">
      <NavigationAttribute>
        <NavigationAttributeCode><xsl:value-of select="@code"/></NavigationAttributeCode>
        <NavigationAttributeName><xsl:value-of select="DisplayName"/></NavigationAttributeName>
        <NavigationAttributeRank>1</NavigationAttributeRank>
        <xsl:copy-of select="$matching-keys"/>
      </NavigationAttribute>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="FilterKey" mode="enrich-nav">
    <xsl:param name="product"/>
    <xsl:variable name="xpath" select="fn:concat('$p1[',XPath,']')"/>
    <xsl:variable name="xpath-result" select="saxon:evaluate($xpath, $product)"/>
    <xsl:if test="$xpath-result">
      <NavigationValue>
        <NavigationValueCode><xsl:value-of select="@code"/></NavigationValueCode>
        <NavigationValueName><xsl:value-of select="DisplayName"/></NavigationValueName>
        <NavigationValueRank>1</NavigationValueRank>
      </NavigationValue>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
