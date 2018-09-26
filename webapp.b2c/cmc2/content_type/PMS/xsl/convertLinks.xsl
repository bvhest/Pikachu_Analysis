<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                exclude-result-prefixes="sql"
                >
	<!--  -->
	<xsl:param name="domainsfilepath"/>
    <xsl:variable name="countryDomains" select="document($domainsfilepath)/domains" />
	<xsl:variable name="GAL-List" select="('PWS','RTS','TLS','TRS','UWS','_FS','FTS','RCS','DPS','D1S','D2S','D3S','D4S','D5S','PA4','TS2','AP2','MI2','UPS','U1S','U2S')" as="xs:string*"/>
	
	<!--  -->
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
	<!-- -->
	<xsl:template match="ThumbnailURL">
	<xsl:copy copy-namespaces="no">
			<xsl:choose>
		  <xsl:when test="../EvaluationData/Assets/Asset[ResourceType='TLP']/InternalResourceIdentifier">
				<xsl:value-of select="../EvaluationData/Assets/Asset[ResourceType='TLP']/InternalResourceIdentifier"/>
		  </xsl:when>
		  <xsl:otherwise>
				<xsl:variable name="gal-assets" select="for $gal in $GAL-List return ../EvaluationData/Assets/Asset[ResourceType=$gal]"/>
				<xsl:value-of select="$gal-assets[1]/InternalResourceIdentifier"/>
		  </xsl:otherwise>
		</xsl:choose>
	</xsl:copy>
	</xsl:template>
	
	<xsl:template match="PreviewURL">
	
	  <xsl:variable name="ctn" select="../MasterData/CTN"/>
	<xsl:copy copy-namespaces="no">
		<xsl:value-of select="concat('http://pww.pikachu.philips.com:8888/cmc2/webservice/soap/icp/PMT_Master/master_global/',$ctn)"/>
	</xsl:copy>
	</xsl:template>
	<!-- -->
	<xsl:template match="MasterLinks">
	  <xsl:variable name="ctn" select="../MasterData/CTN"/>
	  <xsl:copy copy-namespaces="no">
		
		<xsl:choose>
		  <xsl:when test="../EvaluationData/Assets/Asset[ResourceType='TLP']/InternalResourceIdentifier">
			<Link type="productImage">
				<xsl:value-of select="../EvaluationData/Assets/Asset[ResourceType='TLP']/InternalResourceIdentifier"/>
			</Link>
		  </xsl:when>
		  <xsl:otherwise>
		    <Link type="productImage">
				<xsl:variable name="gal-assets" select="for $gal in $GAL-List return ../EvaluationData/Assets/Asset[ResourceType=$gal]"/>
				<xsl:value-of select="$gal-assets[1]/InternalResourceIdentifier"/>
			</Link>
		  </xsl:otherwise>
		</xsl:choose>

		<Link type="leaflet">
			<xsl:value-of select="../Assets/Asset[ResourceType='GLL']/InternalResourceIdentifier"/>
		</Link>
		<Link type="findYourProducts">
			<xsl:value-of select="concat('http://pww.findyourproduct.philips.com/ccrprd/f?p=402:7:::NO::P0_CTN:',$ctn)"/>
		</Link>
		<Link type="preview">
	   	      <xsl:value-of select="concat('http://pww.pikachu.philips.com:8888/cmc2/webservice/soap/icp/PMT_Master/master_global/',$ctn)"/>
		</Link>
	  </xsl:copy>
	</xsl:template>

	<!-- -->
  <xsl:function name="local:doMasterSEOProductName">
    <xsl:param name="MasterNS"/>

      <xsl:variable name="CFS" select="     if(string-length($MasterNS/Concept/ConceptName) &gt; 0) then $MasterNS/Concept/ConceptName
                                       else if(string-length($MasterNS/Family/FamilyName) &gt; 0)   then $MasterNS/Family/FamilyName
                                       else if(string-length($MasterNS/Range/RangeName) &gt; 0)     then $MasterNS/Range/RangeName
                                       else ''"/>
      <xsl:variable name="tmp" select="if($CFS = '') 
                                       then if(not(string-length($MasterNS/VersionString) &gt; 0))
                                            then ''
                                            else $MasterNS/VersionString 
                                       else if(not(string-length($MasterNS/VersionString) &gt; 0))
                                            then $CFS
                                            else concat($CFS,'-',$MasterNS/VersionString)"/>

      <xsl:value-of select="lower-case($tmp)"/>
  </xsl:function>
  
	<!-- -->
	<xsl:template match="Links">
		<xsl:variable name="ctn" select="../../../MasterData/CTN"/>

		<xsl:copy copy-namespaces="no">
			<xsl:variable name="locale" select="../@locale"/>
			<Link type="leaflet">
				<xsl:value-of select="../../../Assets/Asset[Language=$locale][ResourceType='PSS']/InternalResourceIdentifier"/>
			</Link>
			<xsl:variable name="equals">=</xsl:variable>
			<xsl:variable name="atgCTN" select="translate($ctn,'-/','__')"/>
			<xsl:variable name="lang" select="substring(../@locale,1,2) "/>
			<xsl:variable name="country" select="substring(../@locale,4,2) "/>
			<xsl:variable name="atgProductId" select="concat($atgCTN,'_',$country,'_CONSUMER') "/>

         <!-- the new part: build a Seo 2.5 URL -->
         <xsl:variable name="webcatSeoname">-</xsl:variable> <!-- the value for the webcat seo name is not important -->
         <xsl:variable name="countryDomain" select="$countryDomains/domain[@country=$country]/text()"/>
         <xsl:variable name="catalog_type" select="'CONSUMER'"/> <!-- the catalog type is unknown until the data is exported -->
         <xsl:variable name="catalogType" select="if ($catalog_type = 'CONSUMER') then '' else concat('/', $catalog_type)"/> 
         <!-- Format of the url for the external Product detail page. -->
         <!--xsl:variable name="weburl" select="concat('http://'
                                                   ,$countryDomain
                                                   ,'/c/'
                                                   ,$webcatSeoname
                                                   ,'/'
                                                   ,../../SEOProductName ????
                                                   ,'-'
                                                   ,$ctn
                                                   ,'/prd/'
                                                   ,$lang
                                                   ,$catalog_type
                                                   )
                                             "
         /-->
         <!-- For Empower.me: use the url for the internal Product detail page. -->
         <xsl:variable name="weburl" select="concat('http://www.consumer.philips.com/c/catalog/catalog.jsp?country='
                                                   ,$country
                                                   ,'&amp;language='
                                                   ,$lang
                                                   ,'&amp;catalogType='
                                                   ,$catalog_type
                                                   ,'&amp;productid='
                                                   ,replace($ctn,'/','_')
                                                   ,'_'
                                                   ,$country
                                                   ,'_'
                                                   ,$catalog_type
                                                   )"
         />
         
			<Link type="consumerSite">
				<!--xsl:value-of select="lower-case($weburl)"/-->
				<xsl:value-of select="$weburl"/>
			</Link>
			<Link type="preview">
				<xsl:value-of select="concat('http://pww.pikachu.philips.com:8888/cmc2/webservice/soap/icp/PMT/',$locale,'/',$ctn)"/>
			</Link>
		</xsl:copy>
	</xsl:template>
   <!-- -->   
</xsl:stylesheet>
