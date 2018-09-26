<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:cmc2-f="http://www.philips.com/cmc2-f" exclude-result-prefixes="sql xsl cinclude" extension-element-prefixes="cmc2-f">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!--  -->
  <xsl:import href="../../common/xsl/xucdm-broker.xsl"/>
  <!--  -->  
  <xsl:include href="../../../cmc2/xsl/common/cmc2.function.xsl"/>  
  <!--  -->    
  <xsl:param name="doctypesfilepath"/>
  <xsl:param name="type"/>    
  <!--  -->  
  <xsl:variable name="doctypesfile" select="document($doctypesfilepath)"/>    
  <xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>  <!--http://images.philips.com/is/image/PhilipsConsumer/42PFL9900D_10-TLP-global-001-->
  <xsl:variable name="nonimagepath" select="'http://www.p4c.philips.com/cgi-bin/dcbint/get?id='"/>  
  <!--  -->  
  <xsl:template name="Assets">
    <!-- This template overrides the template of the same name in xucdm-broker -->
    <xsl:param name="id"/>
    <xsl:param name="language"/>
    <xsl:param name="locale"/>
    <xsl:param name="lastModified"/>
    <xsl:variable name="number" select="'001'"/>
    <xsl:variable name="extension" select="''"/>
    <xsl:variable name="url" select="''"/>
    <xsl:variable name="v_assets">
      <xsl:choose>
        <xsl:when test="$type = 'locale'">
          <!-- Product assets -->
          <!--xsl:for-each select="AssetList/Asset[ResourceType=$doctypesfile/doctypes/doctype[@StdBroker='yes']/@code]"-->
          <xsl:for-each select="AssetList/Asset[ResourceType = ('COP','RCP','RTP','TRP','DFU','FAQ','PSS','TIP')]">          
            <xsl:variable name="description" select="$doctypesfile/doctypes/doctype[@code=current()/ResourceType]/@description"/>
            <xsl:copy-of select="cmc2-f:doLegacyAsset($id,Language,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,$extension,$url)"/>                        
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="$type = 'masterlocale'">
          <!-- Product assets -->
          <xsl:for-each select="../../sql:pmt/Product/AssetList/Asset[ResourceType = ('COP','RCP','RTP','TRP','DFU','FAQ','PSS','TIP')]">          
            <xsl:variable name="description" select="$doctypesfile/doctypes/doctype[@code=current()/ResourceType]/@description"/>
            <xsl:copy-of select="cmc2-f:doLegacyAsset($id,Language,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,$extension,$url)"/>            
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="$type = 'master'">
          <!-- Product assets -->
          <xsl:for-each select="AssetList/Asset[ResourceType = ('COP','RCP','RTP','TRP','DFU','FAQ','PSS','TIP')][Language='' or Language = 'en_US' or Language='global']">
            <xsl:variable name="description" select="$doctypesfile/doctypes/doctype[@code=current()/ResourceType]/@description"/>
            <xsl:copy-of select="cmc2-f:doLegacyAsset($id,Language,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,'',$url)"/>            
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <Assets>
      <xsl:copy-of select="$v_assets"/>
    </Assets>
  </xsl:template>  
  <!--  -->    
  <xsl:template name="doProductReference">
    <xsl:choose>
      <xsl:when test="$type = 'locale'">
        <xsl:call-template name="ProductReference"/>
      </xsl:when>
      <xsl:when test="$type = 'masterlocale'">
        <!-- use PMT -->
        <xsl:for-each select="../../sql:pmt/Product">
          <xsl:call-template name="ProductReference"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="$type = 'master'">
        <!-- use PMT_Master -->
        <xsl:call-template name="ProductReference"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!--  -->    
  <xsl:template name="ProductReference">
  <!-- 
   old internal format:
  <ProductReference ProductReferenceType="Accessory">
    <CTN>SLV3100/00</CTN> 
    <ProductReferenceRank>0</ProductReferenceRank> 
  </ProductReference>

   new internal format :
  <ProductReferences ProductReferenceType="Performer">
    <CTN>30MF200V/17</CTN> 
    <CTN>30PF9946/12</CTN> 
    <CTN>30PF9946/37</CTN>       
  </ProductReferences>
  -->        
    <xsl:choose>
      <xsl:when test="ProductReference">
        <!-- legacy situation; should not occur but provide handling anyway -->
        <xsl:apply-templates select="ProductReference"/>
      </xsl:when>
      <xsl:when test="ProductReferences">      
        <!-- new situation -->
        <xsl:for-each select="ProductReferences">
          <xsl:variable name="prtype" select="@ProductReferenceType"/>
          <xsl:for-each select="CTN">
            <ProductReference ProductReferenceType="{$prtype}">
              <xsl:copy-of select="." copy-namespaces="no"/>
              <ProductReferenceRank><xsl:value-of select="if(@rank) then @rank else 0"/></ProductReferenceRank> 
            </ProductReference>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:when>
      <!-- should be no others -->
    </xsl:choose>
  </xsl:template>     
  <!--  -->
  <xsl:template match="sql:id|sql:language|sql:sop|sql:eop|sql:sos|sql:eos|sql:priority|sql:content_type|sql:localisation"/>
  <!--  -->
  <xsl:template match="sql:groupcode|sql:groupname|sql:categorycode|sql:categoryname|sql:subcategorycode|sql:subcategoryname"/>
  <!--  -->
  <xsl:template match="sql:rowset[@name='cat']"/>
  <!--  -->
  <xsl:template match="sql:pmt"/>
  <!--  -->   
  <xsl:template match="sql:objectassetdata|sql:ctn|sql:objectassetid"/>
  <!--  -->
  <xsl:template match="RichText[@type = 'Functionality']"/>
  <!--  -->
  <xsl:template match="CSValueDescription"/>
  <!--  -->
  <xsl:template match="CSItemNDescription"/>
  <!--  -->   
  <xsl:template name="OptionalHeaderAttributes">
    <xsl:attribute name="StartOfPublication"><xsl:value-of select="../../sql:sop"/></xsl:attribute>
    <xsl:attribute name="EndOfPublication"><xsl:value-of select="../../sql:eop"/></xsl:attribute>
  </xsl:template>
  <!--  -->
  <xsl:template name="OptionalHeaderData">  
    <xsl:variable name="catval" select="../../sql:rowset[@name='cat']/sql:row[sql:catalogcode!='ProductTree']" />
      <Categorization>
        <GroupCode>
          <xsl:value-of select="$catval/sql:groupcode"/>
        </GroupCode>
        <GroupName>
          <xsl:value-of select="$catval/sql:groupname"/>
        </GroupName>
        <CategoryCode>
          <xsl:value-of select="$catval/sql:categorycode"/>
        </CategoryCode>
        <CategoryName>
          <xsl:value-of select="$catval/sql:categoryname"/>
        </CategoryName>
        <SubcategoryCode>
          <xsl:value-of select="$catval/sql:subcategorycode"/>
        </SubcategoryCode>
        <SubcategoryName>
          <xsl:value-of select="$catval/sql:subcategoryname"/>
        </SubcategoryName>
      </Categorization>
  </xsl:template>
  <!--  -->
</xsl:stylesheet>
