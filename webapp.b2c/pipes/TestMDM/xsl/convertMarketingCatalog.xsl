<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml ..\..\..\..\..\..\data\TestMDM\inbox\lcb_full_0300_20071018120000.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!--  -->
  <xsl:template match="/catalogs">
    <ProductsMsg version="1.0" docTimestamp="{@timestamp}">
      <xsl:for-each-group select="catalog/CatalogProduct" group-by="@CTN">
        <Product>
          <CTN>
            <xsl:value-of select="current-grouping-key()"/>
          </CTN>
          <xsl:for-each select="current-group()">
            <Catalog>
              <CatalogDestination>
                <xsl:value-of select="../@countryCode"/>
              </CatalogDestination>
              <CatalogType>
                <xsl:value-of select="../@catalogTypeName"/>
              </CatalogType>
              <CatalogDomain>Marketing</CatalogDomain>
              <CatalogCustomer>Philips</CatalogCustomer>
              <CatalogChannel>Web</CatalogChannel>
              <Publisher>LCB</Publisher>
              <StartDate>
                <xsl:value-of select="@start-of-publication"/>
              </StartDate>
              <EndDate>
                <xsl:value-of select="@end-of-publication"/>
              </EndDate>
              <Rank>
                <xsl:choose>
                  <xsl:when test="@priority = ''">
                    <xsl:text>50</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="@priority"/>
                  </xsl:otherwise>
                </xsl:choose>
              </Rank>
              <ProductInCatalogState>
                <xsl:choose>
                  <xsl:when test="@action = 'add'">
                    <xsl:text>Active</xsl:text>
                  </xsl:when>
                  <xsl:when test="@action = 'delete'">
                    <xsl:text>Deleted</xsl:text>
                  </xsl:when>
                </xsl:choose>
              </ProductInCatalogState>
            </Catalog>
          </xsl:for-each>
        </Product>
      </xsl:for-each-group>
    </ProductsMsg>
  </xsl:template>
  <!--  -->
</xsl:stylesheet>
