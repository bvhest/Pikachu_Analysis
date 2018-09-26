<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:data="http://www.philips.com/cmc2-data" xmlns:cmc2-f="http://www.philips.com/cmc2-f" extension-element-prefixes="cmc2-f" exclude-result-prefixes="sql xsl cinclude data">
   <!--  base the transformation on the default xUCDM transformation -->
   <xsl:import href="../xUCDM.1.1.convertProducts.xsl"/>
   <!--  xsl:include href="../../../cmc2/xsl/common/cmc2.function.xsl"/-->
   <xsl:function name="cmc2-f:myFormatFullProductName">
      <!--+
      |  Create full product name out of constituent parts of NamingString element
      |       IN: NamingString (element)
      |      OUT: Full product name (string)
      +-->
      <xsl:param name="vNamingString"/>
      <xsl:param name="CTN"/>
      <xsl:variable name="TempFullNaming">
         <xsl:choose>
            <xsl:when test="$vNamingString!=''">
               <xsl:choose>
                  <xsl:when test="string-length($vNamingString/BrandString) &gt; 0">
                     <xsl:value-of select="$vNamingString/BrandString"/>
                     <xsl:text> </xsl:text>
                     <xsl:choose>
                        <!-- <xsl:when test="$vNamingString/Concept/ConceptName != '' and $vNamingString/Concept/ConceptNameUsed = '1'">
              	<xsl:value-of select="$vNamingString/Concept/ConceptName"/>
              </xsl:when> -->
                        <xsl:when test="$vNamingString/Family/FamilyName != '' and $vNamingString/Family/FamilyNameUsed = '1'">
                           <xsl:value-of select="$vNamingString/Family/FamilyName"/>
                        </xsl:when>
                        <!-- <xsl:otherwise>
              	<xsl:value-of select="if($vNamingString/Range/RangeName != '' and $vNamingString/Family/FamilyNameUsed = '1') then $vNamingString/Range/RangeName else ''"/>
              </xsl:otherwise> -->
                     </xsl:choose>
                     <xsl:text> </xsl:text>
                     <xsl:value-of select="$vNamingString/Descriptor/DescriptorName"/>
                     <!-- <xsl:text> </xsl:text>
             <xsl:value-of select="if($vNamingString/Alphanumeric != '') then $vNamingString/Alphanumeric else $CTN "/> -->
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$vNamingString/MasterBrand/BrandName"/>
                     <xsl:text> </xsl:text>
                     <xsl:choose>
                        <!-- <xsl:when test="$vNamingString/Concept/ConceptName != '' and $vNamingString/Concept/ConceptNameUsed = '1'">
              	<xsl:value-of select="$vNamingString/Concept/ConceptName"/>
              </xsl:when> -->
                        <xsl:when test="$vNamingString/Family/FamilyName != '' and $vNamingString/Family/FamilyNameUsed = '1'">
                           <xsl:value-of select="$vNamingString/Family/FamilyName"/>
                        </xsl:when>
                        <!-- <xsl:otherwise>
              	<xsl:value-of select="if($vNamingString/Range/RangeName != '' and $vNamingString/Family/FamilyNameUsed = '1') then $vNamingString/Range/RangeName else ''"/>
              </xsl:otherwise> -->
                     </xsl:choose>
                     <xsl:text> </xsl:text>
                     <xsl:value-of select="$vNamingString/Descriptor/DescriptorName"/>
                     <!-- <xsl:text> </xsl:text>
             <xsl:value-of select="if($vNamingString/Alphanumeric != '') then $vNamingString/Alphanumeric else CTN "/> -->
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="''"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="normalize-space(replace(replace(replace($TempFullNaming,'NULL',''),'&lt;not applicable&gt;',''),'PHILIPS','Philips'))"/>
   </xsl:function>
   <xsl:param name="doctypesfilepath"/>
   <xsl:param name="type"/>
   <xsl:param name="channel"/>
   <xsl:variable name="doctypesfile" select="document($doctypesfilepath)"/>
   <xsl:template match="Products">
      <Products>
         <!-- <xsl:attribute name="DocTimeStamp" select="substring(string(current-dateTime()),1,19)"/>
      <xsl:attribute name="DocStatus" select="'approved'"/> -->
         <!--  <xsl:attribute name="DocType" select="sql:rowset/sql:row[1]/sql:content_type"/> -->
         <!-- <xsl:attribute name="DocVersion"><xsl:text>xUCDM_product_external_CQ5_1_1_25</xsl:text></xsl:attribute>  -->
         <xsl:apply-templates select="node()"/>
      </Products>
   </xsl:template>
   <xsl:template match="sql:rowset[@name='Refs']"/>
   <xsl:template match="sql:product_type"/>
   <xsl:template match="Product">
      <Product>
         <xsl:choose>
            <xsl:when test="@Locale!=''">
               <xsl:attribute name="Locale" select="@Locale"/>
               <xsl:attribute name="Country" select="substring-after(@Locale,'_')"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:attribute name="Locale">en_QQ</xsl:attribute>
               <xsl:attribute name="Country">QQ</xsl:attribute>
            </xsl:otherwise>
         </xsl:choose>
         <!-- <xsl:apply-templates select="@*[not(local-name() = 'lastModified' or local-name() = 'masterLastModified' or local-name() = 'Brand' or local-name() = 'Division')]"/> -->
         <!-- Ensure lastModified and masterLastModified have a 'T' in them -->
         <xsl:attribute name="lastModified" select="concat(substring(@lastModified,1,10),'T',substring(@lastModified,12,8))"/>
         <xsl:if test="@masterLastModified">
            <xsl:attribute name="masterLastModified" select="concat(substring(@masterLastModified,1,10),'T',substring(@masterLastModified,12,8))"/>
         </xsl:if>
         <xsl:call-template name="OptionalHeaderAttributes"/>
         <xsl:call-template name="OptionalHeaderData">
            <xsl:with-param name="ctn" select="CTN"/>
            <xsl:with-param name="language" select="../../sql:language"/>
            <xsl:with-param name="locale" select="@Locale"/>
            <xsl:with-param name="division" select="../../sql:division"/>
         </xsl:call-template>
         <xsl:variable name="id" select="if (contains(CTN, '/')) then replace(CTN, '/','_') else CTN"/>
         <xsl:choose>
            <xsl:when test="@Locale!=''">
               <ID>
                  <xsl:value-of select="concat($id,'_',@Locale)"/>
               </ID>
            </xsl:when>
            <xsl:otherwise>
               <ID>
                  <xsl:value-of select="concat($id,'_en_QQ')"/>
               </ID>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:apply-templates select="CTN"/>
         <xsl:apply-templates select="Code12NC"/>
         <xsl:apply-templates select="GTIN"/>
         <xsl:if test="../../sql:product_type='NORMAL'">
            <ProductType>Normal</ProductType>
         </xsl:if>
         <xsl:if test="../../sql:product_type='CHASSIS'">
            <ProductType>Chassis</ProductType>
         </xsl:if>
         <xsl:if test="../../sql:product_type='CRP'">
            <ProductType>CRP</ProductType>
         </xsl:if>
         <xsl:if test="../../sql:product_type='ACCESSORY'">
            <ProductType>Accessory</ProductType>
         </xsl:if>
         <xsl:if test="../../sql:product_type='KEY'">
            <ProductType>Key</ProductType>
         </xsl:if>
         <xsl:if test="../../sql:product_type='MCI'">
            <ProductType>MCI</ProductType>
         </xsl:if>
         <xsl:if test="../../sql:product_type='SERVICE'">
            <ProductType>Service</ProductType>
         </xsl:if>
         <xsl:if test="../../sql:product_type='SUBSCRIPTIONPLAN'">
            <ProductType>SubscriptionPlan</ProductType>
         </xsl:if>
         <xsl:if test="../../sql:product_type='APP'">
            <ProductType>App</ProductType>
         </xsl:if>
         <xsl:if test="../../sql:product_type='SPECIAL'">
            <ProductType>Special</ProductType>
         </xsl:if>
         <!-- <xsl:apply-templates select="MarketingVersion"/>  -->
         <!-- BHE (30/9/2009): include empty elements for mandatory items.
      -->
         <MarketingStatus>
            <xsl:choose>
               <xsl:when test="not(MarketingStatus)">
                  <xsl:text>Final Published</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="MarketingStatus"/>
               </xsl:otherwise>
            </xsl:choose>
         </MarketingStatus>
         <xsl:apply-templates select="LifecycleStatus"/>
         <xsl:apply-templates select="CRDate"/>
         <!--  <xsl:apply-templates select="CRDateYW"/>
       <ModelYears>
         <xsl:apply-templates select="ModelYear"/>
      </ModelYears> -->
         <xsl:apply-templates select="ProductDivision"/>
         <!-- <xsl:apply-templates select="ProductOwner"/> -->
         <xsl:apply-templates select="DTN"/>
         <xsl:call-template name="docatalogdata">
            <xsl:with-param name="sop" select="ancestor::sql:row/sql:sop"/>
            <xsl:with-param name="eop" select="ancestor::sql:row/sql:eop"/>
            <xsl:with-param name="sos" select="ancestor::sql:row/sql:sos"/>
            <xsl:with-param name="eos" select="ancestor::sql:row/sql:eos"/>
            <xsl:with-param name="lgp" select="ancestor::sql:row/sql:local_going_price"/>
            <xsl:with-param name="rank" select="ancestor::sql:row/sql:priority"/>
            <xsl:with-param name="deleted" select="ancestor::sql:row/sql:deleted"/>
            <xsl:with-param name="deleteafterdate" select="ancestor::sql:row/sql:deleteafterdate"/>
         </xsl:call-template>
         <xsl:call-template name="docategorization">
            <xsl:with-param name="cats" select="ancestor::sql:row/sql:rowset[@name='cat']/sql:row"/>
         </xsl:call-template>
         <xsl:template name="docategorization">
            <xsl:param name="cats"/>
            <xsl:for-each select="$cats">
               <xsl:choose>
                  <xsl:when test="sql:catalogcode = 'ProductTree'">
                     <FinancialCategorization>
                        <BusinessGroupCode>
                           <xsl:value-of select="sql:bgroupcode"/>
                        </BusinessGroupCode>
                        <BusinessGroupName>
                           <xsl:value-of select="sql:bgroupname"/>
                        </BusinessGroupName>
                        <BusinessUnitCode>
                           <xsl:value-of select="sql:groupcode"/>
                        </BusinessUnitCode>
                        <BusinessUnitName>
                           <xsl:value-of select="sql:groupname"/>
                        </BusinessUnitName>
                        <MainArticleGroupCode>
                           <xsl:value-of select="sql:categorycode"/>
                        </MainArticleGroupCode>
                        <MainArticleGroupName>
                           <xsl:value-of select="sql:categoryname"/>
                        </MainArticleGroupName>
                        <ArticleGroupCode>
                           <xsl:value-of select="sql:subcategorycode"/>
                        </ArticleGroupCode>
                        <ArticleGroupName>
                           <xsl:value-of select="sql:subcategoryname"/>
                        </ArticleGroupName>
                     </FinancialCategorization>
                  </xsl:when>
                  <xsl:otherwise>
                     <Categorization type="{sql:catalogcode}">
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
                     </Categorization>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:for-each>
         </xsl:template>
         <xsl:call-template name="doAssets">
            <xsl:with-param name="id" select="CTN"/>
            <xsl:with-param name="language" select="../../sql:language"/>
            <xsl:with-param name="locale" select="@Locale"/>
            <xsl:with-param name="lastModified" select="concat(substring(@lastModified,1,10),'T',substring(@lastModified,12,8))"/>
            <xsl:with-param name="catalogtype" select="../../sql:catalogtype"/>
         </xsl:call-template>
         <AssetServiceManuals>
            <xsl:for-each select="AssetList">
               <xsl:for-each select="./Asset">
                  <xsl:if test = " (./ResourceType = 'SSL') or (./ResourceType = 'SSG') or (./ResourceType = 'WDD')or (./ResourceType = 'SMA')or (./ResourceType = 'SBM')
								   or (./ResourceType = 'SEV')or (./ResourceType = 'HDD')or (./ResourceType = 'DSM')or (./ResourceType = 'SSU')or (./ResourceType = 'SIB') 
								   or (./ResourceType = 'SM4')">
                     <xsl:element name="AssetServiceManual">
                        <xsl:attribute name="code">
                           <xsl:value-of select="$id"/>
                        </xsl:attribute>
                        <xsl:attribute name="description">
                           <xsl:value-of select="$doctypesfile/doctypes/doctype[@code=current()/ResourceType]/@description"/>
                        </xsl:attribute>
                        <xsl:attribute name="extension">
                           <xsl:text>pdf</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="lastModified">
                           <xsl:value-of select="./Modified"/>
                        </xsl:attribute>
                        <xsl:attribute name="locale">
                           <xsl:value-of select="./Language"/>
                        </xsl:attribute>
                        <xsl:attribute name="number">
                           <xsl:text>001</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="type">
                           <xsl:value-of select="./ResourceType"/>
                        </xsl:attribute>
                        <xsl:value-of select="./SecureResourceIdentifier"/>
                     </xsl:element>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
         </AssetServiceManuals>
         <ProductName>
            <xsl:value-of select="cmc2-f:myFormatFullProductName(NamingString,CTN)"/>
         </ProductName>
         <xsl:apply-templates select="NamingString"/>
         <xsl:apply-templates select="ShortDescription"/>
         <xsl:apply-templates select="WOW"/>
         <xsl:apply-templates select="SubWOW"/>
         <xsl:apply-templates select="MarketingTextHeader"/>
         <!--  <Disclaimers>
        <xsl:apply-templates select="Disclaimers/Disclaimer"/>
      </Disclaimers> -->
         <!-- BHE: new order KeyValuePairs in tree & element is mandatory -->
         <!-- Some PMTs may still have separate KeyValuePair elements without a proper container -->
         <KeyValuePairs>
            <xsl:choose>
               <xsl:when test ="KeyValuePairs/KeyValuePair[Key=('FdaFlag')]">
                  <xsl:apply-templates select="KeyValuePairs/KeyValuePair[Key=('FdaFlag')]"/>
               </xsl:when>
               <xsl:otherwise>
                  <KeyValuePair>
                     <Key>FdaFlag</Key>
                     <Value>false</Value>
                     <Type>String</Type>
                  </KeyValuePair>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
               <xsl:when test ="KeyValuePairs/KeyValuePair[Key=('GrantGroup')]">
                  <xsl:apply-templates select="KeyValuePairs/KeyValuePair[Key=('GrantGroup')]"/>
               </xsl:when>
               <xsl:otherwise>
                  <KeyValuePair>
                     <Key>GrantGroup</Key>
                     <Value>PHILIPS</Value>
                     <Type>String</Type>
                  </KeyValuePair>
               </xsl:otherwise>
            </xsl:choose>
         </KeyValuePairs>
         <xsl:call-template name="doAccessories">
            <xsl:with-param name="cschapters">
               <csc>
                  <xsl:copy-of select="CSChapter"/>
               </csc>
            </xsl:with-param>
            <xsl:with-param name="abp">
               <abp>
                  <xsl:copy-of select="AccessoryByPacked"/>
               </abp>
            </xsl:with-param>
         </xsl:call-template>
         <xsl:if test= "ProductRefs/ProductReference[@ProductReferenceType=('Accessory')]/CTN != ''
                               or ProductReferences[@ProductReferenceType=('Accessory')]/CTN != ''">
            <ProductReference ProductReferenceType="Accessory">
               <xsl:apply-templates select="ProductRefs/ProductReference[@ProductReferenceType=('Accessory')]/CTN
                               | ProductReferences[@ProductReferenceType=('Accessory')]/CTN"/>
            </ProductReference>
         </xsl:if>
         <xsl:if test= "ProductRefs/ProductReference[@ProductReferenceType=('Contains')]/CTN != ''
                               or ProductReferences[@ProductReferenceType=('Contains')]/CTN != ''">
            <ProductReference ProductReferenceType="Contains">
               <xsl:apply-templates select="ProductRefs/ProductReference[@ProductReferenceType=('Contains')]/CTN
                               | ProductReferences[@ProductReferenceType=('Contains')]/CTN"/>
            </ProductReference>
         </xsl:if>
         <xsl:if test= "ProductRefs/ProductReference[@ProductReferenceType=('Performer')]/CTN != ''
                               or ProductReferences[@ProductReferenceType=('Performer')]/CTN != ''">
            <ProductReference ProductReferenceType="Performer">
               <xsl:apply-templates select="ProductRefs/ProductReference[@ProductReferenceType=('Performer')]/CTN
                               | ProductReferences[@ProductReferenceType=('Performer')]/CTN"/>
            </ProductReference>
         </xsl:if>
         <xsl:if test= "ProductRefs/ProductReference[@ProductReferenceType=('Variation')]/CTN != ''
                               or ProductReferences[@ProductReferenceType=('Variation')]/CTN != ''">
            <ProductReference ProductReferenceType="Variation">
               <xsl:apply-templates select="ProductRefs/ProductReference[@ProductReferenceType=('Variation')]/CTN
                               | ProductReferences[@ProductReferenceType=('Variation')]/CTN"/>
            </ProductReference>
         </xsl:if>
         <xsl:if test= "ProductRefs/ProductReference[@ProductReferenceType=('isAccessoryOf')]/CTN != ''
                               or ProductReferences[@ProductReferenceType=('isAccessoryOf')]/CTN != ''">
            <ProductReference ProductReferenceType="isAccessoryOf">
               <xsl:apply-templates select="ProductRefs/ProductReference[@ProductReferenceType=('isAccessoryOf')]/CTN
                               | ProductReferences[@ProductReferenceType=('isAccessoryOf')]/CTN"/>
            </ProductReference>
         </xsl:if>
         <xsl:if test= "ProductRefs/ProductReference[@ProductReferenceType=('hasAsAccessory')]/CTN != ''
                               or ProductReferences[@ProductReferenceType=('hasAsAccessory')]/CTN != ''">
            <ProductReference ProductReferenceType="hasAsAccessory">
               <xsl:apply-templates select="ProductRefs/ProductReference[@ProductReferenceType=('hasAsAccessory')]/CTN
                               | ProductReferences[@ProductReferenceType=('hasAsAccessory')]/CTN"/>
            </ProductReference>
         </xsl:if>
         <xsl:if test= "ProductRefs/ProductReference[@ProductReferenceType=('hasPredecessor')]/CTN != ''
                               or ProductReferences[@ProductReferenceType=('hasPredecessor')]/CTN != ''">
            <ProductReference ProductReferenceType="hasPredecessor">
               <xsl:apply-templates select="ProductRefs/ProductReference[@ProductReferenceType=('hasPredecessor')]/CTN
                               | ProductReferences[@ProductReferenceType=('hasPredecessor')]/CTN"/>
            </ProductReference>
         </xsl:if>
         <xsl:call-template name="OptionalFooterData">
            <xsl:with-param name="ctn" select="CTN"/>
            <xsl:with-param name="language" select="../../sql:language"/>
            <xsl:with-param name="locale" select="@Locale"/>
         </xsl:call-template>
      </Product>
   </xsl:template>
   <xsl:template match="sql:wsf"/>
</xsl:stylesheet>
