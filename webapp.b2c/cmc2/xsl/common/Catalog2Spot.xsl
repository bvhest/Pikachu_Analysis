<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output name="output-def" method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="catalog">false</xsl:param>
  <xsl:param name="pmd">false</xsl:param>
  <xsl:param name="product">false</xsl:param>
  <xsl:param name="asset">false</xsl:param>
  <xsl:param name="keyvalue">false</xsl:param>
  <xsl:param name="milestone">false</xsl:param>
  <xsl:param name="svcURL"/>
  <!-- -->
  <xsl:template match="node()">
      <xsl:apply-templates select="node()"/>
  </xsl:template>
  <!--deep copy these-->
  <xsl:template match="@*|process|octl-attributes|result|entry[@valid='false']">
    <xsl:copy-of select="."/>
  </xsl:template>
  <!-- -->
  <!-- copy single level of these, then apply templates on childnodes-->
  <xsl:template match="entries|entry[@valid='true']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- MDM Catalog-->
  <!--Product>
    <CTN>170C6FS/00</CTN>
    <Catalog>
      <CatalogDestination>NL</CatalogDestination>
      <CatalogType>PMT_NL_Catalog</CatalogType>
      <CatalogDomain>DAP</CatalogDomain>
      <CatalogCustomer>CONSUMER</CatalogCustomer>
      <CatalogChannel>PMT_NL_Catalog</CatalogChannel>
      <ProductInCatalogState>active</ProductInCatalogState>
      <Publisher>Procoon</Publisher>
      <StartDate>2007-01-01T00:00:00</StartDate>
      <EndDate>2008-12-31T00:00:00</EndDate>
      <Rank/>
    </Catalog>
  </Product-->
  <xsl:template match="content">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <catalog-objects>
      <xsl:apply-templates select="octl/sql:rowset/sql:row/sql:data/catalog-definition/object"/>
      </catalog-objects>
    </xsl:copy>
  </xsl:template>
  <!-- -->
    <xsl:template match="object">
    <Product catalog="{$catalog}">
      <CTN><xsl:value-of select="@o"/></CTN>
      <Catalog>
        <CatalogType><xsl:value-of select="if (upper-case(customer_id) = 'PROFESSIONAL') then 'Professional' else 'Consumer'"/></CatalogType>
        <CatalogDestination><xsl:value-of select="country"/></CatalogDestination>
        <CatalogDomain><xsl:value-of select="'Marketing'"/></CatalogDomain>
        <CatalogCustomer><xsl:value-of select="if (upper-case(customer_id) = ('CONSUMER','PROFESSIONAL','CEE PRINTED CATALOG')) then 'Philips' else if (upper-case(customer_id) = 'MAGNAVOX CONSUMER') then 'Magnavox' else customer_id"/></CatalogCustomer>
        <CatalogChannel><xsl:value-of select="if (upper-case(customer_id) = ('CONSUMER','PROFESSIONAL','NORELCO' ,'NORELCO','WALITA','MASTER')) then 'ATG' else if (upper-case(customer_id) = 'CEE PRINTED CATALOG') then 'Paper catalog' else 'Syndication'"/></CatalogChannel>
        <Publisher><xsl:value-of select="'Procoon'"/></Publisher>
        <StartDate><xsl:value-of select="substring(sop,1,10)"/></StartDate>
        <EndDate><xsl:value-of select="substring(eop,1,10)"/></EndDate>
        <Rank><xsl:value-of select="if(priority='') then '0' else priority"/></Rank>
        <ProductInCatalogState><xsl:value-of select="if (deleted='1') then 'Deleted' else 'Active'"/></ProductInCatalogState>
      </Catalog>
    </Product>
  </xsl:template>

</xsl:stylesheet>