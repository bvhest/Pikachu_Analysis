<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
    xmlns:cmc2-f="http://www.philips.com/cmc2-f" 
    xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2"
    exclude-result-prefixes="sql xsl cinclude" 
    extension-element-prefixes="asset-f cmc2-f">
  
  <xsl:import href="../../common/xsl/searchStream-product-external.xsl"/>
  <xsl:import href="../../common/xsl/xUCDM-external-assets.xsl"/>
  
  <xsl:include href="../../../cmc2/xsl/common/cmc2.function.xsl"/>
  
  <xsl:param name="doctypesfilepath"/>
  <xsl:param name="secureURL"/>
  <xsl:param name="type"/>
  <xsl:param name="channel"/>
  <xsl:param name="asset-syndication"/>
  <xsl:param name="broker-level" select="''"/>
  <xsl:param name="system" select="'PikachuB2C'"/>
  
  <xsl:variable name="assetschannel">
    <xsl:choose>
      <xsl:when test="$channel = 'FSSProducts'">FSS</xsl:when>
      <xsl:when test="$channel = 'FoxIntProducts'">FSS</xsl:when>
      <xsl:when test="$channel = 'AtgProducts'">ATG</xsl:when>      
      <xsl:when test="$channel = 'AtgGifting'">ATG</xsl:when>      
      <xsl:when test="$channel = 'AtgPCTProducts'">ATG_PCT</xsl:when>      
      <xsl:when test="$asset-syndication != ''">
        <xsl:value-of select="$asset-syndication"/>
      </xsl:when>
      <xsl:when test="$broker-level != ''">
        <xsl:value-of select="concat('SyndicationL', $broker-level)"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$channel"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="doctypesfile" select="document($doctypesfilepath)"/>
  <xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>  <!--http://images.philips.com/is/image/PhilipsConsumer/42PFL9900D_10-TLP-global-001-->
  <xsl:variable name="nonimagepath" select="'http://www.p4c.philips.com/cgi-bin/dcbint/get?id='"/>
  <xsl:variable name="domains" select="document('../../../cmc2/xml/countryDomains.xml')/domains"/>
  
  <xsl:template match="RichText[@type = 'Functionality']"/>
  <xsl:template match="CSValueDescription"/>
    
  <xsl:template match="sql:id|sql:language|sql:sop|sql:eop|sql:sos|sql:eos|sql:priority|sql:content_type|sql:localisation|sql:catalogtype|sql:secureurlflag"/>
  
  <xsl:template match="sql:groupcode|sql:groupname|sql:categorycode|sql:categoryname|sql:subcategorycode|sql:subcategoryname"/>
  
  <xsl:template match="sql:rowset[@name='cat']"/>
  
  <xsl:template match="sql:pmt"/>
  
  <xsl:template match="sql:assetlist"/>
  
  <xsl:template match="sql:objectassetdata"/>
  
  <xsl:template match="sql:objectassetid"/>
  
  <xsl:template match="sql:productreference"/>
  
  <xsl:template match="sql:ctn"/>
  
   <xsl:template match="sql:product_type"/>
  
  <xsl:template match="sql:deleteafterdate|sql:deleted"/>
  
  <xsl:template name="doKeyValuePairs"/>
  
  <xsl:template name="doProductReference">
    <xsl:choose>
      <xsl:when test="$type = 'masterlocale'">
        <!-- use PMT -->
        <xsl:apply-templates select="../../sql:pmt/Product/ProductRefs"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="ProductRefs"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="doAssets">
    <!-- This template overrides the template of the same name in xucdm-product-external -->
    <xsl:param name="id"/>
    <xsl:param name="language"/>
    <xsl:param name="locale"/>
    <xsl:param name="lastModified"/>
    <xsl:param name="catalogtype"/>
    <xsl:variable name="number" select="'001'"/>
    <xsl:variable name="extension" select="''"/>
    <xsl:variable name="publisher" select="''"/>
    <xsl:variable name="secureURLflag" select="../../sql:secureurlflag"/>
    <Assets>
      <xsl:choose>
        <xsl:when test="$type = 'locale'">
          <!-- Product assets -->
          <xsl:for-each select="AssetList/Asset[ResourceType=$doctypesfile/doctypes/doctype[attribute::*[local-name()=$assetschannel]='yes']/@code]">
            <xsl:variable name="description" select="$doctypesfile/doctypes/doctype[@code=current()/ResourceType]/@description"/>
            <xsl:choose>
	            <xsl:when test="$secureURL ='yes' and $secureURLflag = 'yes'"> <!--   do we have to put an AND flag = yes here -->
		            <xsl:choose>
		            	<xsl:when test="ResourceType = $doctypesfile/doctypes/doctype[attribute::*[local-name()='secureURL']='yes']/@code">
		            		<xsl:copy-of select="cmc2-f:doAsset($id,Language,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,$extension,SecureResourceIdentifier,Publisher, $doctypesfile/doctypes)"/>	
		            	</xsl:when>
		            	<xsl:otherwise>
		            		<xsl:copy-of select="cmc2-f:doAsset($id,Language,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,$extension,'',Publisher, $doctypesfile/doctypes)"/>
		            	</xsl:otherwise>
		            </xsl:choose>	
	            </xsl:when>
	            <xsl:otherwise>
	            	<xsl:copy-of select="cmc2-f:doAsset($id,Language,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,$extension,'',Publisher, $doctypesfile/doctypes)"/>
	            </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
          <!-- Virtual assets -->
          <xsl:copy-of select="cmc2-f:doVirtualAsset($id,$locale,'Single product shot','','','','IMS',substring($lastModified,1,10),concat($imagepath,cmc2-f:escape-scene7-id($id),'-IMS-',$locale),$extension)"/>
          <xsl:copy-of select="cmc2-f:doVirtualAsset($id,$locale,'Product gallery image set','','','','GAL',substring($lastModified,1,10),concat($imagepath,cmc2-f:escape-scene7-id($id),'-GAL-',$locale),$extension)"/>
          <xsl:copy-of select="cmc2-f:doVirtualAsset($id,$locale,'Product URL','','','','URL',substring($lastModified,1,10),asset-f:buildProductDetailPageUrl(., $locale, $system, $catalogtype, $domains),$extension)"/>
          <!-- Object assets -->
          <xsl:for-each select="ObjectAssetList/Object/Asset[ResourceType=$doctypesfile/doctypes/doctype[attribute::*[local-name()=$assetschannel]='yes']/@code]">
            <xsl:variable name="assetlanguage" select="if(Language = '') then 'global' else Language"/>
            <xsl:variable name="description" select="$doctypesfile/doctypes/doctype[@code=current()/ResourceType]/@description"/>
            <xsl:choose>
	            <xsl:when test="$secureURL ='yes' and $secureURLflag = 'yes'"> <!--   do we have to put an AND flag = yes here -->
		            <xsl:choose>
		            	<xsl:when test="ResourceType = $doctypesfile/doctypes/doctype[attribute::*[local-name()='secureURL']='yes']/@code">
		            		<xsl:copy-of select="cmc2-f:doAsset(../id,$assetlanguage,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,$extension,SecureResourceIdentifier,$publisher, $doctypesfile/doctypes)"/>	
		            	</xsl:when>
		            	<xsl:otherwise>
		            		<xsl:copy-of select="cmc2-f:doAsset(../id,$assetlanguage,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,$extension,'',$publisher, $doctypesfile/doctypes)"/>
		            	</xsl:otherwise>
		            </xsl:choose>	
	            </xsl:when>
	            <xsl:otherwise>
	            	<xsl:copy-of select="cmc2-f:doAsset(../id,$assetlanguage,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,$extension,'',$publisher, $doctypesfile/doctypes)"/>
	            </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="$type = 'masterlocale'">
          <!-- Product assets -->
          <xsl:for-each select="../../sql:pmt/Product/AssetList/Asset[ResourceType=$doctypesfile/doctypes/doctype[attribute::*[local-name()=$assetschannel]='yes']/@code]">
            <xsl:variable name="description" select="$doctypesfile/doctypes/doctype[@code=current()/ResourceType]/@description"/>
            <xsl:choose>
	            <xsl:when test="$secureURL ='yes' and $secureURLflag = 'yes'"> <!--   do we have to put an AND flag = yes here -->
		            <xsl:choose>
		            	<xsl:when test="ResourceType = $doctypesfile/doctypes/doctype[attribute::*[local-name()='secureURL']='yes']/@code">            
            				<xsl:copy-of select="cmc2-f:doAsset($id,Language,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,$extension,SecureResourceIdentifier,Publisher, $doctypesfile/doctypes)"/>
		            	</xsl:when>
		            	<xsl:otherwise>
		            		<xsl:copy-of select="cmc2-f:doAsset($id,Language,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,$extension,'',Publisher, $doctypesfile/doctypes)"/>
		            	</xsl:otherwise>
		            </xsl:choose>	
	            </xsl:when>
	            <xsl:otherwise>
	            	<xsl:copy-of select="cmc2-f:doAsset($id,Language,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,$extension,'',Publisher, $doctypesfile/doctypes)"/>
	            </xsl:otherwise>
            </xsl:choose>            				
          </xsl:for-each>
          <!-- Virtual assets -->
          <xsl:copy-of select="cmc2-f:doVirtualAsset($id,$locale,'Single product shot','','','','IMS',substring($lastModified,1,10),concat($imagepath,cmc2-f:escape-scene7-id($id),'-IMS-',$locale),$extension)"/>
          <xsl:copy-of select="cmc2-f:doVirtualAsset($id,$locale,'Product gallery image set','','','','GAL',substring($lastModified,1,10),concat($imagepath,cmc2-f:escape-scene7-id($id),'-GAL-',$locale),$extension)"/>
          <!-- Object assets -->
          <xsl:for-each select="../../sql:pmt/Product/ObjectAssetList/Object/Asset[ResourceType=$doctypesfile/doctypes/doctype[attribute::*[local-name()=$assetschannel]='yes']/@code]">
            <xsl:variable name="assetlanguage" select="if(Language = '') then 'global' else Language"/>
            <xsl:variable name="description" select="$doctypesfile/doctypes/doctype[@code=current()/ResourceType]/@description"/>
            <xsl:choose>
	            <xsl:when test="$secureURL ='yes' and $secureURLflag = 'yes'"> <!--   do we have to put an AND flag = yes here -->
		            <xsl:choose>
		            	<xsl:when test="ResourceType = $doctypesfile/doctypes/doctype[attribute::*[local-name()='secureURL']='yes']/@code">            
            				<xsl:copy-of select="cmc2-f:doAsset(../id,$assetlanguage,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,substring(Modified,1,10),$number,$extension,SecureResourceIdentifier,$publisher, $doctypesfile/doctypes)"/>
            			</xsl:when>	
            			<xsl:otherwise>
            				<xsl:copy-of select="cmc2-f:doAsset(../id,$assetlanguage,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,substring(Modified,1,10),$number,$extension,'',$publisher, $doctypesfile/doctypes)"/>
            			</xsl:otherwise>
		            </xsl:choose>	
	            </xsl:when>
	            <xsl:otherwise>            			
            		<xsl:copy-of select="cmc2-f:doAsset(../id,$assetlanguage,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,substring(Modified,1,10),$number,$extension,'',$publisher, $doctypesfile/doctypes)"/>
            	</xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="$type = 'master'">
          <!-- Product assets -->
          <xsl:for-each select="AssetList/Asset[ResourceType=$doctypesfile/doctypes/doctype[attribute::*[local-name()=$assetschannel]='yes']/@code][Language='' or Language = 'en_US' or Language='global']">
            <xsl:variable name="description" select="$doctypesfile/doctypes/doctype[@code=current()/ResourceType]/@description"/>
            <xsl:choose>
	            <xsl:when test="$secureURL ='yes' and $secureURLflag = 'yes'"> <!--   do we have to put an AND flag = yes here -->
		            <xsl:choose>
		            	<xsl:when test="ResourceType = $doctypesfile/doctypes/doctype[attribute::*[local-name()='secureURL']='yes']/@code">            
            				<xsl:copy-of select="cmc2-f:doAsset($id,Language,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,'',SecureResourceIdentifier,Publisher, $doctypesfile/doctypes)"/>
            			</xsl:when>
            			<xsl:otherwise>	
            				<xsl:copy-of select="cmc2-f:doAsset($id,Language,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,'','',Publisher, $doctypesfile/doctypes)"/>
            			</xsl:otherwise>
            		</xsl:choose>
            	</xsl:when>
            	<xsl:otherwise>	
            		<xsl:copy-of select="cmc2-f:doAsset($id,Language,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,'','',Publisher, $doctypesfile/doctypes)"/>
           		</xsl:otherwise>
           	</xsl:choose> 
          </xsl:for-each>
          <!-- Virtual assets -->
          <xsl:copy-of select="cmc2-f:doVirtualAsset($id,'global','Single product shot','','','','IMS',substring($lastModified,1,10),concat($imagepath,cmc2-f:escape-scene7-id($id),'-IMS-global'),'')"/>
          <xsl:copy-of select="cmc2-f:doVirtualAsset($id,'global','Product gallery image set','','','','GAL',substring($lastModified,1,10),concat($imagepath,cmc2-f:escape-scene7-id($id),'-GAL-global'),'')"/>
          <!-- Object assets -->
          <xsl:for-each select="ObjectAssetList/Object/Asset[ResourceType=$doctypesfile/doctypes/doctype[attribute::*[local-name()=$assetschannel]='yes']/@code][Language='' or Language = 'en_US' or Language='global']">
            <xsl:variable name="assetlanguage" select="if(Language = '') then 'global' else Language"/>
            <xsl:variable name="description" select="$doctypesfile/doctypes/doctype[@code=current()/ResourceType]/@description"/>
            
            <xsl:choose>
	            <xsl:when test="$secureURL ='yes' and $secureURLflag = 'yes'"> <!--   do we have to put an AND flag = yes here -->
		            <xsl:choose>
		            	<xsl:when test="ResourceType = $doctypesfile/doctypes/doctype[attribute::*[local-name()='secureURL']='yes']/@code">            
            				<xsl:copy-of select="cmc2-f:doAsset(../id,$assetlanguage,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,substring(Modified,1,10),$number,$extension,SecureResourceIdentifier,$publisher, $doctypesfile/doctypes)"/>
            			</xsl:when>
            			<xsl:otherwise>
            				<xsl:copy-of select="cmc2-f:doAsset(../id,$assetlanguage,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,substring(Modified,1,10),$number,$extension,'',$publisher, $doctypesfile/doctypes)"/>
              			</xsl:otherwise>
            		</xsl:choose>
            	</xsl:when>
            	<xsl:otherwise>	          
            			<xsl:copy-of select="cmc2-f:doAsset(../id,$assetlanguage,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,substring(Modified,1,10),$number,$extension,'',$publisher, $doctypesfile/doctypes)"/>
            	</xsl:otherwise>
           	</xsl:choose>          
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
    </Assets>
  </xsl:template>
  
</xsl:stylesheet>