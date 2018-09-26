<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:param name="dir"/>
	
	<!-- MDM Asset-->	
	<!--Product>
	  <CTN>170C6FS/00</CTN> 		 							OK
		<Asset>
		  <Audience>											ProductDivision or ConsumerSegment?
			  <Audience>Consumer</Audience> 
			  <Audience>Professional</Audience> 
		  </Audience>
		  <Creator>ProCoon</Creator> 								OK
		  <Created>2007-09-04T21:23:00</Created> 					??
		  <Modified>2007-09-04T21:23:00</Modified> 				OK  DB:Lastmodified 
		  <Description>Product picture front-top 2196x1795</Description>    ??
		  <Format>application/pdf</Format>    						?? hardcoded??
		  <Extent>100KB</Extent> 									?? hardcoded??
		  <ResourceIdentifier>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=170C6FS/00&doctype=FTP&alt=1</ResourceIdentifier> 		????????
		  <Language /> 											OK Locale
		  <Publisher>PikaChu</Publisher>  							OK
		  <License>Marketing Released</License>   					OK MarketingStatus
		  <AccessRights>Internal</AccessRights> 						??
		  <RightsHolder>Philips</RightsHolder> 						??Product Owner??
		  <ResourceType>FTL</ResourceType> 						??
		</Asset>
		<Asset/>
		<Asset/>
	</Product-->
	<!-- -->
	<xsl:template match="entries">
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source>
				<xsl:value-of select="concat($dir,'/',@ct,'/outbox/','xSPOT_Asset_020.',substring-before(@ct,'2'),'.',@ts,'.',@l,'.',@batchnumber,'.xml')"/> 
			</source:source>
			<source:fragment>
				<ProductsMsg version="2.0" docTimestamp="{entry[1]/octl-attributes/lastmodified_ts}" docSource="ProCoon">
					<xsl:apply-templates select="entry"/>
				</ProductsMsg>
			</source:fragment>
		</source:write>
	</xsl:template>
	<!-- -->
	<xsl:template match="entry[@valid='true']">
			<xsl:apply-templates select="content/Product"/>
	</xsl:template>
	<!-- -->
	<xsl:template match="Product[@asset='true' and CTN and Asset]">
		<Product>
      <ObjectType>CTV</ObjectType>
			<ObjectKey><xsl:value-of select="CTN"/></ObjectKey>
      <CTV_ID><xsl:value-of select="CTN"/></CTV_ID>
			<xsl:apply-templates select="Asset"/>
		</Product>
	</xsl:template>	
	<!-- -->
	<xsl:template match="Asset">
		<Asset>
			<xsl:copy-of select="ResourceType"/>
			<xsl:copy-of select="Language"/>
			<xsl:copy-of select="License"/>
			<xsl:copy-of select="AccessRights"/>
			<Modified><xsl:value-of select="substring(Modified,1,10)"/></Modified>
			<xsl:copy-of select="../Publisher"/>
			<xsl:copy-of select="InternalResourceIdentifier"/>
			<xsl:copy-of select="SecureResourceIdentifier"/>
			<xsl:copy-of select="PublicResourceIdentifier"/>
			<xsl:copy-of select="Creator"/>
			<xsl:copy-of select="Created"/>
			<xsl:copy-of select="Format"/>
			<xsl:copy-of select="Extent"/>
		</Asset>
	</xsl:template>	
	<!-- -->
	<xsl:template match="entry[@valid='false']|Product"/><!-- erase everything else -->
</xsl:stylesheet>