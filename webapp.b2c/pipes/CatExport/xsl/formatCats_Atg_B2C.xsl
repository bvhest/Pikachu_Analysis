<?xml version="1.0"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:philips="http://www.philips.com/catalog/recat">
    
  <xsl:param name="channel" />
  <xsl:param name="locale" />
  <xsl:param name="exportdate" />
  
  <xsl:variable name="ismaster" select="if($locale = 'MASTER') then 'true' else 'false'" />
  <xsl:variable name="country" select="if($locale = 'MASTER') then 'GLOBAL' else substring($locale, 4, 2)" />

  <xsl:template match="/root">
    <xsl:variable name="docDate"
                  select="concat(substring($exportdate,1,4),'-',substring($exportdate,5,2),'-', substring($exportdate,7,2),'T',substring($exportdate,10,2),':',substring($exportdate,12,2),':00' ) " />
    <philips:categories xmlns:philips="http://www.philips.com/catalog/recat" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                        DocTimeStamp="{$docDate}">
      <xsl:apply-templates select="sql:rowset" />
    </philips:categories>
  </xsl:template>
  
  <xsl:template match="sql:rowset">
    <!-- CATALOG -->
    <xsl:for-each-group select="sql:row" group-by="sql:catalogcode">
      <xsl:variable name="catalogType" select="current-grouping-key()" />
      <!-- GROUP -->
      <xsl:for-each-group select="current-group()" group-by="sql:groupcode">
        <philips:category>
          <philips:id>
            <xsl:value-of select="concat(current-grouping-key(),'_',$country,'_',$catalogType) " />
          </philips:id>
          <philips:locale>
            <xsl:value-of select="$locale" />
          </philips:locale>
          <philips:catalogType>
            <xsl:value-of select="$catalogType" />
          </philips:catalogType>
          <philips:merchandizerDisplayName romanize="true" locale="{$locale}">
            <xsl:value-of select="sql:m_groupname" />
          </philips:merchandizerDisplayName>
          <philips:displayName>
            <xsl:value-of select="sql:groupname" />
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
          <philips:level>group</philips:level>
          <philips:sequenceNumber>
            <xsl:value-of select="sql:grouprank" />
          </philips:sequenceNumber>
          <philips:parentCategory />
        </philips:category>
      </xsl:for-each-group>
      <!-- CATEGORY -->
      <xsl:for-each-group select="current-group()" group-by="concat(sql:categorycode,sql:groupcode)">
        <philips:category>
          <philips:id>
            <xsl:value-of select="concat(sql:categorycode,'_',$country,'_',$catalogType) " />
          </philips:id>
          <philips:locale>
            <xsl:value-of select="$locale" />
          </philips:locale>
          <philips:catalogType>
            <xsl:value-of select="$catalogType" />
          </philips:catalogType>
          <philips:merchandizerDisplayName romanize="true" locale="{$locale}">
            <xsl:value-of select="sql:m_categoryname" />
          </philips:merchandizerDisplayName>
          <philips:displayName>
            <xsl:value-of select="sql:categoryname" />
          </philips:displayName>
          <philips:isRoot>N</philips:isRoot>
          <xsl:choose>
            <xsl:when test="$locale='MASTER'">
              <philips:seoName>
                <xsl:choose>
                  <xsl:when test="sql:categoryseoname != ''"><xsl:value-of select="lower-case(translate(sql:categoryseoname ,'.','-'))" /></xsl:when>
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
          <philips:level>cat</philips:level>
          <philips:sequenceNumber>
            <xsl:value-of select="sql:categoryrank" />
          </philips:sequenceNumber>
          <philips:parentCategory>
            <xsl:value-of select="concat(sql:groupcode,'_',$country,'_',$catalogType) " />
          </philips:parentCategory>
        </philips:category>
      </xsl:for-each-group>

      <!-- SUBCATEGORY -->
      <xsl:for-each-group select="current-group()" group-by="sql:subcategorycode">
        <xsl:for-each select="current-group()">
          <philips:category>
            <philips:id>
              <xsl:value-of select="concat(current-grouping-key(),'_',$country,'_',$catalogType) " />
            </philips:id>
            <philips:locale>
              <xsl:value-of select="$locale" />
            </philips:locale>
            <philips:catalogType>
              <xsl:value-of select="$catalogType" />
            </philips:catalogType>
            <philips:merchandizerDisplayName romanize="true" locale="{$locale}">
              <xsl:value-of select="sql:m_subcategoryname" />
            </philips:merchandizerDisplayName>
            <philips:displayName>
              <xsl:value-of select="sql:subcategoryname" />
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
            <philips:level>subcat</philips:level>
            <philips:sequenceNumber>
              <xsl:value-of select="sql:subcategoryrank" />
            </philips:sequenceNumber>
            <xsl:variable name="parent-code"
                          select="if (sql:l4code = '') then if (sql:l3code = '') then sql:categorycode else sql:l3code else sql:l4code " />
            <philips:parentCategory>
              <xsl:value-of select="concat($parent-code,'_',$country,'_',$catalogType) " />
            </philips:parentCategory>
          </philips:category>
        </xsl:for-each>
      </xsl:for-each-group>
    </xsl:for-each-group>
  </xsl:template>

</xsl:stylesheet>
