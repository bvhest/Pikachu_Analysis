<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  exclude-result-prefixes="sql">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="sql:rowset" />

  <xsl:template match="Countries[sql:rowset/sql:row]">
    <xsl:copy copy-namespaces="no">

      <xsl:for-each-group select="sql:rowset/sql:row" group-by="sql:country">
        <xsl:element name="Country">
          <xsl:attribute name="CountryId" select="current-grouping-key()" />
          <Locales>
            <xsl:for-each select="current-group()">
              <xsl:variable name="locale" select="sql:locale" />
              <xsl:variable name="lm" select="sql:lastmodifiedsynchronized" />
              <Locale isLocalized="{sql:islocalized}" locale="{$locale}" _lm="{$lm}">
  
                <TranslationStatus>
                  <MarketingStatus>
                    <xsl:value-of select="sql:translationstatus" />
                  </MarketingStatus>
                  <MarketingVersion>
                    <xsl:value-of select="sql:marketingversiontranslated" />
                  </MarketingVersion>
                  <MasterLastModified>
                    <xsl:value-of select="sql:masterlastmodified" />
                  </MasterLastModified>
                  <LastModified>
                    <xsl:value-of select="sql:lastmodified" />
                  </LastModified>
                </TranslationStatus>
  
                <PublishStatus>
                  <MarketingStatus>
                    <xsl:value-of select="sql:statussynchronized" />
                  </MarketingStatus>
                  <MarketingVersion>
                    <xsl:value-of select="sql:marketingversionsynchronized" />
                  </MarketingVersion>
                  <MasterLastModified>
                    <xsl:value-of select="sql:masterlastmodifiedsynchronized" />
                  </MasterLastModified>
                  <LastModified>
                    <xsl:value-of select="sql:lastmodifiedsynchronized" />
                  </LastModified>
                </PublishStatus>
                <Links />
                <xsl:choose>
                  <xsl:when test="../../Locale[@locale=$locale][@_lm = $lm]">
                    <xsl:copy-of copy-namespaces="no" select="../../Locale[@locale=$locale]/CompletionStatus" />
                    <xsl:copy-of copy-namespaces="no" select="../../Locale[@locale=$locale]/AssetCounts" />
                  </xsl:when>
                  <xsl:otherwise>
                    <CompletionStatus needsProcessing="y" />
                    <AssetCounts needsProcessing="y" />
                  </xsl:otherwise>
                </xsl:choose>
              </Locale>
            </xsl:for-each>
          </Locales>
        </xsl:element>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
