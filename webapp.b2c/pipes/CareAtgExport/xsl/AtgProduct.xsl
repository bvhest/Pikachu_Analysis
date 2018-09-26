<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://www.philips.com/pika" extension-element-prefixes="my xs">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:param name="doctypesfilepath"/>
	<xsl:param name="localelanguagefilepath"/>
	<xsl:param name="locale"/>


	<!--  -->
	<xsl:variable name="doctypesfile" select="document($doctypesfilepath)"/>
	<xsl:variable name="localelanguagefile" select="document($localelanguagefilepath)"/>	

	<xsl:include href="objectAssets.xsl"/>
	
	<xsl:variable name="atgNullValue" select="'__NULL__'"/>
	<xsl:function name="my:normalized-id" as="xs:string">
		<xsl:param name="id"/>
                <!--xsl:value-of select="translate($id,'/-. ','___')"/-->
                <xsl:value-of select="$id"/>
    </xsl:function>
	<xsl:function name="my:atgNULL">
		<xsl:param name="value"/>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="not($value) or $value=''">
					<xsl:value-of select="$atgNullValue"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$result"/>
	</xsl:function>
	
	
	<xsl:template name="oleeChapter">
		<xsl:param name="locale"/>
		<xsl:param name="country"/>
		<xsl:param name="atgCTN"/>
		<xsl:variable name="prd" select="."/>
		<xsl:variable name="language" select="$localelanguagefile/root/row[locale=$locale]/language"/>
		<xsl:for-each select="RichTexts/RichText ">
				<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="olee-chapter" id="{concat($atgCTN,'_',$locale,'-',@type,'-',chapter/@rank)}">
					<set-property name="displayName">
						<xsl:value-of select="chapter/Name"/>
					</set-property>
					<set-property name="oleeItems">
							<xsl:for-each select="Item">
								<xsl:if test="position() != 1">,</xsl:if>
								<xsl:value-of select="@code"/>
							</xsl:for-each>
					</set-property>					
				</add-item>
			</xsl:for-each>
		<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="olee-chapter-list" id="{concat('$atgCTN,'_',$locale)}">
					<set-property name="oleeChapters">
							<xsl:for-each select="RichTexts/RichText">
								<xsl:if test="position() != 1">,</xsl:if>
								<xsl:value-of select="concat($atgCTN,'_',$locale,'-',@type,'-',chapter/@rank)"/>
							</xsl:for-each>
					</set-property>			
		</add-item>	
	</xsl:template>
	
  <xsl:function name="my:assetMap">
    <xsl:param name="prdNode"/>
    <xsl:param name="country"/>
    <xsl:param name="atgCTN"/>
    <xsl:variable name="result">
      <xsl:for-each-group select="$prdNode/AssetList/Asset" group-by="ResourceType">
        <xsl:if test="position() != 1">,</xsl:if>
        <!--PWS=product-SGP9200_00_US_CONSUMER-PWS-->
        <xsl:value-of select="concat(current-grouping-key(),'=product-',$atgCTN,'_',$country,'-',current-grouping-key())"/>
      </xsl:for-each-group>
      <!-- Virtual assets -->
      <xsl:variable name="v_comma" select="if($prdNode/AssetList/Asset) then ',' else ''"/>      
      <xsl:value-of select="concat($v_comma,'IMS=product-',$atgCTN,'_',$country,'-IMS')"/>
      <xsl:value-of select="concat(',GAL=product-',$atgCTN,'_',$country,'-GAL')"/>
      <xsl:if test="$prdNode/AssetList/Asset[ResourceType='P3D']">
        <xsl:value-of select="concat(',P3D=product-',$atgCTN,'_',$country,'-P3D')"/>
      </xsl:if>
    </xsl:variable>
    <xsl:value-of select="$result"/>
  </xsl:function>
  
  <xsl:function name="my:virtualAssetMap">
    <xsl:param name="prdNode"/>
    <xsl:param name="country"/>
    <xsl:param name="atgCTN"/>
    <xsl:variable name="result">
      <!-- Virtual assets -->  
      <xsl:value-of select="concat('IMS=product-',$atgCTN,'_',$country,'-IMS')"/>
      <xsl:value-of select="concat(',GAL=product-',$atgCTN,'_',$country,'-GAL')"/>
    </xsl:variable>
    <xsl:value-of select="$result"/>
  </xsl:function>
  
 <xsl:function name="my:documentMap">
    <xsl:param name="prdNode"/>
    <xsl:param name="country"/>
    <xsl:param name="atgCTN"/>
    <xsl:variable name="result">
      <xsl:for-each-group select="$prdNode/AssetList/Asset[Format='application/pdf']" group-by="ResourceType">
        <xsl:if test="position() != 1">,</xsl:if>
        <!--PWS=SGP9200_00_US-PWS-->
        <xsl:value-of select="concat(current-grouping-key(),'=',$atgCTN,'-',current-grouping-key())"/>
      </xsl:for-each-group>
    </xsl:variable>
    <xsl:value-of select="$result"/>
  </xsl:function>  
  
   <xsl:function name="my:softwareMap">
    <xsl:param name="prdNode"/>
    <xsl:param name="country"/>
    <xsl:param name="atgCTN"/>
    <xsl:variable name="result">
      <xsl:for-each-group select="$prdNode/AssetList/Asset[ResourceType=('CMS','DTS','FUD','FUM','FUR','FUS','FUZ','FWF','ICS' )]" group-by="ResourceType">
        <xsl:if test="position() != 1">,</xsl:if>
        <!--PWS=SGP9200_00_US-PWS-->
        <xsl:value-of select="concat(current-grouping-key(),'=',$atgCTN,'-',current-grouping-key())"/>
      </xsl:for-each-group>
    </xsl:variable>
    <xsl:value-of select="$result"/>
  </xsl:function>  
  
   
  <xsl:template name="assetList">
		<xsl:param name="country"/>
    <xsl:param name="atgCTN"/>
    <xsl:for-each-group select="AssetList/Asset[ResourceType != 'P3D'] " group-by="ResourceType">
      <xsl:for-each select="current-group()">
        <xsl:variable name="localisation">
          <xsl:choose>
            <xsl:when test="Language = '' ">global</xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="replace(Language,'-','_')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="suffixId"><xsl:value-of select="format-number(position(),'000')"/></xsl:variable>
        <xsl:variable name="language">
              <xsl:choose>
                <xsl:when test="Language = '' ">global</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$localelanguagefile/root/row[locale=$localisation]/language"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
        <xsl:variable name="languagecode">
              <xsl:choose>
                <xsl:when test="Language = '' ">global</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$localelanguagefile/root/row[locale=$localisation]/languagecode"/>
                </xsl:otherwise>
              </xsl:choose>
         </xsl:variable>
         <xsl:variable name="assetVersion" select="if (not(version) or version='') then $atgNullValue else version "/>         
        <add-item item-descriptor="asset" id="{concat('product-',$atgCTN,'-',current-grouping-key(),'-',$localisation,'-',$suffixId)}" repository="/atg/commerce/catalog/ProductCatalog">  
          <set-property name="locale">
            <xsl:choose>
              <xsl:when test="Language='' "><xsl:value-of select="$atgNullValue"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="replace(Language,'-','_')"/></xsl:otherwise>
            </xsl:choose>
          </set-property>
          <set-property name="documentType">
            <xsl:value-of select="ResourceType"/>
          </set-property>
          <set-property name="version">
            <xsl:value-of select="$assetVersion"/>
          </set-property>
          <set-property name="mimeType">
            <xsl:value-of select="Format"/>
          </set-property>
          <set-property name="fileSize">
            <xsl:value-of select="Extent"/>
          </set-property>
          <xsl:choose>
            <xsl:when test="PublicResourceIdentifier !='' ">
              <xsl:variable name="ext" select="tokenize(PublicResourceIdentifier,'\.')[last()]"/>
              <set-property name="externalUrl"><xsl:value-of select="PublicResourceIdentifier"/></set-property>
              <xsl:choose>
				   <!--/catalog/SGP9200_00-PWS-global-001.jpg -->
				  <xsl:when test="$doctypesfile/doctypes/doctype[@ATGAssets='yes'and @code=current-grouping-key()]">
					  <set-property name="internalUrl"><xsl:value-of select="concat('/catalog/',$atgCTN, '-' ,current-grouping-key(),'-',$localisation,'-',$suffixId,'.',$ext  )"/></set-property>
				  </xsl:when>
				  <xsl:otherwise>
					  <set-property name="internalUrl">__NULL__</set-property>
				  </xsl:otherwise>
			   </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="ext" select="tokenize(InternalResourceIdentifier,'\.')[last()]"/>
              <set-property name="externalUrl"><xsl:value-of select="InternalResourceIdentifier"/></set-property>
              <xsl:choose>
				   <!--/catalog/SGP9200_00-PWS-global-001.jpg -->
				  <xsl:when test="$doctypesfile/doctypes/doctype[@ATGAssets='yes'and @code=current-grouping-key()]">
					  <set-property name="internalUrl"><xsl:value-of select="concat('/catalog/',$atgCTN, '-' ,current-grouping-key(),'-',$localisation,'-',$suffixId,'.',$ext  )"/></set-property>
				  </xsl:when>
				  <xsl:otherwise>
					  <set-property name="internalUrl">__NULL__</set-property>
				  </xsl:otherwise>
			   </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="$doctypesfile/doctypes/doctype[@Scene7='yes' and @code=current-grouping-key()]">
              <set-property name="imagingServerId"><xsl:value-of select="concat($atgCTN, '-',current-grouping-key(),'-',$localisation,'-',$suffixId )"/></set-property>
            </xsl:when>
            <xsl:otherwise>
              <set-property name="imagingServerId">__NULL__</set-property>
            </xsl:otherwise>
          </xsl:choose>
        </add-item>
        
        
		<!-- IF this asset is a document then add reference in document. If it is a primary language add translation for document. -->
		<xsl:if test="Format='application/pdf' ">
			<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="document" id="{concat($atgCTN,'-',current-grouping-key())}">
					<set-property name="ctn"><xsl:value-of select="$atgCTN"/></set-property>
					<set-property name="doctype"><xsl:value-of select="current-grouping-key()"/></set-property>
					<xsl:if test="$localisation=$languagecode">            
						<set-property name="translations" add="true"><xsl:value-of select="concat($language,'=',$atgCTN,'-',current-grouping-key(),'-',$language)"/></set-property>
					</xsl:if>
			  </add-item>
			  
			<xsl:if test="$localisation=$languagecode">            
			<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="document-translation-language" id="{concat($atgCTN,'-',current-grouping-key(),'-',$language)}">	     
				  <set-property name="language"><xsl:value-of select="$language"/></set-property>   
				  <!-- add on to a set. Danger append may not work and may need to modify Java code!!! -->    			
				<set-property name="assets" add="true"><xsl:value-of select="concat('product-',$atgCTN,'-',current-grouping-key(),'-',$localisation,'-',$suffixId)"/></set-property>
			</add-item>
			</xsl:if>
		</xsl:if>
		
		<!-- IF this asset is a SOFTWARE DOWNLOAD then add reference in software-translation -->
		<xsl:if test="current-grouping-key() = ('CMS','DTS','FUD','FUM','FUR','FUS','FUZ','FWF','ICS' ) ">
			<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="software" id="{concat($atgCTN,'-',$country,'-',current-grouping-key())}"> 
				<xsl:if test="$localisation=$languagecode">         
					<set-property name="translations" add="true"><xsl:value-of select="concat($language,'=',$atgCTN,'-',current-grouping-key(),'-',$language)"/></set-property>
				</xsl:if>
			  </add-item>

			<xsl:if test="$localisation=$languagecode">			  			
				<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="software-translation" id="{concat($atgCTN,'-',current-grouping-key(),'-',$language)}">
			  <set-property name="releaseNotes">__NULL__</set-property>
			  <set-property name="comments">__NULL__</set-property>
				<!-- add on to a set. Danger append may not work and may need to modify Java code!!! -->
				<set-property name="assets" add="true"><xsl:value-of select="concat('product-',$atgCTN,'-',current-grouping-key(),'-',$localisation,'-',$suffixId)"/></set-property>
			</add-item>
			</xsl:if>
			
	</xsl:if>
        
      </xsl:for-each>
      
      <!-- id=product-SGP9200_00_US_CONSUMER-DFU-->
      <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="assetList" id="{concat('product-',$atgCTN,'_',$country,'-',current-grouping-key())}">
        <set-property name="assets">
          <xsl:for-each select="current-group()">
            <xsl:variable name="localisation">
              <xsl:choose>
                <xsl:when test="Language = '' ">global</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="replace(Language,'-','_')"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="suffixId"><xsl:value-of select="format-number(position(),'000')"/></xsl:variable>
            <xsl:if test="position() != 1">,</xsl:if>
            <!-- "product-SGP9200_00_US_CONSUMER-PWS-global-001,product-SGP9200_00_US_CONSUMER-PWS-global-002</ -->
            <xsl:value-of select="concat('product-',$atgCTN,'-',current-grouping-key(),'-',$localisation,'-',$suffixId)"/>
          </xsl:for-each>
        </set-property>
      </add-item>
    </xsl:for-each-group>
          <!-- Virtual assets -->
        <add-item item-descriptor="asset" id="{concat('product-',$atgCTN,'-IMS-',$locale,'-001')}" repository="/atg/commerce/catalog/ProductCatalog">
          <set-property name="locale"><xsl:value-of select="$atgNullValue"/></set-property>
          <set-property name="documentType">IMS</set-property>
          <set-property name="mimeType">image/jpeg</set-property>
          <set-property name="fileSize">0</set-property>
          <set-property name="externalUrl">http://</set-property>
          <set-property name="internalUrl">http://</set-property>
          <set-property name="imagingServerId"><xsl:value-of select="concat($atgCTN, '-IMS-',$locale)"/></set-property>
        </add-item>
        <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="assetList" id="{concat('product-',$atgCTN,'_',$country,'-','IMS')}">
          <set-property name="assets"><xsl:value-of select="concat('product-',$atgCTN,'-IMS-',$locale,'-001') "/></set-property>
        </add-item>
        <add-item item-descriptor="asset" id="{concat('product-',$atgCTN,'-GAL-',$locale,'-001')}" repository="/atg/commerce/catalog/ProductCatalog">
          <set-property name="locale"><xsl:value-of select="$atgNullValue"/></set-property>
          <set-property name="documentType">GAL</set-property>
          <set-property name="mimeType">image/jpeg</set-property>
          <set-property name="fileSize">0</set-property>
          <set-property name="externalUrl">http://</set-property>
          <set-property name="internalUrl">http://</set-property>
          <set-property name="imagingServerId"><xsl:value-of select="concat($atgCTN, '-GAL-',$locale)"/></set-property>
        </add-item>
          <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="assetList" id="{concat('product-',$atgCTN,'_',$country,'-','GAL')}">
          <set-property name="assets"><xsl:value-of select="concat('product-',$atgCTN,'_',$country,'-GAL-',$locale,'-001') "/></set-property>
        </add-item>                   
      <xsl:if test="AssetList/Asset[ResourceType='P3D']">
        <add-item item-descriptor="asset" id="{concat('product-',$atgCTN,'-P3D-global-001')}" repository="/atg/commerce/catalog/ProductCatalog">
          <set-property name="locale"><xsl:value-of select="$atgNullValue"/></set-property>
          <set-property name="documentType">P3D</set-property>
          <set-property name="mimeType">image/jpeg</set-property>
          <set-property name="fileSize">0</set-property>
          <set-property name="externalUrl">http://</set-property>
          <set-property name="internalUrl">http://</set-property>
          <set-property name="imagingServerId"><xsl:value-of select="concat($atgCTN, '-P3D-global')"/></set-property>
        </add-item>
          <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="assetList" id="{concat('product-',$atgCTN,'_',$country,'-','P3D')}">
          <set-property name="assets"><xsl:value-of select="concat('product-',$atgCTN,'_',$country,'-P3D-global-001') "/></set-property>
        </add-item>                          
      </xsl:if>           
  </xsl:template>
  
 
  <xsl:template name="virtualAssetList">
		<xsl:param name="country"/>
    <xsl:param name="atgCTN"/>
    
          <!-- Virtual assets -->
        <add-item item-descriptor="asset" id="{concat('product-',$atgCTN,'-IMS-',$locale,'-001')}" repository="/atg/commerce/catalog/ProductCatalog">
          <set-property name="locale"><xsl:value-of select="$atgNullValue"/></set-property>
          <set-property name="documentType">IMS</set-property>
          <set-property name="mimeType">image/jpeg</set-property>
          <set-property name="fileSize">0</set-property>
          <set-property name="externalUrl">http://</set-property>
          <set-property name="internalUrl">http://</set-property>
          <set-property name="imagingServerId"><xsl:value-of select="concat($atgCTN, '-IMS-',$locale)"/></set-property>
        </add-item>
        <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="assetList" id="{concat('product-',$atgCTN,'_',$country,'-','IMS')}">
          <set-property name="assets"><xsl:value-of select="concat('product-',$atgCTN,'-IMS-',$locale,'-001') "/></set-property>
        </add-item>
        <add-item item-descriptor="asset" id="{concat('product-',$atgCTN,'-GAL-',$locale,'-001')}" repository="/atg/commerce/catalog/ProductCatalog">
          <set-property name="locale"><xsl:value-of select="$atgNullValue"/></set-property>
          <set-property name="documentType">GAL</set-property>
          <set-property name="mimeType">image/jpeg</set-property>
          <set-property name="fileSize">0</set-property>
          <set-property name="externalUrl">http://</set-property>
          <set-property name="internalUrl">http://</set-property>
          <set-property name="imagingServerId"><xsl:value-of select="concat($atgCTN, '-GAL-',$locale)"/></set-property>
        </add-item>
          <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="assetList" id="{concat('product-',$atgCTN,'_',$country,'-','GAL')}">
          <set-property name="assets"><xsl:value-of select="concat('product-',$atgCTN,'_',$country,'-GAL-',$locale,'-001') "/></set-property>
        </add-item>                   
      
  </xsl:template>
	
	<xsl:template name="product-translation">
		<xsl:param name="locale"/>
		<xsl:param name="atgCTN"/>
		<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="product-translation" id="{concat($atgCTN,'_',$locale)}">
			<set-property name="displayName">
				<xsl:choose>
					<!--xsl:when test="my:atgNULL(NamingString/Descriptor/DescriptorName) != '__NULL__'"><xsl:value-of select="NamingString/Descriptor/DescriptorName"/></xsl:when-->
					<xsl:when test="my:atgNULL(ProductName) != '__NULL__'"><xsl:value-of select="substring(ProductName,0,257)"/></xsl:when>
					<xsl:when test="my:atgNULL(ShortDescription) != '__NULL__'"><xsl:value-of select="substring(ShortDescription,0,257)"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$atgCTN"/></xsl:otherwise>
				 </xsl:choose>
			</set-property>

			<set-property name="versionString">
				<xsl:value-of select="substring(my:atgNULL(NamingString/VersionString),0,129)"/>
			</set-property>
 			<set-property name="brandedFeature">
				<xsl:value-of select="my:atgNULL(NamingString/BrandedFeatureString)"/>
			</set-property>   
          	<set-property name="shortDescription">
				<xsl:value-of select="my:atgNULL(ShortDescription)"/>
			</set-property>
		</add-item>
	</xsl:template>


<xsl:template name="category-ctn">
		<xsl:param name="locale"/>
		<xsl:param name="country"/>
		<xsl:param name="atgCTN"/>
		<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="category-ctn" id="{concat(Categorization/SubcategoryCode,'*',$atgCTN)}"/>
</xsl:template>	

<xsl:template name="ctn-locale">
		<xsl:param name="locale"/>
		<xsl:param name="country"/>
		<xsl:param name="atgCTN"/>
		<xsl:param name="language"/>
		<!--xsl:variable name="language" select="$localelanguagefile/root/row[locale=$locale]/language"/-->
		<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="ctn-locale" id="{concat($atgCTN,'*',$country,'*',$language)}"/>
</xsl:template>	
	
	<xsl:template name="full-product">
		<xsl:param name="locale"/>
		<xsl:param name="country"/>
		<xsl:param name="atgCTN"/>
		<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="product" id="{concat($atgCTN,'_',$country)}">
			<set-property name="ctn">
				<xsl:value-of select="$atgCTN"/>
			</set-property>
			<set-property name="catalogId"><xsl:value-of select="concat('catalog_',$country,'_CARE')"/></set-property>
			<set-property name="imageUrl"><xsl:value-of select="CCR-ProductImage"/></set-property>
			<set-property name="product-has-downloads"><xsl:value-of select="if (HasSoftwareAsset='Y') then 'true' else 'false'"/></set-property>
			<set-property name="supraFeature">
				<xsl:value-of select="SupraFeature/@code"/>
			</set-property>
			<set-property name="subBrandCode">
				<xsl:value-of select="$atgNullValue"/>
			</set-property>
			<set-property name="restrictedInd">true</set-property>
			<set-property name="brandCode">
				<xsl:value-of select="my:atgNULL(NamingString/MasterBrand/BrandCode)"/>
			</set-property>
			<set-property name="brandName">
				<xsl:value-of select="my:atgNULL(NamingString/MasterBrand/BrandName)"/>
			</set-property>
			<set-property name="chassis">
				<xsl:value-of select="$atgNullValue"/>
			</set-property>
			<set-property name="translations" add="true">
				<xsl:value-of select="concat($locale,'_CARE','=',$atgCTN,'_',$locale)"/>
			</set-property>
			<set-property name="deleted">
				<xsl:value-of select="@Deleted"/>
			</set-property>      
      
<!--
			<set-property name="oleeChapterList" add="true">
				<xsl:value-of select="concat($locale,'=',$atgCTN,'_',$locale)"/>
			</set-property>
			
			<set-property name="assetMap">
				<xsl:value-of select="my:virtualAssetMap(.,$country,$atgCTN)"/>
			</set-property>
      <set-property name="documentMap">
        <xsl:value-of select="my:documentMap(.,$country,$atgCTN)"/>
      </set-property>
      <set-property name="softwareMap">
        <xsl:value-of select="my:softwareMap(.,$country,$atgCTN)"/>
      </set-property>
-->
		</add-item>
	</xsl:template>
	
	<xsl:template match="node()" mode="escape">
		<xsl:value-of select="concat('&lt;',local-name())"/>
		<xsl:apply-templates select="@*" mode="escape"/>
		<xsl:value-of select="concat('&gt;',text())"/>
		<xsl:apply-templates select="child::node()[local-name() != '']" mode="escape"/>
		<xsl:value-of select="concat('&lt;/',local-name(),'&gt;')"/>
	</xsl:template>
	
	<xsl:template match="@*" mode="escape">
		<xsl:value-of select="concat(' ',local-name(),'=&quot;',.,'&quot;')"/>
		<xsl:apply-templates select="@*|node()" mode="escape"/>
	</xsl:template>
	
	<xsl:template name="deleted-product">
		<xsl:param name="locale"/>
		<xsl:param name="country"/>
		<xsl:param name="atgCTN"/>
		<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="product" id="{concat($atgCTN,'_',$country)}">
<!--
			<set-property name="startDate">
				<xsl:value-of select="@StartOfPublication"/>
			</set-property>
			<set-property name="deleteAfterDate">
				<xsl:value-of select="my:atgNULL(@DeleteAfterDate)"/>
			</set-property>
-->
			<set-property name="deleted">
				<xsl:value-of select="@Deleted"/>
			</set-property>
<!--
			<set-property name="endDate">
				<xsl:value-of select="@EndOfPublication"/>
			</set-property>
-->
		</add-item>
	</xsl:template>
	
	<xsl:template match="/Products">
		<gsa-template>
			<import-items>
				<xsl:for-each select="Product">
					<xsl:variable name="lastModified" select="@lastModified" as="xsl:dateTime"/>
					<xsl:variable name="lastExportDate" select="@LastExportDate" as="xsl:dateTime"/>
					<xsl:variable name="isDeleted" select="@Deleted"/>
					<xsl:if test="$lastModified &gt; $lastExportDate">
						
						<xsl:variable name="atgCTN" select="my:normalized-id(CTN)"/>
						<xsl:variable name="country" select="if ($locale='master_global') then '00' else substring-after($locale,'_')"/>
						<xsl:variable name="language" select="if ($locale='master_global') then 'en' else substring-before($locale,'_')"/>
						<xsl:variable name="v_locale" select="if ($locale='master_global') then 'en_00' else $locale"/>
						<xsl:variable name="catalog" select="concat($country  ,'_',@Catalog)"/>
						<xsl:variable name="catalogLocale" select="concat($locale  ,'_',@Catalog)"/>
						
						<xsl:choose>
							<xsl:when test="$isDeleted ='true'"> 
								<xsl:call-template name="deleted-product">
									<xsl:with-param name="locale" select="$v_locale"/>
									<xsl:with-param name="country" select="$country"/>
									<xsl:with-param name="atgCTN" select="$atgCTN"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								
								<xsl:call-template name="product-translation">
									<xsl:with-param name="locale" select="$v_locale"/>
									<xsl:with-param name="atgCTN" select="$atgCTN"/>
								</xsl:call-template>
								

<!--
								<xsl:call-template name="oleeChapter">
									<xsl:with-param name="locale" select="$v_locale"/>
									<xsl:with-param name="country" select="$country"/>
									<xsl:with-param name="atgCTN" select="$atgCTN"/>
								</xsl:call-template>

								  <xsl:call-template name="virtualAssetList">
									<xsl:with-param name="country" select="$country"/>
									<xsl:with-param name="atgCTN" select="$atgCTN"/>
								  </xsl:call-template>
-->								 
								<xsl:call-template name="full-product">
									<xsl:with-param name="locale" select="$v_locale"/>
									<xsl:with-param name="country" select="$country"/>
									<xsl:with-param name="atgCTN" select="$atgCTN"/>
								</xsl:call-template>
								
								<xsl:call-template name="category-ctn">
									<xsl:with-param name="locale" select="$v_locale"/>
									<xsl:with-param name="country" select="$country"/>
									<xsl:with-param name="atgCTN" select="$atgCTN"/>
								</xsl:call-template>
								
								<xsl:call-template name="ctn-locale">
									<xsl:with-param name="locale" select="$v_locale"/>
									<xsl:with-param name="country" select="$country"/>
									<xsl:with-param name="atgCTN" select="$atgCTN"/>
									<xsl:with-param name="language" select="$language"/>
								</xsl:call-template>								
								
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:for-each>
			</import-items>
		</gsa-template>
	</xsl:template>
</xsl:stylesheet>
