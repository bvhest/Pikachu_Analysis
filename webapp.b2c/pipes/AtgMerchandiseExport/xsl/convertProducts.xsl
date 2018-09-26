<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  exclude-result-prefixes="sql">

  <xsl:template match="sql:fans_data" />

  <xsl:template match="sql:rowset[@name='cat']" />
  
  <xsl:template match="sql:rowset[@name='product']">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="sql:rowset[@name='product']/sql:row">
    <Product>
      <!-- Ensure lastModified and masterLastModified have a 'T' in them -->
      <xsl:attribute name="lastModified" select="sql:lm" />
      <xsl:attribute name="masterLastModified" select="sql:mlm" />
      <xsl:call-template name="OptionalHeaderAttributes" />
      <CTN>
        <xsl:value-of select="sql:id" />
      </CTN>
      <xsl:for-each select="sql:rowset[@name='cat']/sql:row">
        <xsl:call-template name="OptionalHeaderData" />
      </xsl:for-each>
      <xsl:call-template name="OptionalFooterData" />
    </Product>
  </xsl:template>


  <xsl:template match="sql:categorycode|sql:categoryname|sql:subcategorycode|sql:subcategoryname" />

  <xsl:template name="OptionalHeaderAttributes">
    <xsl:attribute name="StartOfPublication" select="sql:sop" />
    <xsl:attribute name="EndOfPublication" select="sql:eop" />
    <xsl:attribute name="Deleted" select="sql:deleted" />
    <xsl:attribute name="DeleteAfterDate" select="sql:delete_after_date" />
    <xsl:attribute name="Catalog" select="sql:catalog" />
    <!--xsl:attribute name="Locale" select="sql:locale" / -->
       <!-- 2010-sep-03: 
         | Implemented in the AtgExport, AtgMerchandise, AtgProducts and AtgRanges.
         | Quick Fix because Atg can't deal with the Iso 'he_IL' locale (Java bug): replace 'he_IL' with 'iw_IL'. 
         -->
		<xsl:attribute name="Locale" select="if (sql:locale='he_IL') then 'iw_IL' else sql:locale"/>
    <xsl:attribute name="Country" select="sql:country" />
    <xsl:variable name="vlastexportdate" select="sql:lastexportdate" />
    <xsl:attribute name="LastExportDate"><xsl:value-of
      select="concat(substring($vlastexportdate,1,10),'T',substring($vlastexportdate,12,8))" /></xsl:attribute>
  </xsl:template>



  <xsl:template name="OptionalFooterData">
    <xsl:for-each select="sql:fans_data/Product/NavigationGroup">
      <NavigationGroup>
        <xsl:apply-templates select="NavigationGroupCode|NavigationGroupName|NavigationGroupRank" />
        <xsl:apply-templates select="NavigationAttribute">
          <xsl:sort data-type="number" select="NavigationAttribributeRank" />
        </xsl:apply-templates>
      </NavigationGroup>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="NavigationAttribute">
    <NavigationAttribute>
      <xsl:apply-templates select="NavigationAttributeCode|NavigationAttributeName|NavigationAttributeRank" />
      <xsl:apply-templates select="NavigationValue">
        <xsl:sort data-type="number" select="NavigationValueRank" />
      </xsl:apply-templates>
    </NavigationAttribute>
  </xsl:template>


  <xsl:template name="OptionalHeaderData">
    <Categorization>
      <GroupCode>
        <xsl:value-of select="sql:groupcode" />
      </GroupCode>
      <GroupName>
        <xsl:value-of select="sql:groupname" />
      </GroupName>
      <CategoryCode>
        <xsl:value-of select="sql:categorycode" />
      </CategoryCode>
      <CategoryName>
        <xsl:value-of select="sql:categoryname" />
      </CategoryName>
      <SubcategoryCode>
        <xsl:value-of select="sql:subcategorycode" />
      </SubcategoryCode>
      <SubcategoryName>
        <xsl:value-of select="sql:subcategoryname" />
      </SubcategoryName>
    </Categorization>
  </xsl:template>


  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
