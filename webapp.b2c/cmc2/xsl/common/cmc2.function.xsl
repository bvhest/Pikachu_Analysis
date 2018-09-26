<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet   version="2.0" 
                  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                  xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                  xmlns:xs="http://www.w3.org/2001/XMLSchema"
                  xmlns:cmc2-f="http://www.philips.com/cmc2-f"
                  extension-element-prefixes="cmc2-f" 
                  exclude-result-prefixes="sql xs"
                  >  
  <!-- -->
  <xsl:param name="scene7-url-base" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>
  <xsl:param name="scene7-url-base-content" select="'http://images.philips.com/is/content/PhilipsConsumer/'"/>
  <xsl:param name="runmode"/>
  <!-- -->
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  <xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer'"/>
  
  <xsl:variable name="apos">'</xsl:variable>  
  <!-- -->
  <xsl:function name="cmc2-f:formatDate">
  <!--+
      |  Reformat date string:
      |         20070919164110
      |       IN: yyyymmddHH24miss
      |      OUT: yyyy-mm-ddTHH:mm:ss
      +-->
    <xsl:param name="date"/>
    <xsl:choose>
      <xsl:when test="$date=''">
        <xsl:value-of select="''"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T',substring($date,9,2),':',substring($date,11,2),':',substring($date,13,2))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>  
 	<!-- -->
	<xsl:function name="cmc2-f:productGrouping">
		<xsl:param name="ctn"/>
		<xsl:param name="division"/>
		<xsl:param name="country"/>
	  <xsl:variable name="file" select="document('../../xml/emea_countries.xml')" />
		
		<xsl:variable name="id" select="if (contains($ctn, '/')) then substring-before($ctn, '/') else $ctn"/>		
		<xsl:variable name="grouping">
			<xsl:choose>
				<xsl:when test="$division = 'Lighting' and $country = $file/countries/country[@emea=1]/@code and not(contains($ctn, '/')) and (string-length($ctn) = 9)">
              <xsl:value-of select="concat(substring($id,1,5),substring($id,8))"/>
				</xsl:when>
				<xsl:otherwise>
			      <xsl:choose>
			        <!-- has less than 4 characters-->
			        <xsl:when test="string-length($id) &lt; 4 ">
			          <xsl:value-of select="$id"/>
			        </xsl:when>
			        <!-- first character is NOT a number -->
			        <xsl:when test="string(number(substring($id, 1, 1)))='NaN'">
			          <xsl:value-of select="$id"/>
			        </xsl:when>
			        <!-- first character is a number and second character is not a number-->
			        <xsl:when test="string(number(substring($id, 2, 1)))='NaN'">
			          <xsl:value-of select="substring($id,2)"/>
			        </xsl:when>
			        <!-- first and second characters are numbers and third character is not a number-->
			        <xsl:when test="string(number(substring($id, 3, 1)))='NaN'">
			          <xsl:value-of select="substring($id,3)"/>
			        </xsl:when>
			        <!-- first, second and third characters are numbers and fourth character is not a number-->
			        <xsl:when test="string(number(substring($id, 4, 1)))='NaN'">
			          <xsl:value-of select="substring($id,3)"/>
			        </xsl:when>
			        <!-- first four charatcters are numbers-->
			        <xsl:otherwise>
			          <xsl:value-of select="$id"/>
			        </xsl:otherwise>
			      </xsl:choose>				
				</xsl:otherwise>							
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$grouping"/>
	</xsl:function>
	<!-- -->   
  <xsl:function name="cmc2-f:formatFullProductName">
  <!--+
      |  Create full product name out of constituent parts of NamingString element
      |       IN: NamingString (element)
      |      OUT: Full product name (string)
      +-->
    <xsl:param name="vNamingString"/>
    <xsl:variable name="TempFullNaming">
      <xsl:choose>
        <xsl:when test="$vNamingString!=''">
          <xsl:choose>
            <xsl:when test="string-length($vNamingString/BrandString) &gt; 0">
              <xsl:value-of select="$vNamingString/BrandString"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="if($vNamingString/Family/FamilyName != '') then $vNamingString/Family/FamilyName else $vNamingString/Concept/ConceptName"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/Descriptor/DescriptorName"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/Partner/PartnerProductName"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/Alphanumeric"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/VersionString"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/BrandedFeatureString"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/BrandString2"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$vNamingString/MasterBrand/BrandName"/>
              <xsl:text> </xsl:text>
              <xsl:choose>
                <xsl:when test="string-length($vNamingString/Concept/ConceptName) &gt; 0 and $vNamingString/Concept/ConceptName != 'NULL'">
                  <xsl:value-of select="$vNamingString/Concept/ConceptName"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$vNamingString/Partner[1]/PartnerBrand/BrandName"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/Descriptor/DescriptorName"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/Alphanumeric"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/VersionString"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/BrandedFeatureString"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="normalize-space(replace(replace(replace($TempFullNaming,'NULL',''),'&lt;not applicable&gt;',''),'PHILIPS','Philips'))"/>
  </xsl:function>  
  <!-- -->
  <xsl:function name="cmc2-f:doAsset">
    <xsl:param name="id"/>
    <xsl:param name="Language"/>
    <xsl:param name="description"/>    
    <xsl:param name="InternalResourceIdentifier"/>
    <xsl:param name="PublicResourceIdentifier"/>
    <xsl:param name="ResourceType"/>
    <xsl:param name="Modified"/>
    <xsl:param name="Number"/>    
    <xsl:param name="Extension"/>        
    <xsl:param name="URL"/>            
    <xsl:param name="Publisher"/>                
    <xsl:param name="doctypes"/> <!-- doctypes attributes -->
    <xsl:variable name="escid" select="cmc2-f:escape-asset-code($id)"/>
    <xsl:variable name="assetlanguage" select="if($Language = '') then 'global' else $Language"/>
    <xsl:variable name="extension">
      <xsl:choose>
        <xsl:when test="$Extension != ''">
          <xsl:value-of select="$Extension"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:analyze-string regex="\.(\w+?)$" select="$InternalResourceIdentifier">
            <xsl:matching-substring>
              <xsl:value-of select="regex-group(1)"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
              <xsl:choose>
                <xsl:when test="$ResourceType=('AWU','AWW')">
                  <xsl:text>html</xsl:text>
                </xsl:when>
              </xsl:choose>
            </xsl:non-matching-substring>
          </xsl:analyze-string>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="url">
      <xsl:choose>
        <xsl:when test="$URL != ''">
          <xsl:value-of select="$URL"/>
        </xsl:when>
        <xsl:when test="starts-with($PublicResourceIdentifier,$scene7-url-base)">
          <xsl:value-of select="$PublicResourceIdentifier"/>
        </xsl:when>
        <xsl:when test="cmc2-f:isAssetExportedToChannel($doctypes,$ResourceType,('Scene7','Scene7Lighting'))
                    and cmc2-f:isAssetExportedToChannel($doctypes,$ResourceType,('S7URL'))">
	        <!-- This is an Asset that is sent to Scene7, so create a Scene7 URL -->
	        <xsl:value-of select="if (cmc2-f:isAssetExportedToChannel($doctypes,$ResourceType,('S7Content'))) then $scene7-url-base-content else $scene7-url-base"/>
	        <xsl:value-of select="concat(cmc2-f:escape-scene7-id($id),'-',$ResourceType,'-',$assetlanguage)"/>
	        <xsl:if test="not($ResourceType=('GAL','IMS','P3D'))">
	          <xsl:text>-</xsl:text>
	          <xsl:value-of select="$Number"/>
	        </xsl:if>
        </xsl:when>
          <!-- 
            This is a video Asset that is sent to Scene7, so create a Scene7 Video URL.
            ID is based on CCR request ID in the InternalResourceIdentifier.
            language is always 'global'. 
          -->
        <!--
        <xsl:when test="cmc2-f:isAssetExportedToChannel($doctypes,$ResourceType,('Scene7Videos'))
                    and cmc2-f:isAssetExportedToChannel($doctypes,$ResourceType,('S7URL'))">
          <xsl:value-of select="if (cmc2-f:isAssetExportedToChannel($doctypes,$ResourceType,('S7Content'))) then $scene7-url-base-content else $scene7-url-base"/>
          <xsl:value-of select="concat('CCR'
                                     , upper-case(replace(tokenize($InternalResourceIdentifier,'/')[last()],'_(.+?)$',''))
                                     , '-', $ResourceType,'-global-001'
                                     )"/>
        </xsl:when>
        -->
        <xsl:when test="$PublicResourceIdentifier != ''">
          <xsl:value-of select="$PublicResourceIdentifier"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($escid,'-',$ResourceType,'-',$assetlanguage,'-',$Number,'.',$extension)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <Asset code="{$escid}" type="{$ResourceType}" locale="{$assetlanguage}" number="{$Number}" description="{$description}" extension="{$extension}" lastModified="{substring($Modified,1,10)}"><xsl:value-of select="$url"/></Asset>
  </xsl:function>
  
  <!-- 
     Function name : doAssetSecure
     Author        : CJ
     Description   : Function to export secure URLs instead of public URLs 
   -->  
  <xsl:function name="cmc2-f:doAssetSecure">
    <xsl:param name="id"/>
    <xsl:param name="Language"/>
    <xsl:param name="description"/>    
    <xsl:param name="InternalResourceIdentifier"/>
    <xsl:param name="PublicResourceIdentifier"/>
    <xsl:param name="SecureResourceIdentifier"/>
    <xsl:param name="ResourceType"/>
    <xsl:param name="Modified"/>
    <xsl:param name="Number"/>    
    <xsl:param name="Extension"/>        
    <xsl:param name="URL"/>            
    <xsl:param name="Publisher"/>                
    <xsl:param name="doctypes"/>

	<xsl:choose>
		<xsl:when test="$PublicResourceIdentifier != ''">		
			<xsl:copy-of select="cmc2-f:doAsset($id,$Language,$description,$InternalResourceIdentifier,$PublicResourceIdentifier,$ResourceType,$Modified,$Number,$Extension,'',$Publisher, $doctypes)"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy-of select="cmc2-f:doAsset($id,$Language,$description,$InternalResourceIdentifier,$SecureResourceIdentifier,$ResourceType,$Modified,$Number,$Extension,$SecureResourceIdentifier,$Publisher, $doctypes)"/>		
		</xsl:otherwise>
	</xsl:choose>
  
  </xsl:function>
  
  <!--
     | doAssetExtended
     | adds width, height and master attributes.
     | code attribute is the unescaped id.
  -->
  <xsl:function name="cmc2-f:doAssetExtended">
    <xsl:param name="id"/>
    <xsl:param name="Language"/>
    <xsl:param name="description"/>    
    <xsl:param name="InternalResourceIdentifier"/>
    <xsl:param name="PublicResourceIdentifier"/>
    <xsl:param name="ResourceType"/>
    <xsl:param name="Modified"/>
    <xsl:param name="Number"/>    
    <xsl:param name="Extension"/>        
    <xsl:param name="URL"/>
    <xsl:param name="Publisher"/>
    <xsl:param name="doctypes"/> <!-- doctypes attributes -->
    
    <xsl:variable name="dimension" select="replace($description,'^.*?(\d+)\s*x\s*(\d+)','$1,$2')"/>
    <xsl:variable name="width" select="substring-before($dimension,',')"/>
    <xsl:variable name="height" select="substring-after($dimension,',')"/>
    <xsl:variable name="master" select="$doctypes/doctype[@code=$ResourceType]/@master"/>
    
    <xsl:variable name="asset" select="cmc2-f:doAsset($id,$Language,$description,$InternalResourceIdentifier,$PublicResourceIdentifier,$ResourceType,$Modified,$Number,$Extension,$URL,$Publisher,$doctypes)"/>
    
    <Asset>
      <xsl:copy-of select="$asset/@*"/>
      <xsl:if test="number($width) &gt; 0">
        <xsl:attribute name="width"><xsl:value-of select="$width" /></xsl:attribute>
      </xsl:if>
      <xsl:if test="number($height) &gt; 0">
        <xsl:attribute name="height"><xsl:value-of select="$height" /></xsl:attribute>
      </xsl:if>
      <xsl:if test="$master != ''">
        <xsl:attribute name="master"><xsl:value-of select="$master" /></xsl:attribute>
      </xsl:if>
      <xsl:value-of select="$asset" />
	</Asset>
  </xsl:function>
  <!-- -->
  <xsl:function name="cmc2-f:doLegacyAsset">
    <xsl:param name="id"/>
    <xsl:param name="Language"/>
    <xsl:param name="description"/>    
    <xsl:param name="InternalResourceIdentifier"/>
    <xsl:param name="PublicResourceIdentifier"/>
    <xsl:param name="ResourceType"/>
    <xsl:param name="Modified"/>
    <xsl:param name="Number"/>    
    <xsl:param name="Extension"/>        
    <xsl:param name="URL"/>            
    <xsl:variable name="escid" select="cmc2-f:escape-asset-code($id)"/>
    <xsl:variable name="assetlanguage" select="if($Language = '') then 'global' else $Language"/>
    <xsl:variable name="extension" select="if($Extension != '') then $Extension else tokenize($InternalResourceIdentifier,'\.')[last()]"/>
    <xsl:variable name="url" select="if($URL != '') then $URL else if($extension = 'pdf')
                                     then $PublicResourceIdentifier
                                     else concat($imagepath,cmc2-f:escape-scene7-id($id),'-',$ResourceType,'-',$assetlanguage,'-001')"/>
    <Asset Type="{$ResourceType}" Description="{$description}"><xsl:value-of select="$url"/></Asset>
  </xsl:function>    
  <!--  -->
  <xsl:function name="cmc2-f:doVirtualAsset">
    <xsl:param name="id"/>
    <xsl:param name="Language"/>
    <xsl:param name="description"/>    
    <xsl:param name="number"/>
    <xsl:param name="InternalResourceIdentifier"/>
    <xsl:param name="PublicResourceIdentifier"/>
    <xsl:param name="ResourceType"/>
    <xsl:param name="Modified"/>
    <xsl:param name="url"/>
    <xsl:param name="extension"/>
    <xsl:variable name="escid" select="cmc2-f:escape-asset-code($id)"/>
    <Asset code="{$escid}" type="{$ResourceType}" locale="{$Language}" number="{$number}" description="{$description}" extension="{$extension}" lastModified="{$Modified}"><xsl:value-of select="$url"/></Asset>
  </xsl:function>    
  <!--  -->
  <xsl:function name="cmc2-f:doLegacyVirtualAsset">
    <xsl:param name="id"/>
    <xsl:param name="Language"/>
    <xsl:param name="description"/>    
    <xsl:param name="number"/>
    <xsl:param name="InternalResourceIdentifier"/>
    <xsl:param name="PublicResourceIdentifier"/>
    <xsl:param name="ResourceType"/>
    <xsl:param name="Modified"/>
    <xsl:param name="url"/>
    <xsl:param name="extension"/>
    <xsl:variable name="escid" select="cmc2-f:escape-asset-code($id)"/>
    <Asset Type="{$ResourceType}" Description="{$description}"><xsl:value-of select="$url"/></Asset>
  </xsl:function>
  
  <!--
     | Returns true if the specified asset type is exported to at least one of the specified channels.
     -->
  <xsl:function name="cmc2-f:isAssetExportedToChannel" as="xs:boolean">
    <xsl:param name="doc-types"/>
    <xsl:param name="asset-type"/>
    <xsl:param name="channels"/> <!-- channels may be a single string or a list of strings -->
    <xsl:value-of select="$doc-types/doctype[@code=$asset-type]/attribute::*[local-name()=$channels]='yes'"/>
  </xsl:function>

  <xsl:function name="cmc2-f:get-octl-sql">
    <xsl:param name="o"/>
    <xsl:param name="ct"/>
    <xsl:param name="l"/>
    <octl>
      <sql:execute-query>
        <sql:query>
          select o.active_flag
               , o.content_type
               , to_char(o.endofprocessing,'yyyy-mm-dd"t"hh24:mi:ss') endofprocessing
               , to_char(o.lastmodified_ts,'yyyy-mm-dd"t"hh24:mi:ss') lastmodified_ts
               , o.localisation
               , to_char(o.masterlastmodified_ts,'yyyy-mm-dd"t"hh24:mi:ss') masterlastmodified_ts
               , o.object_id
               , to_char(o.startofprocessing,'yyyy-mm-dd"t"hh24:mi:ss') startofprocessing
               , o.status
               , o.marketingversion
               , o.remark
               , o.data
          from octl o
          where o.content_type   = '<xsl:value-of select="$ct"/>'
            and o.localisation   = '<xsl:value-of select="$l"/>'
            and o.object_id      = '<xsl:value-of select="$o"/>'
            and o.status        != 'PLACEHOLDER'
        </sql:query>
      </sql:execute-query>
    </octl>
  </xsl:function>
  
  <xsl:function name="cmc2-f:escape-asset-code">
    <xsl:param name="id"/>
    <xsl:value-of select="replace($id,'/','_')"/>
  </xsl:function>

  <xsl:function name="cmc2-f:escape-scene7-id">
    <xsl:param name="id"/>
    <xsl:value-of select="replace($id,'[^0-9a-zA-Z_]+','_')"/>
  </xsl:function>
  
  <!--
     | adds SEOProductName element.
     | Format : PartnerBrandName + '-' + Concept/Family/Range name + '-' + DescriptorBrandedFeatureString
	   -->
  <xsl:function name="cmc2-f:deriveSEOProductName">
    <xsl:param name="naming-string"/>
    <xsl:variable name="CFS" select="if(string-length($naming-string/Concept/ConceptName) &gt; 0) then
                                       $naming-string/Concept/ConceptName/text()
                                     else if(string-length($naming-string/Family/FamilyName) &gt; 0) then
                                       $naming-string/Family/FamilyName/text()
                                     else if(string-length($naming-string/Range/RangeName) &gt; 0) then
                                       $naming-string/Range/RangeName/text()
                                     else ''"/>
	<xsl:variable name="seo_PartnerBrandName" select="if(string-length($naming-string/Partner[1]/PartnerBrand/BrandName) &gt; 0) then
											  $naming-string/Partner[1]/PartnerBrand/BrandName/text()
											else '' "/>
	<xsl:variable name="seo_DescriptorBrandedFeatureString" select="if(string-length($naming-string/DescriptorBrandedFeatureString) &gt; 0)	then 									
											  $naming-string/DescriptorBrandedFeatureString/text()
											else '' "/>
	<xsl:variable name="seo_PartnerBrandName_part" select="if($seo_PartnerBrandName != '') then 
										    concat($seo_PartnerBrandName,'-')
											else '' "/>
	<xsl:variable name="CFS_part" select="if($CFS != '') then 
										    concat($CFS,'-')
											else ''" />
	<xsl:variable name="seo_ProductName" select="concat($seo_PartnerBrandName_part,$CFS_part,$seo_DescriptorBrandedFeatureString)" />
	<xsl:value-of select="lower-case($seo_ProductName)"/>
  </xsl:function>

  <xsl:function name="cmc2-f:escape-sql" as="xs:string">
    <xsl:param name="p"/>
    <xsl:param name="escapeLike"/>
    
    <xsl:value-of select="replace(if ($escapeLike) then replace($p, '%|_', '\\$0') else $p, $apos, concat($apos,$apos))"/>
  </xsl:function>
  
  <!-- START Green2-functions -->
  <!--+
      |  Placement of EcoFlower and Green logos  is subject to specific requirements.
      |    1. One global or global_highlight Award logo from PFS
      |    2. EcoFlower logo (if present)
      |    3. Green logo (if present)
      |    4. BlueAngel logo (if present)
      |    5. Other global ot global_hightlight Award logos from PFS
      |  
      |  IN: Product (element)
      |  OUT: the award rank (string)
      +-->
  <xsl:function name="cmc2-f:getAwardRank">
    <xsl:param name="position"/>
    <xsl:value-of select="if ($position=1) then 1 else $position+3"/>
  </xsl:function>
  <!-- -->
  <xsl:function name="cmc2-f:doAward">
    <xsl:param name="awardNode"/>
    <xsl:param name="postion"/>
      <Award>
        <xsl:attribute name="AwardType"><xsl:value-of select="$awardNode/@AwardType"/></xsl:attribute>
        
        <!--  Newly Added check condition for Trend field -->
        <xsl:variable name="newTrend" select="if($awardNode/Trend = '') then () else $awardNode/Trend"/>
        
        <xsl:copy-of select="$awardNode/@*
                           | $awardNode/AwardCode
                           | $awardNode/AwardName
                           | $awardNode/AwardDate
                           | $awardNode/AwardPlace
                           | $awardNode/Title
                           | $awardNode/Issue
                           | $awardNode/Rating						   
                           | $newTrend
                           | $awardNode/AwardAuthor
                           | $awardNode/TestPros
                           | $awardNode/TestCons
                           | $awardNode/AwardDescription
                           | $awardNode/AwardAcknowledgement
                           | $awardNode/AwardVerdict
                           | $awardNode/AwardText
                           | $awardNode/Locales" />
        <AwardRank><xsl:value-of select="cmc2-f:getAwardRank($postion)"/></AwardRank>
        <xsl:copy-of select="$awardNode/AwardSourceCode
                           | $awardNode/AwardVideo
                           | $awardNode/AwardCategory
                           | $awardNode/AwardSourceLocale" />
      </Award>
  </xsl:function>
  
  <!--+
      | Add rank attribute to GreenChapters and order them.
      |
      | IN: GreenChapters
      | OUT: GreenChapters with rank attribute
      +-->
  <xsl:function name="cmc2-f:addGreenChapterRank">
    <xsl:param name="greenChapters" />
    <xsl:variable name="rankedGreenChapters">
      <xsl:for-each select="$greenChapters">
        <xsl:element name="{name()}">
          <xsl:attribute name="rank">
            <xsl:choose>
              <xsl:when test="GreenChapterName='Energy'">1</xsl:when>
              <xsl:when test="GreenChapterName='Weight'">2</xsl:when>
              <xsl:when test="GreenChapterName='Recycling'">3</xsl:when>
              <xsl:when test="GreenChapterName='Substances'">4</xsl:when>
              <xsl:when test="GreenChapterName='Packaging'">5</xsl:when>
              <xsl:when test="GreenChapterName='Reliability'">6</xsl:when>
              <xsl:otherwise>999</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:apply-templates select="@*|node()" />
        </xsl:element>
      </xsl:for-each>
    </xsl:variable>
    <xsl:for-each select="$rankedGreenChapters">
      <xsl:sort select="@rank" />
      <xsl:copy-of select="." />
    </xsl:for-each>
  </xsl:function>
  <!-- END Green2-functions -->
  
  <!-- Create a product display name -->
  <xsl:function name="cmc2-f:product-display-name">
    <xsl:param name="product" />

    <!-- Add Family or Concept name -->
    <xsl:choose>
      <xsl:when test="normalize-space($product/NamingString/Family/FamilyName) != '' and $product/NamingString/Family/FamilyNameUsed='1'">
        <xsl:value-of select="concat(normalize-space($product/NamingString/Family/FamilyName), ' ')" />
      </xsl:when>
      <xsl:when test="normalize-space($product/NamingString/Concept/ConceptName) != '' and $product/NamingString/Concept/ConceptNameUsed='1'">
        <xsl:value-of select="concat(normalize-space($product/NamingString/Concept/ConceptName), ' ')" />
      </xsl:when>
    </xsl:choose>

    <xsl:value-of select="if (string($product/ProductName) != '') then $product/ProductName else $product/NamingString/Descriptor/DescriptorName" />
  </xsl:function>
  
  <xsl:function name="cmc2-f:get-division-sql">
      <sql:execute-query>
        <sql:query>
          SELECT CO.DIVISION
               , CO.OBJECT_ID
               , O.LOCALISATION              
          FROM CATALOG_OBJECTS CO, OCTL O
          WHERE 
            CO.CUSTOMER_ID = 'CONSUMER_MARKETING'
            AND CO.OBJECT_ID = O.OBJECT_ID
            AND O.CONTENT_TYPE = 'PMA'
            AND CO.COUNTRY = substr(O.LOCALISATION,4,2)
            AND O.STATUS      != 'PLACEHOLDER'
        </sql:query>
      </sql:execute-query>
  </xsl:function>
  
</xsl:stylesheet>