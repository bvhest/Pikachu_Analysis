<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:variable name="doctypesfile" select="document('../../../xml/doctype_attributes.xml')"/>
	<xsl:key name="ccr-doctypes" match="$doctypesfile/doctypes/doctype" use="@code"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="AssetList">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="Asset" mode="asset-caption">
        <xsl:with-param name="captions" select="../RichTexts/RichText[@type='AssetCaption']/Item"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ObjectAssetList/Object">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="id"/>
      <xsl:apply-templates select="Asset" mode="asset-object-caption"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="Asset" mode="asset-caption">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
      <xsl:variable name="dt" select="ResourceType"/>
      <xsl:variable name="master_dt">
      		<xsl:for-each select="$doctypesfile">
			   <xsl:value-of select="key('ccr-doctypes',$dt)/@master"/>             
			</xsl:for-each>
		</xsl:variable>
	   <xsl:variable name="rt" select="../../RichTexts/RichText[@type='AssetCaption']"/>
       <xsl:variable name="caption" select="$rt/Item[@docType=($dt,$master_dt) ] [1]"/> 
	   <!-- Help with the problem that the PDP is used as doctype for all details photo's -->
	   <xsl:variable name="caption2">
	    <xsl:choose>
			<xsl:when test="$caption">
				<xsl:copy-of select="$caption"/>
			</xsl:when>
			<xsl:when test="ResourceType=('D1_','D1P')">
				<xsl:copy-of select="$rt/Item[@docType='PDP'][2]"/>
			</xsl:when>
			<xsl:when test="ResourceType=('D2_','D2P')">
				<xsl:copy-of select="$rt/Item[@docType='PDP'][3]"/>
			</xsl:when>
			<xsl:when test="ResourceType=('D3_','D3P')">
				<xsl:copy-of select="$rt/Item[@docType='PDP'][4]"/>
			</xsl:when>
			<xsl:when test="ResourceType=('D4_','D4P')">
				<xsl:copy-of select="$rt/Item[@docType='PDP'][5]"/>
			</xsl:when>
			<xsl:when test="ResourceType=('D5_','D5P')">
				<xsl:copy-of select="$rt/Item[@docType='PDP'][6]"/>
			</xsl:when>
			<xsl:when test="ResourceType=('U1_','U1P')">
				<xsl:copy-of select="$rt/Item[@docType='PUP'][2]"/>
			</xsl:when>
			<xsl:when test="ResourceType=('U2_','U2P')">
				<xsl:copy-of select="$rt/Item[@docType='PUP'][3]"/>
			</xsl:when>
			<xsl:when test="ResourceType=('U3_','U3P')">
				<xsl:copy-of select="$rt/Item[@docType='PUP'][4]"/>
			</xsl:when>
			<xsl:when test="ResourceType=('U4_','U4P')">
				<xsl:copy-of select="$rt/Item[@docType='PUP'][5]"/>
			</xsl:when>
			<xsl:when test="ResourceType=('U5_','U5P')">
				<xsl:copy-of select="$rt/Item[@docType='PUP'][6]"/>
			</xsl:when>
			<xsl:when test="ResourceType=('A1_','A1P')">
				<xsl:copy-of select="$rt/Item[@docType='APS'][2]"/>
			</xsl:when>
			<xsl:when test="ResourceType=('A2_','A2P')">
				<xsl:copy-of select="$rt/Item[@docType='APS'][3]"/>
			</xsl:when>
			<xsl:when test="ResourceType=('A3_','A3P')">
				<xsl:copy-of select="$rt/Item[@docType='APS'][4]"/>
			</xsl:when>
			<xsl:when test="ResourceType=('A4_','A4P')">
				<xsl:copy-of select="$rt/Item[@docType='APS'][5]"/>
			</xsl:when>
			<xsl:when test="ResourceType=('A5_','A5P')">
				<xsl:copy-of select="$rt/Item[@docType='APS'][6]"/>
			</xsl:when>
	    </xsl:choose>
	   </xsl:variable>
	   
      <xsl:if test="$caption2">
        <Caption>
       <!--doctype><xsl:value-of select="$dt"/></doctype>
       <masterdt><xsl:value-of select="$master_dt"/></masterdt-->
          <xsl:value-of select="$caption2/Item/Head[1]"/>
        </Caption>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  
  
    <xsl:template match="@*|node()" mode="asset-object-caption">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"  mode="asset-object-caption"/>
    </xsl:copy>
  </xsl:template>
  
  <!--
    <xsl:template match="PublicResourceIdentifier[../ResourceType=('FFS','FBS')]" mode="asset-object-caption">
		<xsl:copy>
			  <xsl:value-of select="lower-case(concat('http://www.p4c.philips.com/lighting/',  ../../id, '.', ../Language, '.' , ../ResourceType,'.pdf' ))"/>
		</xsl:copy>
  </xsl:template>
-->
  
  <xsl:template match="Asset" mode="asset-object-caption">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="asset-object-caption"/>
      <xsl:param name="id" select="../id"/>
      <xsl:variable name="caption" select="../../../RichTexts/RichText/Item[@code=$id][1]"/> 
      <xsl:if test="$caption">
        <Caption>
          <xsl:value-of select="$caption/Head[1]"/>
        </Caption>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
