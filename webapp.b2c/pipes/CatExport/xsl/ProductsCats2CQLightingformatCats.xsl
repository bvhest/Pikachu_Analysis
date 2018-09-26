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
    <xsl:for-each-group select="sql:row[sql:groupcode='LIGHTING_GR']" group-by="sql:groupcode">
      <Catalog Locale="{$locale}" IsMaster="{$ismaster}">
        <CatalogCode>CONSUMER</CatalogCode>
        <CatalogName>Consumer</CatalogName>
        <CatalogType/>
        <FixedCategorization>
          <xsl:for-each-group select="current-group()" group-by="sql:groupcode">
            <Group>
	            <xsl:if test="sql:grouptype != ''">
	                <xsl:attribute name="type" select="sql:grouptype"/>            
	            </xsl:if>             
              <GroupCode>
              <xsl:value-of select="current-grouping-key()"/>
              </GroupCode>
              <xsl:if test="sql:groupshortcode != ''">
		              <GroupShortCode>
                      <xsl:value-of select="sql:groupshortcode"/>
		              </GroupShortCode>
              </xsl:if>             
              <GroupReferenceName>
                <xsl:value-of select="sql:grouprefname"/>
              </GroupReferenceName>              
              <GroupName>
                <xsl:value-of select="sql:groupname"/>
              </GroupName>
		          <xsl:choose>
		            <xsl:when test="$locale='MASTER'">
		                <GroupSeoName romanize="true" locale="en_US" dotdash="true">
											<xsl:choose>
                        <!-- Load customized SEO from database -->										
												<xsl:when test="sql:groupseoname !=''">
			                      <xsl:value-of select="lower-case(replace(sql:groupseoname,'.','-'))" />
												</xsl:when>
												<xsl:otherwise>
												<!-- Load default SEO -->
		                      <xsl:value-of select="lower-case(sql:groupname)" />
												</xsl:otherwise>
											</xsl:choose>
										</GroupSeoName>
                </xsl:when>
		            <xsl:otherwise>
		              <GroupSeoName romanize="true" locale="{$locale}" dotdash="true">
		                <xsl:choose>                    
		                  <!-- Load customized SEO from database -->  
	                    <xsl:when test="sql:groupseoname !=''">		                    
			                    <xsl:value-of select="lower-case(if (sql:islatin='1') then sql:groupseoname else sql:m_groupseoname)" />
	                    </xsl:when>
	                    <!-- Load default SEO -->
	                    <xsl:otherwise>
	                        <xsl:value-of select="lower-case(if (sql:islatin='1') then sql:groupname else sql:m_groupname)" />
			                </xsl:otherwise>
                    </xsl:choose> 
		              </GroupSeoName>		              
		            </xsl:otherwise>
		          </xsl:choose>
              <GroupSeoDisplayName>
                <xsl:choose>
                  <!-- Load customized SEO from database -->                  
                  <xsl:when test="sql:groupseoname !=''">                      
                      <xsl:value-of select="sql:groupseoname" />
                  </xsl:when>
                  <!-- Load default SEO -->
                  <xsl:otherwise>
                      <xsl:value-of select="sql:groupname" />
                  </xsl:otherwise>
                </xsl:choose> 
              </GroupSeoDisplayName>    
              <GroupRank>
                <xsl:value-of select="sql:grouprank"/>
              </GroupRank>
              <xsl:for-each-group select="current-group()" group-by="sql:categorycode">
                <Category>
	                <xsl:if test="sql:categorytype != ''">
	                  <xsl:attribute name="type" select="sql:categorytype"/>            
	                </xsl:if>  
                  <CategoryCode>
                    <xsl:value-of select="current-grouping-key()"/>
                  </CategoryCode>
                  <CategoryReferenceName>
                    <xsl:value-of select="sql:categoryrefname"/>
                  </CategoryReferenceName>                  
                  <CategoryName>
                    <xsl:value-of select="sql:categoryname"/>
                  </CategoryName>
                  <xsl:choose>
				            <xsl:when test="$locale='MASTER'">
				              <CategorySeoName romanize="true" locale="en_US" dotdash="true">
					              <xsl:choose>
	                        <!-- Load customized SEO from database -->                    
	                        <xsl:when test="sql:categoryseoname !=''">
	                            <xsl:value-of select="lower-case(sql:categoryseoname)" />
	                        </xsl:when>
	                        <xsl:otherwise>
	                        <!-- Load default SEO -->
	                          <xsl:value-of select="lower-case(sql:categoryname)" />
	                        </xsl:otherwise>
	                      </xsl:choose>  
				              </CategorySeoName>				              
				            </xsl:when>
				            <xsl:otherwise>
				              <CategorySeoName romanize="true" locale="{$locale}" dotdash="true">
				                <xsl:choose>
                          <!-- Load customized SEO from database -->                    
                          <xsl:when test="sql:categoryseoname !=''">                           
                              <xsl:value-of select="lower-case(if (sql:islatin='1') then sql:categoryseoname else sql:m_categoryseoname)" />
                          </xsl:when>
                          <xsl:otherwise>
                          <!-- Load default SEO -->
                            <xsl:value-of select="lower-case(if (sql:islatin='1') then sql:categoryname else sql:m_categoryname)" />
                          </xsl:otherwise>
                        </xsl:choose> 				                
				              </CategorySeoName>
				            </xsl:otherwise>
				          </xsl:choose>
                  <CategorySeoDisplayName>
                    <xsl:choose>
                      <!-- Load customized SEO from database -->                    
                      <xsl:when test="sql:categoryseoname !=''">
                          <xsl:value-of select="sql:categoryseoname" />
                      </xsl:when>
                      <xsl:otherwise>
                      <!-- Load default SEO -->
                        <xsl:value-of select="sql:categoryname" />
                      </xsl:otherwise>
                    </xsl:choose>  
                  </CategorySeoDisplayName>
                  <CategoryRank>
                    <xsl:value-of select="sql:categoryrank"/>
                  </CategoryRank>
                  <xsl:for-each-group select="current-group()" group-by="sql:subcategorycode">
                    <SubCategory>
                      <xsl:attribute name="status" select="sql:subcategory_status"/>
                      <xsl:if test="sql:subcategorytype != ''">
                          <xsl:attribute name="type" select="sql:subcategorytype"/>            
                      </xsl:if>
                      <SubCategoryCode>
                        <xsl:value-of select="current-grouping-key()"/>
                      </SubCategoryCode>
                      <SubCategoryReferenceName>
                        <xsl:value-of select="sql:subcategoryrefname"/>
                      </SubCategoryReferenceName>                      
                      <SubCategoryName>
                        <xsl:value-of select="sql:subcategoryname"/>
                      </SubCategoryName>
                      <xsl:choose>
					              <xsl:when test="$locale='MASTER'">
					                <SubCategorySeoName romanize="true" locale="en_US" dotdash="true">
						                <xsl:choose>
	                          <!-- Load customized SEO from database -->                    
	                          <xsl:when test="sql:subcategoryseoname !=''">
	                              <xsl:value-of select="lower-case(sql:subcategoryseoname)" />
	                          </xsl:when>
	                          <xsl:otherwise>
	                          <!-- Load default SEO -->
	                            <xsl:value-of select="lower-case(sql:subcategoryname)" />
	                          </xsl:otherwise>
	                          </xsl:choose>   
					                </SubCategorySeoName>
					              </xsl:when>
					              <xsl:otherwise>
					                <SubCategorySeoName romanize="true" locale="{$locale}" dotdash="true">
                            <xsl:choose>
                            <!-- Load customized SEO from database -->                    
                            <xsl:when test="sql:subcategoryseoname !=''">                              
                                <xsl:value-of select="lower-case(if (sql:islatin='1') then sql:subcategoryseoname else sql:m_subcategoryseoname)" />
                            </xsl:when>
                            <xsl:otherwise>
                            <!-- Load default SEO -->
                              <xsl:value-of select="lower-case(if (sql:islatin='1') then sql:subcategoryname else sql:m_subcategoryname)" />
                            </xsl:otherwise>
                            </xsl:choose>
					                </SubCategorySeoName>
					              </xsl:otherwise>
					            </xsl:choose>
                      <SubCategorySeoDisplayName>
                        <xsl:choose>
                        <!-- Load customized SEO from database -->                    
                        <xsl:when test="sql:subcategoryseoname !=''">
                            <xsl:value-of select="sql:subcategoryseoname" />
                        </xsl:when>
                        <xsl:otherwise>
                        <!-- Load default SEO -->
                          <xsl:value-of select="sql:subcategoryname" />
                        </xsl:otherwise>
                        </xsl:choose>   
                      </SubCategorySeoDisplayName>
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