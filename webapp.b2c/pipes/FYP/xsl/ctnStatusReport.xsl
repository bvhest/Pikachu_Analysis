<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2"
	extension-element-prefixes="asset-f" exclude-result-prefixes="sql xsl cinclude">

	<xsl:import href="../../common/xsl/xUCDM-external-assets.xsl" />

	<xsl:output method="text" version="1.0" encoding="UTF-8"
		indent="yes" />
	<xsl:template match="/">
		<xsl:text>id,ctn,country,division,locale,catalog,masterproductlastmodified,localizedproductlastmodified,translationstatus,exportedtocq,weburl,publicationstart,publicationend</xsl:text>
		<xsl:text>&#x0A;</xsl:text>
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="sql:rowset/sql:row">
		<xsl:variable name="ctn" select="sql:ctn" />
		<xsl:variable name="cq-productId" select="translate($ctn,'/-. ','_')" />
		<xsl:variable name="id"
			select="concat($cq-productId,'_',sql:locale,'_',sql:catalog_type) " />
		<xsl:variable name="division" select="sql:division" />
		<xsl:variable name="country" select="substring(sql:locale, 4, 2)" />
		<xsl:variable name="locale" select="sql:locale" />
		<xsl:variable name="catalog_type" select="sql:catalog_type" />
		<xsl:variable name="translationstatus" select="sql:translationstatus" />
		<xsl:variable name="exportedtocq" select="sql:exportedtocq" />
		<xsl:variable name="masterproductlastmodified"
			select="substring(translate(sql:masterproductlastmodified,'- :.',''),1,14)" />
		<xsl:variable name="localizedproductlastmodified"
			select="substring(translate(sql:localizedproductlastmodified,'- :.',''),1,14)" />
		<xsl:variable name="publicationstart"
			select="substring(translate(sql:sop,'- :.',''),1,14)" />
		<xsl:variable name="publicationend"
			select="substring(translate(sql:eop,'- :.',''),1,14)" />
		<xsl:variable name="data" select="sql:data" />
		<!-- Web URL: SEO v2.5 (2010 june 21) NOTE: This URL structure cannot be 
			used for publication, therefore it may not be sent to external parties!!! 
			This is the internal URL path which we can freely modify without having to 
			worry about external systems. format: http://www.consumer.philips.com/c/catalog/catalog.jsp?country=<countrycode>& 
			language=<languagecode>&catalogType=<catalogType>&productid=<escapedCTN>_<countrycode>_<catalogType> 
			e.g. http://www.consumer.philips.com/c/catalog/catalog.jsp?country=GB& language=en&catalogType=CONSUMER&productid=56PFL9954H_12_GB_CONSUMER -->

		<xsl:variable name="domains"
			select="document('../../../cmc2/xml/countryDomains.xml')/domains" />
		<xsl:variable name="domain"
			select="$domains/domain[@exportToCQ='Y'][@country=substring($locale,4)]" />
		<xsl:variable name="finalDomain">
			<xsl:value-of select="if ($domain) then $domain else 'www.philips.com'" />
		</xsl:variable>

		<xsl:variable name="countryCode" select="substring-after($locale,'_')" />
		<xsl:variable name="oneLanguage" select="'0'" />
		<xsl:variable name="multipleLanguageCountryCode" select="document('../../common/xml/multipleLanguageCountryList.xml')"/> 
					<xsl:variable name="multipleLanguage" select="$multipleLanguageCountryCode/sql:rowset/sql:row[sql:country_code = $countryCode]/sql:country_code"/>
					<xsl:variable name="weburl">
			<xsl:choose>
				<xsl:when test="$exportedtocq = 'Y'">
					<xsl:text>http://</xsl:text>
					<xsl:value-of select="$finalDomain" />

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
						<xsl:variable name='default_locale' select ="'ru_UA'"/>
						<xsl:if test= "$default_locale != $locale">
							<xsl:text>/</xsl:text>
							<xsl:value-of select="substring-before($locale,'_')"/>
						</xsl:if>
					</xsl:if>
					<xsl:text>/c-p/</xsl:text>
					<xsl:value-of select="translate($ctn,'./','__')" />
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>

		</xsl:variable>

		<!-- create csv (well, pipe-sv) line -->
		<xsl:value-of
			select="string-join(($id
                                        ,$ctn
                                        ,$country
                                        ,$division
                                        ,$locale
                                        ,$catalog_type
                                        ,$masterproductlastmodified 
                                        ,$localizedproductlastmodified
                                        ,$translationstatus
                                        ,$exportedtocq
                                        ,$weburl
                                        ,$publicationstart
                                        ,$publicationend),'|')" />
		<xsl:text>&#x0A;</xsl:text>
	</xsl:template>

</xsl:stylesheet>
