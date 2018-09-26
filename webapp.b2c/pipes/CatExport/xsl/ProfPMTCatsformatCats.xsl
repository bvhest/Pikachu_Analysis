<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:philips="http://www.philips.com/catalog/recat"
    xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2"
    xmlns:local="http://www.philips.com/functions/local"
    exclude-result-prefixes="asset-f local">
	<!--
    <philips:categories xmlns:philips="http://www.philips.com/catalog/recat"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  -->
	<xsl:include href="../../common/xsl/xUCDM-external-assets.xsl"/>
	<xsl:param name="channel"/>
	<xsl:param name="locale"/>
	<xsl:param name="exportdate"/>
	<xsl:variable name="ismaster" select="if($locale = 'MASTER') then 'true' else 'false'"/>
	<xsl:variable name="country" select="if($locale = 'MASTER') then 'GLOBAL' else substring($locale, 4, 2)"/>
	<xsl:variable name="image-url-base" select="'http://images.philips.com/is/image/PhilipsConsumer'"/>
	<!--
    LP_TYPE configuration.
    Groups are ordered by precendence.
  -->
	<xsl:variable name="lp-type-config">
      <!-- LP_PROF_ATG -->
      <group code="LUM01_GR" lp-type="Luminaires"/>
      <group code="EP01_GR" lp-type="Lamps"/>
      <group code="GE01_GR" lp-type="Gear"/>
      <group code="ECCONTRO_GR" lp-type="Controls"/>
      <!-- LP_OEM_ATG -->
      <group code="EM01FLUS_GR" lp-type="Lamps"/>
      <group code="EM01HIDS_GR" lp-type="Lamps"/>
      <group code="EM01LHAL_GR" lp-type="Lamps"/>
      <group code="EM01SSL_GR" lp-type="Lamps"/>
      <group code="GE01GLC_GR" lp-type="Controls"/>
      <!-- LP_SPL_ATG -->
      <group code="GX01DISI_GR" lp-type="Lamps"/>
      <group code="GX01ENT_GR" lp-type="Lamps"/>
      <group code="GX01SCIE_GR" lp-type="Lamps"/>
      <group code="GX01UVHR_GR" lp-type="Lamps"/>
      <group code="INSECTT_GR" lp-type="Lamps"/>
      <group code="MLMP_GR" lp-type="Lamps"/>      
	</xsl:variable>
	<xsl:variable name="lp-type-list-config" select="$lp-type-config/group/@code"/>
	<xsl:variable name="lp-type-family-default" select="'Lamps'"/>
    <xsl:variable name="lp-type-default" select="'Mixed'"/>
	<xsl:template match="/root">
		<xsl:variable name="docDate" select="concat(substring($exportdate,1,4),'-',substring($exportdate,5,2),'-', substring($exportdate,7,2),'T',substring($exportdate,10,2),':',substring($exportdate,12,2),':00' ) "/>
		<philips:categories xmlns:philips="http://www.philips.com/catalog/recat" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" DocTimeStamp="{$docDate}">
			<xsl:apply-templates select="sql:rowset"/>
		</philips:categories>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:rowset">
		<!-- CATALOG -->
		<xsl:for-each-group select="sql:row" group-by="sql:catalogcode">
			<xsl:variable name="catalogType" select="current-grouping-key()"/>
			<!-- GROUP -->
			<xsl:for-each-group select="current-group()" group-by="sql:groupcode">
                <xsl:variable name="lp-type" select="local:get-lp-type(current-grouping-key(), $lp-type-default)"/>
				<philips:category>
					<philips:id>
						<xsl:value-of select="concat(current-grouping-key(),'_',substring($locale,4,2),'_',$catalogType) "/>
					</philips:id>
					<philips:locale>
						<xsl:value-of select="$locale"/>
					</philips:locale>
					<philips:catalogType>
						<xsl:value-of select="$catalogType"/>
					</philips:catalogType>
					<philips:merchandizerDisplayName romanize="true" locale="{$locale}">
						<xsl:value-of select="sql:m_groupname"/>
					</philips:merchandizerDisplayName>
					<philips:displayName>
						<xsl:value-of select="sql:groupname"/>
					</philips:displayName>
					<philips:isRoot>Y</philips:isRoot>
          <xsl:choose>
            <xsl:when test="$locale='MASTER'">
              <philips:seoName>
                <xsl:choose>
                  <xsl:when test="sql:groupseoname != ''"><xsl:value-of select="lower-case(translate(sql:groupseoname,'.','-'))" /></xsl:when>
                  <xsl:otherwise><xsl:value-of select="lower-case(translate(sql:groupname,'.','-'))" /></xsl:otherwise>
                </xsl:choose>                
              </philips:seoName>
            </xsl:when>
            <xsl:otherwise>
              <philips:seoName romanize="true" locale="{$locale}">
                <xsl:choose>
                  <xsl:when test="sql:groupseoname != ''"><xsl:value-of select="lower-case(translate(if (sql:islatin='1') then sql:groupseoname else sql:m_groupseoname,'.','-'))" /></xsl:when>
                  <xsl:otherwise><xsl:value-of select="lower-case(translate(if (sql:islatin='1') then sql:groupname else sql:m_groupname,'.','-'))" /></xsl:otherwise>
                </xsl:choose>
              </philips:seoName>
            </xsl:otherwise>
          </xsl:choose>
					<philips:categoryType>regularCategory</philips:categoryType>
					<philips:templateType>groupPageTemplate</philips:templateType>
					<philips:sequenceNumber>
						<xsl:value-of select="sql:grouprank"/>
					</philips:sequenceNumber>
					<philips:parentCategory/>
                    <philips:lpType>
                      <xsl:value-of select="$lp-type"/>
                    </philips:lpType>
					<philips:image>
						<xsl:value-of select="asset-f:buildScene7Url($image-url-base, current-grouping-key(), 'CLP', '', '001')"/>
					</philips:image>
				</philips:category>
			</xsl:for-each-group>
			<!--  CATEGORY-->
			<xsl:for-each-group select="current-group()" group-by="concat(sql:categorycode,sql:groupcode)">
                <xsl:variable name="lp-type" select="local:get-lp-type(current-group()[1]/sql:groupcode, $lp-type-default)"/>
				<philips:category>
					<philips:id>
						<xsl:value-of select="concat(sql:categorycode,'_',substring($locale,4,2),'_',$catalogType) "/>
					</philips:id>
					<philips:locale>
						<xsl:value-of select="$locale"/>
					</philips:locale>
					<philips:catalogType>
						<xsl:value-of select="$catalogType"/>
					</philips:catalogType>
					<philips:merchandizerDisplayName romanize="true" locale="{$locale}">
						<xsl:value-of select="sql:m_categoryname"/>
					</philips:merchandizerDisplayName>
					<philips:displayName>
						<xsl:value-of select="sql:categoryname"/>
					</philips:displayName>
					<philips:isRoot>N</philips:isRoot>
          <xsl:choose>
            <xsl:when test="$locale='MASTER'">
              <philips:seoName>
                <xsl:choose>
                  <xsl:when test="sql:categoryseoname != ''"><xsl:value-of select="lower-case(translate(sql:categoryseoname,'.','-'))" /></xsl:when>
                  <xsl:otherwise><xsl:value-of select="lower-case(translate(sql:categoryname,'.','-'))" /></xsl:otherwise>
                </xsl:choose>
              </philips:seoName>
            </xsl:when>
            <xsl:otherwise>
              <philips:seoName romanize="true" locale="{$locale}">
                <xsl:choose>
                  <xsl:when test="sql:categoryseoname != ''"><xsl:value-of select="lower-case(translate(if (sql:islatin='1') then sql:categoryseoname else sql:m_categoryseoname,'.','-'))" /></xsl:when>
                  <xsl:otherwise><xsl:value-of select="lower-case(translate(if (sql:islatin='1') then sql:categoryname else sql:m_categoryname,'.','-'))" /></xsl:otherwise>
                </xsl:choose>
              </philips:seoName>
            </xsl:otherwise>
          </xsl:choose>
					<philips:categoryType>regularCategory</philips:categoryType>
					<philips:templateType>categoryPageTemplate</philips:templateType>
					<philips:sequenceNumber>
						<xsl:value-of select="sql:categoryrank"/>
					</philips:sequenceNumber>
					<philips:parentCategory>
						<xsl:value-of select="concat(sql:groupcode,'_',$country,'_',$catalogType) "/>
					</philips:parentCategory>
                    <philips:lpType>
                      <xsl:value-of select="$lp-type"/>
                    </philips:lpType>
					<philips:image>
						<xsl:value-of select="asset-f:buildScene7Url($image-url-base, sql:categorycode, 'CLP', '', '001')"/>
					</philips:image>
				</philips:category>
			</xsl:for-each-group>
			<!-- SUBCATEGORY1 -->
			<xsl:for-each-group select="current-group()[sql:l3code != '']" group-by="concat(sql:l3code,sql:categorycode)">
                <xsl:variable name="lp-type" select="local:get-lp-type(current-group()[1]/sql:groupcode, $lp-type-default)"/>
				<philips:category>
					<philips:id>
						<xsl:value-of select="concat(sql:l3code,'_',substring($locale,4,2),'_',$catalogType) "/>
					</philips:id>
					<philips:locale>
						<xsl:value-of select="$locale"/>
					</philips:locale>
					<philips:catalogType>
						<xsl:value-of select="$catalogType"/>
					</philips:catalogType>
					<philips:merchandizerDisplayName romanize="true" locale="{$locale}">
						<xsl:value-of select="sql:m_l3name"/>
					</philips:merchandizerDisplayName>
					<philips:displayName>
						<xsl:value-of select="sql:l3name"/>
					</philips:displayName>
					<philips:isRoot>N</philips:isRoot>
					<xsl:choose>
						<xsl:when test="$locale='MASTER'"><philips:seoName><xsl:value-of select="sql:l3name"/></philips:seoName></xsl:when>
						<xsl:otherwise>	
							<philips:seoName romanize="true" locale="{$locale}">
									<xsl:value-of select="if (sql:islatin='1') then sql:l3name else sql:m_l3name"/>
							</philips:seoName>
						</xsl:otherwise>
					</xsl:choose>
					<philips:categoryType>regularCategory</philips:categoryType>
					<philips:templateType>subCategoryPageTemplate</philips:templateType>
					<philips:sequenceNumber>
						<xsl:value-of select="sql:l3rank"/>
					</philips:sequenceNumber>
					<philips:parentCategory>
						<xsl:value-of select="concat(sql:categorycode,'_',$country,'_',$catalogType) "/>
					</philips:parentCategory>
                    <philips:lpType>
                      <xsl:value-of select="$lp-type"/>
                    </philips:lpType>
					<philips:image>
						<xsl:value-of select="asset-f:buildScene7Url($image-url-base, sql:l3code, 'CLP', '', '001')"/>
					</philips:image>
				</philips:category>
			</xsl:for-each-group>

			<!-- SUBCATEGORY2 -->
			<xsl:for-each-group select="current-group()[sql:l4code != '']" group-by="concat(sql:l4code,sql:l3code)">
				<xsl:variable name="lp-type" select="local:get-lp-type(current-group()[1]/sql:groupcode, $lp-type-default)"/>
				<philips:category>
					<philips:id>
						<xsl:value-of select="concat(sql:l4code,'_',substring($locale,4,2),'_',$catalogType) "/>
					</philips:id>
					<philips:locale>
						<xsl:value-of select="$locale"/>
					</philips:locale>
					<philips:catalogType>
						<xsl:value-of select="$catalogType"/>
					</philips:catalogType>
					<philips:merchandizerDisplayName romanize="true" locale="{$locale}">
						<xsl:value-of select="sql:m_l4name"/>
					</philips:merchandizerDisplayName>
					<philips:displayName>
						<xsl:value-of select="sql:l4name"/>
					</philips:displayName>
					<philips:isRoot>N</philips:isRoot>
					<xsl:choose>
						<xsl:when test="$locale='MASTER'"><philips:seoName><xsl:value-of select="sql:l4name"/></philips:seoName></xsl:when>
						<xsl:otherwise>	
							<philips:seoName romanize="true" locale="{$locale}">
								<xsl:value-of select="if (sql:islatin='1') then sql:l4name else sql:m_l4name"/>
							</philips:seoName>
						</xsl:otherwise>
					</xsl:choose>
					<philips:categoryType>regularCategory</philips:categoryType>
					<philips:templateType>subCategoryPageTemplate</philips:templateType>
					<philips:sequenceNumber>
						<xsl:value-of select="sql:l4rank"/>
					</philips:sequenceNumber>
					<philips:parentCategory>
						<xsl:value-of select="concat(sql:l3code,'_',$country,'_',$catalogType) "/>
					</philips:parentCategory>
                    <philips:lpType>
                      <xsl:value-of select="$lp-type"/>
                    </philips:lpType>
					<philips:image>
						<xsl:value-of select="asset-f:buildScene7Url($image-url-base, sql:l4code, 'CLP', '', '001')"/>
					</philips:image>
				</philips:category>
			</xsl:for-each-group>			
	
			<!-- FAMILY -->
			<xsl:for-each-group select="current-group()" group-by="sql:subcategorycode">
				<xsl:for-each select="current-group()">
                    <xsl:variable name="lp-type" select="local:get-fam-lp-type(sql:subcategorycode, $lp-type-family-default, /root)"/>
					<philips:category>
						<philips:id>
							<xsl:value-of select="concat(current-grouping-key(),'_',substring($locale,4,2),'_',$catalogType) "/>
						</philips:id>
						<philips:locale>
							<xsl:value-of select="$locale"/>
						</philips:locale>
						<philips:catalogType>
							<xsl:value-of select="$catalogType"/>
						</philips:catalogType>
						<philips:merchandizerDisplayName romanize="true" locale="{$locale}">
							<xsl:value-of select="sql:m_subcategoryname"/>
						</philips:merchandizerDisplayName>
						<philips:displayName>
							<xsl:value-of select="sql:subcategoryname"/>
						</philips:displayName>
						<philips:isRoot>N</philips:isRoot>
            <xsl:choose>
              <xsl:when test="$locale='MASTER'">
                <philips:seoName>
                <xsl:choose>
                  <xsl:when test="sql:subcategoryseoname != ''"><xsl:value-of select="lower-case(translate(sql:subcategoryseoname,'.','-'))" /></xsl:when>
                  <xsl:otherwise><xsl:value-of select="lower-case(translate(sql:subcategoryname,'.','-'))" /></xsl:otherwise>
                </xsl:choose>
                </philips:seoName>
              </xsl:when>
              <xsl:otherwise>
                <philips:seoName romanize="true" locale="{$locale}">
                <xsl:choose>
                  <xsl:when test="sql:subcategoryseoname != ''"><xsl:value-of select="lower-case(translate(if (sql:islatin='1') then sql:subcategoryseoname else sql:m_subcategoryseoname,'.','-'))" /></xsl:when>
                  <xsl:otherwise><xsl:value-of select="lower-case(translate(if (sql:islatin='1') then sql:subcategoryname else sql:m_subcategoryname,'.','-'))" /></xsl:otherwise>
                </xsl:choose>
                </philips:seoName>
              </xsl:otherwise>
            </xsl:choose>
						<philips:categoryType>regularCategory</philips:categoryType>
						<philips:templateType>familyPageTemplate</philips:templateType>
						<philips:sequenceNumber>
							<xsl:value-of select="sql:subcategoryrank"/>
						</philips:sequenceNumber>
						<xsl:variable name="parent-code" select="if (sql:l4code = '') then if (sql:l3code = '') then sql:categorycode else sql:l3code else sql:l4code "/>
						<philips:parentCategory>
							<xsl:value-of select="concat($parent-code,'_',$country,'_',$catalogType) "/>
						</philips:parentCategory>
						<philips:lpType>
							<xsl:value-of select="$lp-type"/>
						</philips:lpType>
					</philips:category>
				</xsl:for-each>
			</xsl:for-each-group>
			<!-- -->
		</xsl:for-each-group>
    </xsl:template>
  
    <xsl:function name="local:get-lp-type">
      <xsl:param name="group-code"/>
      <xsl:param name="default-type"/>
      <xsl:variable name="lp-type-group" select="($lp-type-config/group[@code=$group-code])[1]"/>
      <xsl:value-of select="if (exists($lp-type-group)) then $lp-type-group/@lp-type else $default-type"/>
    </xsl:function>
	<!-- -->
    <xsl:function name="local:get-fam-lp-type">
      <xsl:param name="fam-code"/>
      <xsl:param name="default-type"/>
	  <xsl:param name="root"/>
      <xsl:variable name="group-code" select="$root/sql:rowset/sql:row[sql:subcategorycode=$fam-code][sql:groupcode=$lp-type-list-config]/sql:groupcode"/>
      <xsl:variable name="lp-type-group" select="($lp-type-config/group[@code=$group-code])[1]"/>
      <xsl:value-of select="if (exists($lp-type-group)) then $lp-type-group/@lp-type else $default-type"/>
    </xsl:function>
</xsl:stylesheet>
