<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:sql="http://apache.org/cocoon/SQL/2.0"
      xmlns:cinclude="http://apache.org/cocoon/include/1.0"
      xmlns:cmc2-f="http://www.philips.com/cmc2-f"
      xmlns:local="http://www.philips.com/local-func"
      exclude-result-prefixes="sql xsl cinclude"
      extension-element-prefixes="cmc2-f local">

  <xsl:param name="doctypes-file-path">../../../xml/doctype_attributes.xml</xsl:param>

  <xsl:import href="../../../../pipes/common/xsl/xucdm-product-external.xsl" />
  <xsl:include href="../../../xsl/common/cmc2.function.xsl" />

  <xsl:variable name="doctypes" select="document($doctypes-file-path)/doctypes" />
  <xsl:variable name="scene7-image-url-base" select="'http://images.philips.com/is/image/PhilipsConsumer/'" />
  <xsl:variable name="ccr-image-url-base" select="'http://pww.ccr.philips.com/cgi-bin/newmpr/get.pl?alt=1&amp;defaultimg=1&amp;'" /> <!--http://images.philips.com/is/image/PhilipsConsumer/42PFL9900D_10-TLP-global-001-->
  <xsl:variable name="derivation-precedence-list" select="('M','L','W','V','P','1')"/>
  
  <xsl:template match="@*|node()" mode="pass-through">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sql:*">
    <xsl:apply-templates select="sql:row|sql:data" />
  </xsl:template>

  <xsl:template match="sql:data">
    <xsl:apply-imports />
  </xsl:template>

  <!-- Overrides docatalogdata: handles missing catalog data -->
  <xsl:template name="docatalogdata">
    <xsl:param name="sop"/>
    <xsl:param name="eop"/>
    <xsl:param name="sos"/>
    <xsl:param name="eos"/>
    <xsl:param name="rank"/>
    <xsl:param name="deleted"/>
    <xsl:param name="deleteafterdate"/>
    <xsl:if test="$sop != ''">
      <Catalog>
        <StartOfPublication><xsl:value-of select="$sop"/></StartOfPublication>
        <EndOfPublication><xsl:value-of select="$eop"/></EndOfPublication>
        <StartOfSales><xsl:value-of select="$sos"/></StartOfSales>
        <EndOfSales><xsl:value-of select="$eos"/></EndOfSales>
        <DummyPrice><xsl:value-of select="'0.00'"/></DummyPrice>      
        <Deleted><xsl:value-of select="if($deleted = '1') then 'true' else 'false'"/></Deleted>
        <DeleteAfterDate><xsl:value-of select="$deleteafterdate"/></DeleteAfterDate>
        <ProductRank><xsl:value-of select="$rank"/></ProductRank>
      </Catalog>
    </xsl:if>
  </xsl:template>
  
  <!-- Overrides docategorization: handles missing categorization data -->
  <xsl:template name="docategorization">
    <xsl:param name="cats"/>
    <xsl:if test="$cats/sql:groupcode">
      <Categorization>
        <GroupCode><xsl:value-of select="$cats/sql:groupcode"/></GroupCode>
        <GroupName><xsl:value-of select="$cats/sql:groupname"/></GroupName>
        <CategoryCode><xsl:value-of select="$cats/sql:categorycode"/></CategoryCode>
        <CategoryName><xsl:value-of select="$cats/sql:categoryname"/></CategoryName>
        <SubcategoryCode><xsl:value-of select="$cats/sql:subcategorycode"/></SubcategoryCode>
        <SubcategoryName><xsl:value-of select="$cats/sql:subcategoryname"/></SubcategoryName>
      </Categorization>
    </xsl:if>
  </xsl:template>

  <!-- Overrides doAssets to include specific Asset types -->
  <xsl:template name="doAssets">
    <!-- This template overrides the template of the same name in xucdm-product-external -->
    <xsl:param name="id" />
    <xsl:param name="lastModified" />

    <xsl:variable name="number" select="'001'" />

    <Assets>
      <!-- Product assets -->
      <xsl:for-each
          select="AssetList/Asset[xs:boolean(cmc2-f:isAssetExportedToChannel($doctypes,ResourceType,('ATG','FSS')))]">
        <xsl:variable name="description" select="$doctypes/doctype[@code=current()/ResourceType]/@description" />
        <xsl:copy-of
          select="local:doAsset($id,Language,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,Publisher)" />
      </xsl:for-each>

      <!-- Virtual assets -->
      <xsl:copy-of
        select="cmc2-f:doVirtualAsset($id,'global','Single product shot','','','','IMS',substring($lastModified,1,10),concat($scene7-image-url-base,replace($id,'/','_'),'-IMS-global'),'')" />
      <xsl:copy-of
        select="cmc2-f:doVirtualAsset($id,'global','Product gallery image set','','','','GAL',substring($lastModified,1,10),concat($scene7-image-url-base,replace($id,'/','_'),'-GAL-global'),'')" />

      <!-- Object assets -->
      <xsl:for-each
          select="ObjectAssetList/Object/Asset[cmc2-f:isAssetExportedToChannel($doctypes, ResourceType, ('ATG','FSS'))]">
        <xsl:variable name="assetlanguage" select="if(Language = '') then 'global' else Language" />
        <xsl:variable name="escid" select="replace(../id,'/','_')" />
        <xsl:variable name="description" select="$doctypes/doctype[@code=current()/ResourceType]/@description" />
        <xsl:copy-of
          select="local:doAsset($escid,$assetlanguage,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,Publisher)" />
      </xsl:for-each>
    </Assets>
  </xsl:template>

  <xsl:function name="local:doAsset">
    <xsl:param name="asset-id"/>
    <xsl:param name="Language"/>
    <xsl:param name="description"/>    
    <xsl:param name="InternalResourceIdentifier"/>
    <xsl:param name="PublicResourceIdentifier"/>
    <xsl:param name="ResourceType"/>
    <xsl:param name="Modified"/>
    <xsl:param name="Number"/>    
    <xsl:param name="Publisher"/>                
    <xsl:variable name="escid" select="replace(replace($asset-id,'/','_'),'-','_')"/>
    <xsl:variable name="assetlanguage" select="if($Language = '') then 'global' else $Language"/>
    <xsl:variable name="extension" select="tokenize($InternalResourceIdentifier,'\.')[last()]"/>
    <xsl:variable name="url">
      <xsl:choose>
        <xsl:when test="$Publisher != 'CCR'">
          <xsl:value-of select="$PublicResourceIdentifier"/>
        </xsl:when>
        <!-- CCR assets -->
        <xsl:otherwise>
          <xsl:choose>
             <!-- For image assets send a derived smaller type -->
            <xsl:when test="matches($extension,'jpg|tif|eps|gif|png')">
              <xsl:variable name="master-type" select="$doctypes/doctype[@code=$ResourceType]/@master"/>
              <xsl:variable name="asset-type" select="local:find-derivation(if(empty($master-type)) then $ResourceType else $master-type, $derivation-precedence-list)"/>
              <xsl:value-of select="concat($ccr-image-url-base,'id=',$asset-id,'&amp;doctype=',$asset-type)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$InternalResourceIdentifier"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <Asset code="{$escid}" type="{$ResourceType}" locale="{$assetlanguage}" number="{$Number}" description="{$description}" extension="{$extension}" lastModified="{substring($Modified,1,10)}"><xsl:value-of select="$url"/></Asset>
  </xsl:function>

  <!--
     | Return the first derived asset type from the specified master whose last type character
     | matches the specified list of characters, using the doctype-attributes.xml file.
     | Example:
     |  find-derivation('CIM',('W','S','B','F')) will return 'CIS' because a CIW derivation does not exist for CIM.
     -->  
  <xsl:function name="local:find-derivation">
    <xsl:param name="master-type"/>
    <xsl:param name="search-sub-types"/>
    <xsl:variable name="derivations" select="$doctypes/doctype[@master=$master-type]"/>
    <xsl:value-of select="(for $t in $search-sub-types return $derivations[substring(@code,3)=$t]/@code)[1]"/>
  </xsl:function>
</xsl:stylesheet>
