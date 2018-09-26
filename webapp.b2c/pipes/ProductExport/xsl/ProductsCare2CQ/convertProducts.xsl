<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
                xmlns:data="http://www.philips.com/cmc2-data"
                xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2"
                xmlns:local="http://www.philips.com/local"
                exclude-result-prefixes="sql xsl cinclude data" 
                extension-element-prefixes="asset-f local"
            >

  <!--  base the transformation on the default xUCDM transformation -->
  <xsl:import href="../xUCDM.1.3.convertProducts.xsl" />
  <xsl:import href="../../../common/xsl/xUCDM-external-assets.xsl"/>
  
  <!--  -->
  <xsl:param name="doctypesfilepath"/>
  <xsl:param name="type"/>
  <xsl:param name="channel"/>
  <xsl:variable name="doctypes" select="document('../../../../cmc2/xml/doctype_attributes.xml')/doctypes"/>
  
  <xsl:template match="sql:object_id|sql:doctype|sql:locale|sql:publicresourceidentifier|sql:lastmodified"/>
  
  
  <xsl:template match="Products">
    <Products>
      <xsl:attribute name="DocTimeStamp" select="substring(string(current-dateTime()),1,19)"/>
      <xsl:attribute name="DocStatus" select="'approved'"/>
      <xsl:attribute name="DocType" select="sql:rowset/sql:row[1]/sql:content_type"/>
      <xsl:attribute name="DocVersion"><xsl:text>xUCDM_product_external_CQ5_B2C_1_1_7</xsl:text></xsl:attribute> 
      <xsl:apply-templates select="node()"/>   
    </Products>
  </xsl:template>
  
  <xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>
  
  <xsl:template name="doAssets">
      
      <xsl:param name="id"/>
      <xsl:param name="lastModified"/>
      
      <xsl:variable name="options">
        <scene7-url-base><xsl:value-of select="$imagepath"/></scene7-url-base>
        <include-extent/>
      </xsl:variable>
      
     <Assets>
     
       <xsl:sequence select="asset-f:createCareAssetsAll(ancestor::sql:row/sql:rowset[@name='careAssetList']/sql:row,$options)"/>       
       <xsl:sequence select="asset-f:createCareAssetsAll(ancestor::sql:row/sql:rowset[@name='careSoftAssetList']/sql:row,$options)"/>
       
       
       <xsl:for-each select="ObjectAssetList/Object[exists(Asset)]">     
         <xsl:variable name="doctype" select="Asset/ResourceType"/>         
         <xsl:variable name="description" select="$doctypes/doctype[@code = $doctype]/@description"/>
         <xsl:variable name="modified" select="Asset/Modified"/>
           
	       <Asset code="{asset-f:escape-asset-code(id)}" type="{Asset/ResourceType}" locale="{if(Asset/Language = '') then 'global' else Asset/Language}"
				        number="{'001'}"
				        description="{$description}"
				        extension="{$doctypes/doctype[@code = $doctype]/@suffix}"
				        lastModified="{$modified}">
	          <xsl:value-of select="Asset/PublicResourceIdentifier"/>
	       </Asset>
       </xsl:for-each>
                     
     </Assets>
  
  </xsl:template>
  
  
  <xsl:template name="docatalogdata"/>
  <xsl:template name="docategorization"/>
    
  <xsl:template name="doKeyValuePairs">
    <xsl:choose>
      <xsl:when test="$type = 'locale'">
        <xsl:apply-templates select="ProductImage" />
        <xsl:apply-templates select="HasSoftwareAsset" />
      </xsl:when>
      <xsl:when test="$type = 'masterlocale'"> <!-- Not relevant -->
        <!-- use PMT/PCT -->
        <xsl:apply-templates select="../../sql:pmt/Product/ProductImage" />
        <xsl:apply-templates select="../../sql:pmt/Product/HasSoftwareAsset" />
      </xsl:when>
      <xsl:when test="$type = 'master'">
        <!-- use PMT_Master -->
        <xsl:apply-templates select="ProductImage" />
        <xsl:apply-templates select="HasSoftwareAsset" />
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="ProductImage">
    <KeyValuePair>
      <Key>ProductImage</Key>
      <Value><xsl:value-of select="."/></Value>
      <Type>String</Type>
    </KeyValuePair>
  </xsl:template>

  <xsl:template match="HasSoftwareAsset">
    <KeyValuePair>
      <Key>HasSoftwareAsset</Key>
      <Value><xsl:value-of select="if (.='Y') then 'true' else 'false'"/></Value>
      <Type>Boolean</Type>
    </KeyValuePair>
  </xsl:template>
    
    
    <xsl:function name="asset-f:createCareAssets">
      
      <xsl:param name="asset-id"/>    
      <xsl:param name="asset-raw"/>
      <xsl:param name="description"/>
      <xsl:param name="options"/>
      <xsl:param name="lastModified"/>
      
      <xsl:variable name="extension">
         <xsl:if test="$asset-raw">      
            <xsl:value-of select="asset-f:getAssetExtension($asset-raw)"/>
         </xsl:if>
      </xsl:variable>
    
    
	   <Asset code="{asset-f:escape-asset-code($asset-id)}" type="{$asset-raw/ResourceType}" locale="{if ($asset-raw/Language = '') then 'global' else $asset-raw/Language}"
	      number="{'001'}"
	      description="{$description}"
	      extension="{$extension}"
	      lastModified="{$lastModified}">
      <xsl:value-of select="asset-f:getAssetUrl($asset-id, $asset-raw, $asset-raw/ResourceType, $options)"/>
    </Asset>
    </xsl:function>
    
    <xsl:function name="asset-f:createCareAssetsAll">      
      <xsl:param name="asset-raw"/>
      <xsl:param name="options"/>
      
      
      <xsl:for-each select="$asset-raw">
      
          <xsl:variable name="id" select="replace(sql:object_id,'/','_')" />
          <xsl:variable name="doctype" select="sql:doctype"/>         
          <xsl:variable name="description" select="$doctypes/doctype[@code = $doctype]/@description"/>
		      
          <xsl:variable name="extension">
            <xsl:if test="sql:publicresourceidentifier">            
					    <xsl:analyze-string regex="\.(\w+?)$" select="sql:publicresourceidentifier">
					      <xsl:matching-substring>
					        <xsl:value-of select="regex-group(1)"/>
					      </xsl:matching-substring>
					    </xsl:analyze-string>
				    </xsl:if>
			    </xsl:variable>
		      
		      <Asset code="{$id}" type="{sql:doctype}" locale="{if (sql:locale = '') then 'global' else sql:locale}"
		             number="{'001'}"
		             description="{$description}"
		             extension="{$extension}"
		             lastModified="{sql:lastmodified}">
		             
		             <xsl:value-of select="sql:publicresourceidentifier" /> </Asset>
			             
      </xsl:for-each>
      
    </xsl:function>
  
</xsl:stylesheet>