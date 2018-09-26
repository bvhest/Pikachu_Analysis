<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:pms-f="http://www.philips.com/pika/pms/1.0"
                exclude-result-prefixes="sql">
  
  <xsl:import href="pms.functions.xsl"/>
  <xsl:include href="pmsBase.xsl"/>
    
  <xsl:param name="ccr-catalogmanager-url" />

  <xsl:variable name="config" select="document('../xml/config.xml')/config/catalogs"/>
  
  <xsl:template match="sql:rowset" />

  <xsl:template match="Countries[sql:rowset/sql:row]">
    <xsl:copy copy-namespaces="no">
      <xsl:for-each-group select="sql:rowset[@name='catalogs']/sql:row" group-by="sql:country">
        <Country countryID="{current-grouping-key()}">
          <Catalogs>
            <xsl:for-each-group select="current-group()" group-by="sql:catalogcode">
              <xsl:sort select="sql:catalogcode"/>
              <xsl:apply-templates select="current-group()[1]" mode="catalogs"/>
            </xsl:for-each-group>
          </Catalogs>
          <Locales>
            <xsl:for-each-group select="current-group()" group-by="sql:locale">
              <xsl:sort select="sql:locale"/>
              <xsl:apply-templates select="current-group()[1]" mode="locales"/>
            </xsl:for-each-group>
          </Locales>
        </Country>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="EvaluationData/Catalogs">
    <xsl:copy copy-namespaces="no">
      <xsl:for-each-group select="../../Countries/sql:rowset[@name='country-catalogs']/sql:row" group-adjacent="sql:country">
        <Catalog>
          <xsl:attribute name="country" select="current-group()[1]/sql:country" />
          <xsl:attribute name="sop" select="current-group()[1]/sql:startofpublication" />
          <xsl:attribute name="eop" select="current-group()[1]/sql:endofpublication" />
          <xsl:for-each select="current-group()/sql:locale">
            <Locale id="{text()}" name="{../sql:localename}"/>
          </xsl:for-each>
        </Catalog>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="sql:row" mode="catalogs">
    <xsl:variable name="ext" select="$config/catalog[@catalogCode=current()/sql:catalogcode]/@publicId"/>
    <xsl:if test="$ext != ''">
      <Catalog>
        <xsl:attribute name="columnID" select="concat(sql:country,'.',$ext) " />
        <CatalogDetails>
          <CatalogName>
            <xsl:value-of select="concat(upper-case(substring(sql:catalogcode, 1, 1)),lower-case(substring(sql:catalogcode, 2)))" />
          </CatalogName>
          <Live>
            <!-- Must be calculated on the fly -->
            <!-- xsl:value-of select="sql:live" /-->
          </Live>
          <StartOfPublication>
            <xsl:value-of select="sql:startofpublication" />
          </StartOfPublication>
          <EndOfPublication>
            <xsl:value-of select="sql:endofpublication" />
          </EndOfPublication>
          <CatalogManagerURL>
            <xsl:value-of select="pms-f:build-catalogmanager-url($ccr-catalogmanager-url, sql:catalogcode, sql:locale, ancestor::entry/@o)"/>
          </CatalogManagerURL>
          <Deleted>
            <xsl:value-of select="sql:deleted" />
          </Deleted>
        </CatalogDetails>
      </Catalog>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="sql:row" mode="locales">
    <Locale>
      <xsl:attribute name="LocaleID" select="sql:locale"/>
      <LastTranslation/>
      
      <xsl:variable name="leafletUrl" select="ancestor::Product/EvaluationData/Assets/Asset[@ResourceType='PSS'][@Language=current()/sql:locale]/@Url"/>
      <xsl:if test="$leafletUrl != ''">
        <LeafletURL>
          <xsl:value-of select="$leafletUrl"/>
        </LeafletURL>
      </xsl:if>
      
      <PendingTranslations/>
    </Locale>
  </xsl:template>
    
</xsl:stylesheet>
