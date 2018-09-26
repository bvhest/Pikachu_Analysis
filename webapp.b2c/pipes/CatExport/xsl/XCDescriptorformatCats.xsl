<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="cinclude xdt fn dir">
  <!-- -->
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:param name="exportdate"/>
  <xsl:variable name="ismaster" select="if($locale = 'MASTER') then 'true' else 'false'"/>
  <!-- -->
  <xsl:template match="/root">
  <xsl:variable name="docDate" select="concat(substring($exportdate,1,4),'-',substring($exportdate,5,2),'-', substring($exportdate,7,2),'T',substring($exportdate,10,2),':',substring($exportdate,12,2),':00' ) "/>
    <Categorization DocTimeStamp="{$docDate}" >
      <xsl:apply-templates select="sql:rowset"/>
    </Categorization>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:rowset">
    <xsl:for-each-group select="sql:row[sql:categorycode='DESCRIPTOR']" group-by="sql:catalogcode"> 
      <Catalog Locale='en_QQ' IsMaster="{$ismaster}">
        <CatalogCode>DESCRIPTOR</CatalogCode>
        <CatalogName>Descriptor</CatalogName>
        <CatalogType/>
        <FixedCategorization>
          <xsl:for-each-group select="current-group()" group-by="sql:groupcode">
            <Group>
              <GroupCode>
                <xsl:value-of select="current-grouping-key()"/>
              </GroupCode>
              <!-- <GroupReferenceName>
                <xsl:value-of select="sql:grouprefname"/>
              </GroupReferenceName> -->              
              <GroupName>
                <xsl:value-of select="sql:groupname"/>
              </GroupName>
              <GroupRank>
                <xsl:value-of select="sql:grouprank"/>
              </GroupRank>
              <xsl:for-each-group select="current-group()" group-by="sql:categorycode">
                <Category>
                  <CategoryCode>
                    <xsl:value-of select="current-grouping-key()"/>
                  </CategoryCode>
                 <!--  <CategoryReferenceName>
                    <xsl:value-of select="sql:categoryrefname"/>
                  </CategoryReferenceName>  -->                 
                  <CategoryName>
                    <xsl:value-of select="sql:categoryname"/>
                  </CategoryName>
                  <CategoryRank>
                    <xsl:value-of select="sql:categoryrank"/>
                  </CategoryRank>
                  <xsl:for-each-group select="current-group()" group-by="sql:subcategorycode">
                    <SubCategory>
                     <!--  <xsl:attribute name="status" select="sql:subcategory_status"/> -->
                      <SubCategoryCode>
                        <xsl:value-of select="current-grouping-key()"/>
                      </SubCategoryCode>
                     <!--  <SubCategoryReferenceName>
                        <xsl:value-of select="sql:subcategoryrefname"/>
                      </SubCategoryReferenceName> -->                      
                      <SubCategoryName>
                        <xsl:value-of select="sql:subcategoryname"/>
                      </SubCategoryName>
                      <SubCategoryRank>
                        <xsl:value-of select="sql:subcategoryrank"/>
                      </SubCategoryRank>
                      <xsl:for-each select="current-group()/sql:object_id[.!='']">
                        <Product><xsl:value-of select="."/></Product>
                      </xsl:for-each>
                    </SubCategory>
                  </xsl:for-each-group>
                </Category>
              </xsl:for-each-group>
            </Group>
          </xsl:for-each-group>
        </FixedCategorization>
      </Catalog>
    </xsl:for-each-group>
  </xsl:template>
</xsl:stylesheet>