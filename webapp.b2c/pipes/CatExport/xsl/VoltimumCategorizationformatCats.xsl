<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="cinclude xdt fn dir">
  <!-- 
    Voltimum specific: export only technical groups.
  -->
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:param name="exportdate"/>
  <xsl:variable name="ismaster" select="if($locale = 'MASTER') then 'true' else 'false'"/>
  
  <!--  Export only these groups -->
  <xsl:variable name="filter-groups" select="('LUM01_GR','EP01_GR','GE01_GR','ECCONTRO_GR')"/>
  
  <!-- -->
  <xsl:template match="/root">
  <xsl:variable name="docDate" select="concat(substring($exportdate,1,4),'-',substring($exportdate,5,2),'-', substring($exportdate,7,2),'T',substring($exportdate,10,2),':',substring($exportdate,12,2),':00' ) "/>
    <Categorization DocTimeStamp="{$docDate}" >
      <xsl:apply-templates select="sql:rowset"/>
    </Categorization>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:rowset">
    <xsl:for-each-group select="sql:row" group-by="sql:catalogcode">
      <Catalog Language="{$locale}" IsMaster="{$ismaster}">
        <CatalogCode>
          <xsl:value-of select="current-grouping-key()"/>
        </CatalogCode>
        <CatalogName>
          <xsl:value-of select="sql:catalogname"/>
        </CatalogName>
        <CatalogType/>
        <FixedCategorization>
          <xsl:for-each-group select="current-group()[sql:groupcode=$filter-groups]" group-by="sql:groupcode">
            <Group>
              <GroupCode>
                <xsl:value-of select="current-grouping-key()"/>
              </GroupCode>
              <GroupReferenceName>
                <xsl:value-of select="sql:grouprefname"/>
              </GroupReferenceName>              
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
                  <CategoryReferenceName>
                    <xsl:value-of select="sql:categoryrefname"/>
                  </CategoryReferenceName>                  
                  <CategoryName>
                    <xsl:value-of select="sql:categoryname"/>
                  </CategoryName>
                  <CategoryRank>
                    <xsl:value-of select="sql:categoryrank"/>
                  </CategoryRank>
                  
                  <xsl:for-each-group select="current-group()" group-by="sql:l3code">
                    <xsl:choose>
                      <xsl:when test="current-grouping-key() != ''">
                        <!-- Level 3 subcat -->
                        <SubCategory>
                          <SubCategoryCode>
                            <xsl:value-of select="current-grouping-key()"/>
                          </SubCategoryCode>
                          <SubCategoryReferenceName>
                            <xsl:value-of select="sql:l3refname"/>
                          </SubCategoryReferenceName>                      
                          <SubCategoryName>
                            <xsl:value-of select="sql:l3name"/>
                          </SubCategoryName>
                          <SubCategoryRank>
                            <xsl:value-of select="sql:l3rank"/>
                          </SubCategoryRank>
                            
                          <xsl:for-each-group select="current-group()" group-by="sql:l4code">
                            <xsl:choose>
                              <xsl:when test="current-grouping-key() != ''">
                                <!-- Level 4 subcat -->
                                <SubCategory>
                                  <SubCategoryCode>
                                    <xsl:value-of select="current-grouping-key()"/>
                                  </SubCategoryCode>
                                  <SubCategoryReferenceName>
                                    <xsl:value-of select="sql:l4refname"/>
                                  </SubCategoryReferenceName>                      
                                  <SubCategoryName>
                                    <xsl:value-of select="sql:l4name"/>
                                  </SubCategoryName>
                                  <SubCategoryRank>
                                    <xsl:value-of select="sql:l4rank"/>
                                  </SubCategoryRank>
                                  
                                  <xsl:call-template name="export-families"/>
                                </SubCategory>
                                <!-- End Level 4 subcat -->
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:call-template name="export-families"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:for-each-group>
                        </SubCategory>
                        <!-- End Level 3 subcat -->
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:call-template name="export-families"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each-group>
                </Category>
              </xsl:for-each-group>
            </Group>
          </xsl:for-each-group>
        </FixedCategorization>
      </Catalog>
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template name="export-families">
    <xsl:for-each-group select="current-group()" group-by="sql:subcategorycode">
      <Family>
        <xsl:attribute name="status" select="sql:subcategory_status"/>
        <FamilyCode>
          <xsl:value-of select="current-grouping-key()"/>
        </FamilyCode>
        <FamilyReferenceName>
          <xsl:value-of select="sql:subcategoryrefname"/>
        </FamilyReferenceName>                      
        <FamilyName>
          <xsl:value-of select="sql:subcategoryname"/>
        </FamilyName>
        <FamilyRank>
          <xsl:value-of select="sql:subcategoryrank"/>
        </FamilyRank>
        <xsl:for-each select="current-group()/sql:object_id[.!='']">
          <Product><xsl:value-of select="."/></Product>
        </xsl:for-each>
      </Family>
    </xsl:for-each-group>
  </xsl:template>
</xsl:stylesheet>