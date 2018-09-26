<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
                xmlns:data="http://www.philips.com/cmc2-data"
                exclude-result-prefixes="sql xsl cinclude data" 
                xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2"
                extension-element-prefixes="asset-f"
            >  
            
  <xsl:import href="../xUCDM.1.4.convertProducts.xsl" />
  <xsl:import href="../../../common/xsl/xUCDM-external-assets.xsl"/>
  
  <xsl:param name="doctypesfilepath"/>
  <xsl:param name="type"/>
  <xsl:param name="channel"/> 
  <xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>
  
	<xsl:template match="Products">	   
      <Products>
        <xsl:attribute name="DocTimeStamp" select="substring(string(current-dateTime()),1,19)"/>
        <xsl:apply-templates select="node()"/>
      </Products>	     
  </xsl:template>

  <xsl:template match="sql:somp | sql:lastmodified | sql:catalog | sql:lastmodified | sql:delete_after_date | sql:rank" />
  <xsl:template match="sql:rowset[@name='product']/sql:row/sql:data/Product[NavigationGroup]"/>
  
  <xsl:template match="sql:rowset[@name='product']/sql:row/sql:data/Product[@Locale]">
  
		<Product>				
				<xsl:attribute name="ctn" select="CTN"/>
				<xsl:attribute name="dtn" select="DTN"/>
				
				<xsl:if test="GTIN != ''">
				  <xsl:attribute name="gtin" select="GTIN"/>
				</xsl:if>
				
				 <xsl:choose>
                <xsl:when test="@Locale != ''">
                <xsl:attribute name="locale" select="@Locale"/>
                </xsl:when>
                <xsl:otherwise>
                <!-- <xsl:attribute name="locale">en_QQ</xsl:attribute>
				<xsl:attribute name="Country">QQ</xsl:attribute> -->
				</xsl:otherwise>
            	</xsl:choose>
				
		<xsl:if test="ProductType != ''">
				  <xsl:attribute name="productType" select="ProductType"/>
				</xsl:if>
				<xsl:attribute name="brandCode" select="NamingString/MasterBrand/BrandCode"/>
				
				
				<xsl:if test ="ProductDivision/ProductDivisionCode">
					<xsl:attribute name="division">        
						<xsl:choose>
								<xsl:when test="ProductDivision/ProductDivisionCode = '0100'">Lighting</xsl:when>
								<xsl:when test="ProductDivision/ProductDivisionCode = '0200'">CLS</xsl:when>
						</xsl:choose>          
					</xsl:attribute>
				</xsl:if>							
		    
		    <xsl:attribute name="marketingVersion" select="MarketingVersion"/>
		      
		      <xsl:apply-templates select="ProductName"/>
		      <xsl:choose>
		        <xsl:when test="FullProductName=''">
		          <FullProductName><xsl:value-of select="cmc2-f:formatFullProductName(NamingString)"/></FullProductName>
		        </xsl:when>
		        <xsl:otherwise>
		          <xsl:apply-templates select="FullProductName"/>
		        </xsl:otherwise>		        
	        </xsl:choose>
		      
		      <SeoProductName><xsl:value-of select="SEOProductName"/></SeoProductName>
		      
		      <xsl:variable name="language">
		      <xsl:choose>
                <xsl:when test="@Locale != ''"><xsl:value-of select="@Locale"/></xsl:when>
                <xsl:otherwise>global</xsl:otherwise>
            </xsl:choose>  
		      </xsl:variable>
		      
		      <ImageUrl><xsl:value-of select="asset-f:buildScene7Url($imagepath, CTN, 'IMS', $language, '')" /></ImageUrl>
		      
			    <FilterGroups>      
	            <xsl:for-each select="../../sql:data/Product/NavigationGroup/NavigationAttribute">        
                <FilterGroup code="{NavigationAttributeCode}">
                  <FilterKeys>
                    <xsl:for-each select="NavigationValue/NavigationValueCode">
                      <xsl:choose>
                        <xsl:when test ="../FilterValue != ''">
                          <FilterKey code="{.}" value="{../FilterValue}"/>    
                        </xsl:when>
                        <xsl:otherwise>
                          <FilterKey code="{.}"/> 
                        </xsl:otherwise>
                      </xsl:choose> 
                    </xsl:for-each>
                  </FilterKeys>
	               </FilterGroup>                         
	            </xsl:for-each>
	            
	            <xsl:if test="ancestor::sql:row/sql:rowset[@name='cat']/sql:row != ''">
	            <FilterGroup code="ZZ_CATEGORIZATION">
                  <FilterKeys>
                    <xsl:variable name="Filters">
	                    <xsl:for-each select="ancestor::sql:row/sql:rowset[@name='cat']/sql:row">
                          <Filter><xsl:value-of select="sql:groupcode"/></Filter>
                           <Filter><xsl:value-of select="sql:categorycode"/></Filter>
                           <Filter><xsl:value-of select="sql:subcategorycode"/></Filter>
                       </xsl:for-each>
                     </xsl:variable>
                    
                    <xsl:for-each select="distinct-values($Filters/Filter)">
                       <FilterKey code="{current()}"/>	                     
                    </xsl:for-each>
                  </FilterKeys>
	            </FilterGroup>
	            </xsl:if>	            
          </FilterGroups> 
					  					
					<Catalogs>
						<xsl:for-each select="ancestor::sql:row/sql:rowset[@name='catalogs']/sql:row">
							<xsl:variable name="isdeleted">
		           <xsl:choose>
		              <xsl:when test="sql:deleted = '1'">true</xsl:when>
		              <xsl:otherwise>false</xsl:otherwise>
		            </xsl:choose>
		          </xsl:variable>
		          <xsl:variable name="rank"><xsl:value-of select="sql:rank"/></xsl:variable>  
		            <xsl:choose>
			            <xsl:when test ="sql:delete_after_date = ''">
			            <xsl:choose>
			            <xsl:when test="$language = 'global'">
			            	<Catalog code = "{sql:catalog}"
	                                sop = "{sql:sop}"
	                               somp = "{sql:sop}"
	                                eop = "{sql:eop}"                     
	                          isDeleted = "{$isdeleted}"
	                           lastModified = "1970-01-01T00:00:00"
	                           priority = "50"
	                                />
			            </xsl:when>
			            <xsl:otherwise>
			            	<Catalog code = "{sql:catalog}"
	                                sop = "{sql:sop}"
	                               somp = "{sql:somp}"
	                                eop = "{sql:eop}"                     
	                          isDeleted = "{$isdeleted}"
	                              price = "{sql:local_going_price}"                   
	                       lastModified = "{sql:lastmodified}"
	                           priority = "{$rank}"
	                                />
			            </xsl:otherwise>
			            </xsl:choose>
				                
			            </xsl:when>
			            <xsl:otherwise>			
			            <xsl:choose>
			            <xsl:when test="$language = 'global'">
			            	<Catalog code = "{sql:catalog}"
	                                sop = "{sql:sop}"
	                               somp = "{sql:sop}"
	                                eop = "{sql:eop}"                     
	                          isDeleted = "{$isdeleted}"
	                           lastModified = "1970-01-01T00:00:00"
	                           priority = "50"
	                                />
			            </xsl:when>
			            <xsl:otherwise>            
					            <Catalog code = "{sql:catalog}"
				                        sop = "{sql:sop}"
				                       somp = "{sql:somp}"
				                        eop = "{sql:eop}"                     
				                  isDeleted = "{$isdeleted}"
				                      price = "{sql:local_going_price}"                   
				               lastModified = "{sql:lastmodified}"
				            deleteAfterDate = "{sql:delete_after_date}"
				                   priority = "{$rank}"
				                        />
				         </xsl:otherwise>
				         </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>                               
						</xsl:for-each>
					</Catalogs> 
			    <Categorizations>
				    <xsl:for-each select="ancestor::sql:row/sql:rowset[@name='cat']/sql:row">
							<Categorization code="{sql:catalogcode}">          
							   <Path>/<xsl:value-of select="sql:groupcode" />/<xsl:value-of select="sql:categorycode" />/<xsl:value-of select="sql:subcategorycode" /></Path>          
							</Categorization> 
				    </xsl:for-each>						     
			    </Categorizations>
    </Product> 
  </xsl:template>
   
</xsl:stylesheet>