<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2"
    exclude-result-prefixes="xs"
    extension-element-prefixes="asset-f">
  
  <xsl:variable name="s7-image-url-base" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>
  <xsl:variable name="s7-content-url-base" select="'http://images.philips.com/is/content/PhilipsConsumer/'"/>
  
  <xsl:function name="asset-f:createAssets">
    <xsl:param name="asset-id"/>
    <xsl:param name="asset-list"/>
    <xsl:param name="doc-types"/>
    <xsl:param name="export-channel"/>
    <xsl:param name="last-modified-ts"/>
    <xsl:param name="options"/>
    
    <xsl:for-each select="$asset-list/Asset[ResourceType=$doc-types/doctype[attribute::*[local-name()=$export-channel]='yes']/@code]">
      <xsl:copy-of select="asset-f:createAsset($asset-id, ., $doc-types, $last-modified-ts, $options)"/>
    </xsl:for-each>
  </xsl:function>
  
  <xsl:function name="asset-f:createObjectAssets">
    <xsl:param name="object-asset-list"/>
    <xsl:param name="doc-types"/>
    <xsl:param name="export-channel"/>
    <xsl:param name="last-modified-ts"/>
    <xsl:param name="options"/>
        
    <xsl:for-each select="$object-asset-list/Object/Asset[ResourceType!='GAL'][ResourceType=$doc-types/doctype[attribute::*[local-name()=$export-channel]='yes']/@code]">
      <xsl:copy-of select="asset-f:createAsset(../id, ., $doc-types, $last-modified-ts, $options)"/>
    </xsl:for-each>
  </xsl:function>

  <!--+
      | Create an external Asset element.
      |
      | Parameters:
      | 1. asset-id: The ID for the asset
      | 2. asset-raw: An Asset in internal format
      | 3. doc-types: The document type export configuration (as defined in doctype_attributes.xsd)
      | 4. options: Sequence of additional optional options, e.g.
              <extension>.html</extension>
              <include-dimensions/>
              <include-master-type/>
              <include-caption/>
              <include-extent/>
              <index-number>002</index-number>
              <scene7-url-base>http://image.philips.com/is/image/PhilipsConsumer/</scene7-url-base>
      +-->
  <xsl:function name="asset-f:createAsset">
    <xsl:param name="asset-id"/>
    <xsl:param name="asset-raw"/>
    <xsl:param name="doc-types"/>
    <xsl:param name="last-modified-ts"/>
    <xsl:param name="options"/>
    
    <xsl:variable name="extension">
      <xsl:choose>
        <xsl:when test="$options/extension">
          <xsl:value-of select="$options/extension"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="asset-f:getAssetExtension($asset-raw)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="description" select="$doc-types/doctype[@code=$asset-raw/ResourceType]/@description"/>
    
    <Asset code="{asset-f:escape-asset-code($asset-id)}" type="{$asset-raw/ResourceType}" locale="{if ($asset-raw/Language = '') then 'global' else $asset-raw/Language}"
           number="{if ($options/index-number != '') then $options/index-number else '001'}"
           description="{$description}"
           extension="{$extension}"
           lastModified="{substring-before($last-modified-ts,'T')}">
           
      <xsl:if test="$options/include-dimensions">
    	<xsl:variable name="dimension" select="replace($description,'^.*?(\d+)\s*x\s*(\d+)','$1,$2')"/>
    	<xsl:variable name="width" select="substring-before($dimension,',')"/>
    	<xsl:variable name="height" select="substring-after($dimension,',')"/>
        <xsl:if test="matches($width,'\d+') and number($width) &gt; 0">
          <xsl:attribute name="width"><xsl:value-of select="$width" /></xsl:attribute>
        </xsl:if>
        <xsl:if test="matches($height,'\d+') and number($height) &gt; 0">
          <xsl:attribute name="height"><xsl:value-of select="$height" /></xsl:attribute>
        </xsl:if>
      </xsl:if>
      
      <xsl:if test="$options/include-master-type">
	    <xsl:variable name="master" select="$doc-types/doctype[@code=$asset-raw/ResourceType]/@master"/>
        <xsl:if test="$master != ''">
          <xsl:attribute name="master"><xsl:value-of select="$master" /></xsl:attribute>
        </xsl:if>
      </xsl:if>
      
      <xsl:if test="$options/include-caption and $asset-raw/Caption">
        <xsl:attribute name="caption" select="$asset-raw/Caption"/>
      </xsl:if>
      
      <xsl:if test="$options/include-extent and $asset-raw/Extent">
        <xsl:attribute name="extent" select="$asset-raw/Extent"/>
      </xsl:if>
      
      <xsl:choose>
      	<xsl:when test="$options/secureURL = 'yes' and
      				    $asset-raw/SecureResourceIdentifier != '' and
                        $asset-raw/ResourceType = $doc-types/doctype[attribute::*[local-name()='secureURL']='yes']/@code">
        	<xsl:value-of select="$asset-raw/SecureResourceIdentifier"/>
      	</xsl:when>
      	<xsl:otherwise>
        	<xsl:value-of select="asset-f:getAssetUrl($asset-id, $asset-raw, $doc-types, $options)"/>      	
      	</xsl:otherwise>      	
      </xsl:choose>      
    </Asset>
  </xsl:function>
  
  <xsl:function name="asset-f:createVirtualAsset">
    <xsl:param name="id"/>
    <xsl:param name="type"/>
    <xsl:param name="language"/>
    <xsl:param name="url"/>
    <xsl:param name="last-modified-ts"/>
    <xsl:param name="description"/>
    <xsl:param name="index-number"/>
    <xsl:param name="extension"/>
    
    <Asset code="{asset-f:escape-asset-code($id)}" type="{$type}" locale="{$language}"
           number="{$index-number}"
           description="{$description}"
           extension="{$extension}"
           lastModified="{substring-before($last-modified-ts,'T')}">
      <xsl:value-of select="$url"/>
    </Asset>
  </xsl:function>
  
  <!--
     | Returns true if the specified asset type is exported to at least one of the specified channels.
     -->
  <xsl:function name="asset-f:isAssetExportedToChannel" as="xs:boolean">
    <xsl:param name="doc-types"/>
    <xsl:param name="asset-type"/>
    <xsl:param name="channels"/> <!-- channels may be a single string or a list of strings -->
    <xsl:value-of select="$doc-types/doctype[@code=$asset-type]/attribute::*[local-name()=$channels]='yes'"/>
  </xsl:function>

  <xsl:function name="asset-f:getAssetExtension">
    <xsl:param name="asset-raw"/>
    
    <xsl:analyze-string regex="\.(\w+?)$" select="$asset-raw/InternalResourceIdentifier">
      <xsl:matching-substring>
        <xsl:value-of select="regex-group(1)"/>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:choose>
          <xsl:when test="$asset-raw/ResourceType=('AWU','AWW')">
            <xsl:text>html</xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:function>
  
  <!--+
      | Create an Asset URL.
      |
      | Parameters:
      | 1. asset-raw: An Asset in internal format
      | 2. doc-types: The document type export configuration (as defined in doctype_attributes.xml)
      +-->
  <xsl:function name="asset-f:getAssetUrl">
    <xsl:param name="asset-id"/>
    <xsl:param name="asset-raw"/>
    <xsl:param name="doc-types"/>
    <xsl:param name="options"/>

    <xsl:variable name="asset-language" select="if($asset-raw/Language = '') then 'global' else $asset-raw/Language"/>
    <xsl:variable name="url-base" select="if (asset-f:isAssetExportedToChannel($doc-types,$asset-raw/ResourceType,('S7Content')))
                                          then $s7-content-url-base
                                          else $s7-image-url-base"/>
    
    <xsl:choose>
      <xsl:when test="asset-f:isAssetExportedToChannel($doc-types,$asset-raw/ResourceType,('Scene7','Scene7Lighting'))
                      and asset-f:isAssetExportedToChannel($doc-types,$asset-raw/ResourceType,('S7URL'))
                      and $asset-raw/ResourceType!='AWR'">
        <!-- 
          This is an Asset that is sent to Scene7, so create a Scene7 URL.
          Exception to the rule is an AWR asset whose URL should be sent as is.
        -->                                              
        <xsl:value-of select="asset-f:buildScene7Url($url-base,
                                                     $asset-id,
                                                     $asset-raw/ResourceType,
                                                     $asset-language,
                                                     $options/index-number)"/>
      </xsl:when>
      <xsl:when test="asset-f:isAssetExportedToChannel($doc-types,$asset-raw/ResourceType,('Scene7Videos'))
                      and asset-f:isAssetExportedToChannel($doc-types,$asset-raw/ResourceType,('S7URL'))">
        <!-- 
          This is a video asset that is sent to Scene7, so create a Scene7Video URL.
        -->
        <xsl:value-of select="asset-f:buildScene7VideoUrl($url-base
                                                       , asset-f:createScene7VideoId($asset-raw)
                                                       )"/>
      </xsl:when>
      <xsl:when test="$asset-raw/PublicResourceIdentifier != ''">
        <xsl:value-of select="$asset-raw/PublicResourceIdentifier"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(asset-f:escape-scene7-id($asset-id),
                              '-',
                              $asset-raw/ResourceType,
                              '-',
                              $asset-language,
                              '-',
                              if ($options/index-number) then $options/index-number else '001',
                              '.',
                              if ($options/extension) then $options/extension else asset-f:getAssetExtension($asset-raw)
                              )"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!--
    Create a Scene7 ID for video files.
    The ID is based on the assets request ID (e.g. 110817012g) from CCR which is taken from the InternalResourceIdentifier.
    The ID is prefixed with a fixed string 'CCR' and has a fixed suffix '-global-001'. The doctype is added as well.
    
    E.g. http://pww.pcc.philips.com/mprdata/110817/110817012g_hq1.mp4 becomes CCR110817012G-HQ1-global-001
  -->
  <xsl:function name="asset-f:createScene7VideoId">
    <xsl:param name="asset-raw"/>
    
    <xsl:value-of select="concat('CCR'
                        , upper-case(replace(tokenize($asset-raw/InternalResourceIdentifier,'/')[last()],'_(.+?)$',''))
                        , '-'
                        , $asset-raw/ResourceType
                        , '-global-001'
                        )"/>
  </xsl:function>
  
  <!--
    Build a Scene7 URL for images.
    
    Params 
    url-base  The base Scene7 URL
    asset-id  The asset id of the object (CTN or otherwise.)
    type      The asset doctype
    language  The locale. Optional: 'global' will be used as default.
    index-number  The index number. Optional: '001' will be used as default, except for GAL, IMS and P3D where the number is absent.
  -->
  <xsl:function name="asset-f:buildScene7Url">
    <xsl:param name="url-base"/>
    <xsl:param name="asset-id"/>
    <xsl:param name="type"/>
    <xsl:param name="language"/>
    <xsl:param name="index-number"/>
    
    <xsl:value-of select="$url-base"/>
    <xsl:if test="not(ends-with($url-base, '/'))">
      <xsl:text>/</xsl:text>
    </xsl:if>
    <xsl:value-of select="asset-f:escape-scene7-id($asset-id)"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="$type"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="if ($language != '') then $language else 'global'"/>
    <xsl:if test="not($type=('GAL','IMS','P3D'))">
      <xsl:text>-</xsl:text>
      <xsl:choose>
        <xsl:when test="$index-number != ''">
          <xsl:value-of select="$index-number"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>001</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:function>
  
  <!-- 
    Create a Scene7 video URL.
    
    Params 
    url-base  The base Scene7 URL
    asset-id  The full Scene7 asset ID
  -->
  <xsl:function name="asset-f:buildScene7VideoUrl">
    <xsl:param name="url-base"/>
    <xsl:param name="asset-id"/>
    
    <xsl:value-of select="$url-base"/>
    <xsl:if test="not(ends-with($url-base, '/'))">
      <xsl:text>/</xsl:text>
    </xsl:if>
    <xsl:value-of select="$asset-id"/>
  </xsl:function>

  <xsl:function name="asset-f:escape-asset-code">
    <xsl:param name="id"/>
    <xsl:value-of select="replace($id,'/','_')"/>
  </xsl:function>

  <xsl:function name="asset-f:escape-scene7-id">
    <xsl:param name="id"/>
    <xsl:value-of select="replace($id,'[^0-9a-zA-Z_]+','_')"/>
  </xsl:function>
  
  <xsl:function name="asset-f:buildFamilyDetailPageUrl">
    <xsl:param name="code"/>
    <xsl:param name="locale"/>
    <xsl:param name="catalogtype"/>
    <xsl:param name="system-id"/>
    
    <xsl:if test="$system-id='PikachuB2B'">
      <xsl:text>http://www.ecat.lighting.philips.com/l/</xsl:text>
      <xsl:value-of select="$code"/>
      <xsl:text>_FA_</xsl:text>
      <!-- country -->
      <xsl:value-of select="upper-case(substring-after($locale, '_'))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="$catalogtype"/>
      <xsl:text>/cat/</xsl:text>
      <!-- language -->
      <xsl:value-of select="substring-before($locale,'_')"/>
      <xsl:text>/</xsl:text>
      <!-- country -->
      <xsl:value-of select="lower-case(substring-after($locale, '_'))"/>
      <!-- catalog type -->
      <!--
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$catalogtype"/>
      -->
    </xsl:if>
  </xsl:function>

  <xsl:function name="asset-f:buildProductDetailPageUrl">
    <xsl:param name="product"/>
    <xsl:param name="locale"/>
    <xsl:param name="system-id"/>
    <xsl:param name="catalogtype"/>
    <xsl:param name="country-domains"/>

    <xsl:variable name="ctn" select="$product/CTN"/>
    
    <xsl:choose>
      <xsl:when test="$system-id='PikachuB2B'">
        <!-- B2B -->
        <xsl:text>http://www.ecat.lighting.philips.com/l/</xsl:text>
        <xsl:value-of select="$ctn"/>
        <xsl:text>/prd/</xsl:text>
        <!-- language -->
        <xsl:value-of select="substring-before($locale,'_')"/>
        <xsl:text>/</xsl:text>
        <!-- country -->
        <xsl:value-of select="lower-case(substring-after($locale, '_'))"/>
        <!-- catalog type -->
        <xsl:text>/</xsl:text>
        <xsl:value-of select="lower-case($catalogtype)"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- B2C -->
        <!-- Check if there's a brand specific configuration -->
        <xsl:variable name="brand-code" select="$product/NamingString/MasterBrand/BrandCode/text()"/>
        <xsl:choose>
          <xsl:when test="exists($country-domains/domain[@target='.com'][@country=substring($locale,4)][@brand=$brand-code])">
            <xsl:apply-templates select="$product" mode="pdp-url-brand">
              <xsl:with-param name="ctn" select="$ctn"/>
              <xsl:with-param name="locale" select="$locale"/>
              <xsl:with-param name="catalogtype" select="$catalogtype"/>
              <xsl:with-param name="domain" select="$country-domains/domain[@target='.com'][@country=substring($locale,4)][@brand=$brand-code]"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <!-- Default Philips Consumer catalog website -->
			<!-- US36450(Correct the PDP URL in the PMT): 
				URL structure will be
					For countries with one language
						http://[domain]/c-p/[CTN]/[SEO name]
					For countries with multiple languages
						http://[domain]/[lang]/c-p/[CTN]/[SEO name]
			-->			
			<xsl:variable name="domain" select="$country-domains/domain[@target='.com'][@country=substring($locale,4)][string(@brand)='']"/>
			<xsl:choose>
				<xsl:when test="$country-domains/domain[@target='.com'][@country=substring($locale,4)][@exportToCQ='Y']">
					<xsl:variable name="countryCode" select="substring-after($locale,'_')"/>
					<xsl:variable name="oneLanguage" select="'0'"/>
					
					<xsl:variable name="multipleLanguageCountryCode" select="document('../xml/multipleLanguageCountryList.xml')"/> 
					<xsl:variable name="multipleLanguage" select="$multipleLanguageCountryCode/sql:rowset/sql:row[sql:country_code = $countryCode]/sql:country_code"/>
					<xsl:text>http://</xsl:text>
					<xsl:value-of select="if ($domain) then $domain else 'www.philips.com'"/>
					
					<xsl:if test="$multipleLanguage='BE'">
						<xsl:variable name='default_locale' select ="'nl_BE'"/>
						<xsl:if test= "$default_locale != $locale">
							<xsl:text>/</xsl:text>
							<xsl:value-of select="substring-before($locale,'_')"/>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$multipleLanguage='CH'">
						<xsl:variable name='default_locale' select ="'de_CH'"/>
						<xsl:if test= "$default_locale != $locale">
							<xsl:text>/</xsl:text>
							<xsl:value-of select="substring-before($locale,'_')"/>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$multipleLanguage='CA'">
						<xsl:variable name='default_locale' select ="'en_CA'"/>
						<xsl:if test= "$default_locale != $locale">
							<xsl:text>/</xsl:text>
							<xsl:value-of select="substring-before($locale,'_')"/>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$multipleLanguage='MY'">
						<xsl:variable name='default_locale' select ="'en_MY'"/>
						<xsl:if test= "$default_locale != $locale">
							<xsl:text>/</xsl:text>
							<xsl:value-of select="substring-before($locale,'_')"/>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$multipleLanguage='EG'">
						<xsl:variable name='default_locale' select ="'ar_EG'"/>
						<xsl:if test= "$default_locale != $locale">
							<xsl:text>/</xsl:text>
							<xsl:value-of select="substring-before($locale,'_')"/>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$multipleLanguage='IL'">
						<xsl:variable name='default_locale' select ="'en_IL'"/>
						<xsl:if test= "$default_locale != $locale">
							<xsl:text>/</xsl:text>
							<xsl:value-of select="substring-before($locale,'_')"/>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$multipleLanguage='HK'">
						<xsl:variable name='default_locale' select ="'zh_HK'"/>
						<xsl:if test= "$default_locale != $locale">
							<xsl:text>/</xsl:text>
							<xsl:value-of select="substring-before($locale,'_')"/>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$multipleLanguage='US'">
						<xsl:variable name='default_locale' select ="'en_US'"/>
						<xsl:if test= "$default_locale != $locale">
							<xsl:text>/</xsl:text>
							<xsl:value-of select="substring-before($locale,'_')"/>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$multipleLanguage='ID'">
						<xsl:variable name='default_locale' select ="'en_ID'"/>
						<xsl:if test= "$default_locale != $locale">
							<xsl:text>/</xsl:text>
							<xsl:value-of select="substring-before($locale,'_')"/>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$multipleLanguage='UA'">
						<xsl:variable name='default_locale' select ="'uk_UA'"/>
						<xsl:if test= "$default_locale != $locale">
							<xsl:text>/</xsl:text>
							<xsl:value-of select="substring-before($locale,'_')"/>
						</xsl:if>
					</xsl:if>
					 <xsl:if test="$multipleLanguage='SA'">
                         <xsl:variable select="'ar_SA'" name="default_locale"/>
                         <xsl:if test="$default_locale != $locale">
                               <xsl:text>/</xsl:text>
                               <xsl:value-of select="substring-before($locale,'_')"/>
                         </xsl:if>
                     </xsl:if>
					<xsl:if test="$multipleLanguage='KW'">
                        <xsl:variable select="'ar_KW'" name="default_locale"/>
                        <xsl:if test="$default_locale != $locale">
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="substring-before($locale,'_')"/>
                        </xsl:if>
                    </xsl:if>

                    <xsl:if test="$multipleLanguage='AE'">
                         <xsl:variable select="'ar_AE'" name="default_locale"/>
                         <xsl:if test="$default_locale != $locale">
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="substring-before($locale,'_')"/>
                         </xsl:if>
                    </xsl:if>


                     <xsl:if test="$multipleLanguage='OM'">
                            <xsl:variable select="'ar_OM'" name="default_locale"/>
                            <xsl:if test="$default_locale != $locale">
                                <xsl:text>/</xsl:text>
                                <xsl:value-of select="substring-before($locale,'_')"/>
                             </xsl:if>
                     </xsl:if>


                    <xsl:if test="$multipleLanguage='QA'">
                             <xsl:variable select="'ar_QA'" name="default_locale"/>
                             <xsl:if test="$default_locale != $locale">
                                <xsl:text>/</xsl:text>
                                <xsl:value-of select="substring-before($locale,'_')"/>
                            </xsl:if>
                     </xsl:if>


                    <xsl:if test="$multipleLanguage='BH'">
                            <xsl:variable select="'ar_BH'" name="default_locale"/>
                            <xsl:if test="$default_locale != $locale">
                                <xsl:text>/</xsl:text>
                                <xsl:value-of select="substring-before($locale,'_')"/>
                            </xsl:if>
                    </xsl:if>

                    <xsl:if test="$multipleLanguage='LB'">
                            <xsl:variable select="'ar_LB'" name="default_locale"/>
                            <xsl:if test="$default_locale != $locale">
                                <xsl:text>/</xsl:text>
                                <xsl:value-of select="substring-before($locale,'_')"/>
                            </xsl:if>
                    </xsl:if>


                    <xsl:if test="$multipleLanguage='JO'">
                            <xsl:variable select="'ar_JO'" name="default_locale"/>
                            <xsl:if test="$default_locale != $locale">
                                    <xsl:text>/</xsl:text>
                                    <xsl:value-of select="substring-before($locale,'_')"/>
                            </xsl:if>
                    </xsl:if>

					<xsl:text>/c-p/</xsl:text>					
					<xsl:value-of select="translate($ctn,'./','__')"/>					
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$product/SEOProductName"/>   
				</xsl:when>				
				 
			</xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
 
  <!-- Gaggia product detail page URL - brand specific -->
  <xsl:template match="Product[NamingString/MasterBrand/BrandCode='GAG']" mode="pdp-url-brand">
    <xsl:param name="ctn"/>
    <xsl:param name="locale"/>
    <xsl:param name="catalogtype"/>
    <xsl:param name="domain"/>
    <xsl:variable name="target-ctn" select="replace($ctn,'/','_')"/>
    
    <xsl:text>http://</xsl:text>
    <xsl:value-of select="$domain"/>
    <xsl:value-of select="replace(
                             replace($domain/@pdpurl
                                  , '#ctn#', $target-ctn)
                           , '#lang#', substring-before($locale, '_'))"/>
  </xsl:template>
  
  <!--  Build the technical PDP URL -->
  <xsl:function name="asset-f:buildShopProductDetailPageUrl">
    <xsl:param name="product"/>
    <xsl:param name="locale"/>
    <xsl:param name="catalogtype"/>
    <xsl:param name="country-domains"/>

    <xsl:variable name="domain" select="$country-domains/domain[@target='.shop'][@country=substring($locale,4)]"/>

    <xsl:text>http://</xsl:text>
    <xsl:value-of select="if ($domain) then $domain else 'www.philips-shop.com'"/>
    <xsl:text>/store/browse/product_detail.jsp?product_id=</xsl:text>
    <xsl:value-of select="concat(replace($product/CTN,'/','_'), '_', substring-after($locale, '_'), '_', $catalogtype)" />
    <xsl:text>&amp;country=</xsl:text>
    <xsl:value-of select="substring-after($locale, '_')" />
    <xsl:text>&amp;language=</xsl:text>
    <xsl:value-of select="substring-before($locale,'_')"/>
  </xsl:function>
  
  <!-- CJ : C1014188 - New function for Saeco Product URL change -->
  <xsl:function name="asset-f:buildProductDetailPageUrl-saeco">
    <xsl:param name="product"/>
    <xsl:param name="locale"/>
    <xsl:param name="system-id"/>
    <xsl:param name="catalogname"/>
    <xsl:param name="country-domains"/>

    <xsl:variable name="ctn" select="$product/CTN"/>

	<xsl:variable name="domain-name">
		<xsl:choose>
         	<xsl:when test="exists($country-domains/domain[@target='saeco'][@country=substring($locale,4)])">            
           	<xsl:value-of select="$country-domains/domain[@target='saeco'][@country=substring($locale,4)]"/>
         	</xsl:when>
         	<xsl:otherwise>
         		<xsl:text>www.saeco.us</xsl:text>
         	</xsl:otherwise>
    	</xsl:choose>	    
	</xsl:variable>

	<xsl:variable name="url-part-I">automatic-espresso-machine/espresso-machine</xsl:variable>
		
		<xsl:text>http://</xsl:text>
		<xsl:value-of select="$domain-name"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="$url-part-I"/>
		
		<xsl:if test="$catalogname != ''">
			<xsl:text>/</xsl:text>
			<xsl:value-of select="replace(lower-case($catalogname),' ','-')"/>
		</xsl:if>
		
		<xsl:text>/</xsl:text>
		<xsl:value-of select="replace($ctn,'/','_')"/>
		
  </xsl:function>
  
</xsl:stylesheet>
