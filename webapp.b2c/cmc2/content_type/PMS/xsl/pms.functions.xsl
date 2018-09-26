<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:pms-f="http://www.philips.com/pika/pms/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
    xmlns:md5="saxon://com.philips.pikachu.md5.Md5"
    extension-element-prefixes="pms-f md5"
    >
  <xsl:variable name="ccr-url-magic" select="'PikaCCR@295'"/>
  
  <xsl:function name="pms-f:date-add">
    <xsl:param name="date" as="xs:dateTime" />
    <xsl:param name="days" as="xs:integer" />
    <xsl:variable name="one-day" select="xdt:dayTimeDuration('P1D')" />
    <xsl:variable name="day" select="$date + ($one-day * $days)" />
    <xsl:value-of select="format-dateTime($day,'[Y,*-4]-[M,2]-[D,2]T[H,2]:[m,2]:[s,2]')" />
  </xsl:function>
  
  <xsl:function name="pms-f:date-subtract">
    <xsl:param name="date" as="xs:dateTime" />
    <xsl:param name="days" as="xs:integer" />
    <xsl:variable name="one-day" select="xdt:dayTimeDuration('P1D')" />
    <xsl:variable name="day" select="$date - ($one-day * $days)" />
    <xsl:value-of select="format-dateTime($day,'[Y,*-4]-[M,2]-[D,2]T[H,2]:[m,2]:[s,2]')" />
  </xsl:function>

  <xsl:function name="pms-f:get-milestone-date">
    <xsl:param name="milestone-type" />
    <xsl:param name="product" />
    <xsl:param name="country" />
    <xsl:param name="locale" />
    <!-- $catalog = com, shop, ... -->
    <xsl:param name="catalog" />
    <xsl:variable name="date">
      <xsl:choose>
        <xsl:when test="$milestone-type = 'SAP'">
          <!-- SAP published date -->
          <xsl:value-of select="$product/EvaluationData/MasterData/SAPPublishDate" />
        </xsl:when>
        <xsl:when test="$milestone-type = 'CR'">
          <!-- Commercial release date -->
          <xsl:value-of select="$product/EvaluationData/MasterData/CRDate" />
        </xsl:when>
        <xsl:when test="$milestone-type = 'LD'">
          <!-- Launch date: earliest sop across all countries and catalogs -->
          <xsl:value-of select="min(for $d in $product/EvaluationData/Catalogs/Catalog/@sop return xs:date($d))" />
        </xsl:when>
        <xsl:when test="$milestone-type = 'SOP'">
          <!-- Start of publication for one catalog and country-->
          <xsl:value-of select="$product/Countries/Country[countryID=$country]/Catalogs/Catalog[ends-with(@columnID, $catalog)]/CatalogDetails[Deleted='false']/StartOfPublication" />
        </xsl:when>
        <xsl:when test="$milestone-type = 'ED'">
          <!-- Edit date -->
          <xsl:value-of select="$product/EvaluationData/MasterData/PMTEditCopy[Status=('InEdit','Rejected')]/CreateDate" />
        </xsl:when>
        <xsl:when test="$milestone-type = 'SID'">
          <!-- Siging date -->
          <xsl:value-of select="$product/EvaluationData/MasterData/PMTEditCopy[Status='InSigning']/InSigningDate" />
        </xsl:when>
        <xsl:when test="$milestone-type = 'CLD'">
          <!-- Country launch date: earliest SOP for a country across all catalogs -->
          <xsl:value-of select="min(for $d in $product/EvaluationData/Catalogs/Catalog[@country=$country]/@sop return xs:date($d))" />          
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="$date!=''">
        <xsl:value-of select="concat($date, 'T00:00:00')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'2300-01-01T00:00:00'" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="pms-f:marketing-classification">
    <xsl:param name="mc-in" />
    <xsl:choose>
      <xsl:when test="$mc-in = ('MCI','Key','Accessory')">
        <xsl:value-of select="$mc-in" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Other</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!-- Remove empty request parameters from a URL -->
  <xsl:function name="pms-f:clean-empty-url-params">
    <xsl:param name="url"/>
    <xsl:value-of select="replace($url, '(\?|&amp;)[^&amp;]+=(&amp;|$)', '$1')"/>
  </xsl:function>
  
  <xsl:function name="pms-f:build-catalogmanager-url">
    <xsl:param name="base-url"/>
    <xsl:param name="catalog-code"/>
    <xsl:param name="locale"/>
    <xsl:param name="ctn"/>

    <xsl:variable name="checksum" select="concat($ctn, $catalog-code, $locale, $ccr-url-magic)"/>
    <xsl:variable name="md5-checksum" select="md5:md5($checksum)"/>
    
    <xsl:variable name="map">
      <param name="product_id" value="{$ctn}"/>
      <param name="locale" value="{$locale}"/>
      <param name="catalog_id" value="{$catalog-code}"/>
      <param name="checksum" value="{$md5-checksum}"/>
    </xsl:variable>
    <xsl:value-of select="pms-f:clean-empty-url-params(pms-f:fill-placeholders($base-url, $map))" />
  </xsl:function>

  <xsl:function name="pms-f:build-pmt-preview-url">
    <xsl:param name="base-url"/>
    <xsl:param name="ctn"/>
    
    <xsl:variable name="map">
      <param name="content_type" value="PMT_Master"/>
      <param name="locale" value="master_global"/>
      <param name="id" value="{$ctn}"/>
    </xsl:variable>
    <xsl:value-of select="pms-f:clean-empty-url-params(pms-f:fill-placeholders($base-url, $map))" />
  </xsl:function>

  <xsl:function name="pms-f:build-pmt-edit-url">
    <xsl:param name="base-url"/>
    <xsl:param name="ctn"/>
    
    <xsl:variable name="map">
      <param name="product_id" value="{$ctn}"/>
    </xsl:variable>
    <xsl:value-of select="pms-f:clean-empty-url-params(pms-f:fill-placeholders($base-url, $map))" />
  </xsl:function>

  <xsl:function name="pms-f:build-asset-edit-url">
    <xsl:param name="base-url"/>
    <xsl:param name="ctn"/>
    <xsl:param name="doc-type"/>    
    <xsl:param name="locale"/>
    
    <xsl:variable name="map">
      <param name="product_id" value="{$ctn}"/>
      <param name="locale" value="{$locale}"/>
      <param name="doc_type" value="{$doc-type}"/>
    </xsl:variable>
    <xsl:value-of select="pms-f:clean-empty-url-params(pms-f:fill-placeholders($base-url, $map))" />
  </xsl:function>

  <xsl:function name="pms-f:get-contentType-for-columnId">
    <xsl:param name="col-id" />
    <xsl:choose>
      <xsl:when test="$col-id = ('TXT.DES','TXT.WOW','TXT.MTH')">
        <xsl:text>Text</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Ref</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!--
    Fill placeholders in a string.
    Placeholders are marked by surrounding their names with square brackets, e.g. [fill_me]

    Arguments:
    $str  The string with placeholders
    $map  An node tree with elements like <param name="fill_me" value="replacement value"/>
    
    If the map does not contain a replacement parameter the placeholder will be left as is.
  -->
  <xsl:function name="pms-f:fill-placeholders">
    <xsl:param name="str"/>
    <xsl:param name="map"/>
    <xsl:variable name="result">
      <xsl:analyze-string regex="\[(.*?)\]" select="$str">
        <xsl:matching-substring>
          <xsl:variable name="replacement" select="$map/param[@name=regex-group(1)]"/>
          <xsl:choose>
            <xsl:when test="exists($replacement)">
              <!--  Replace placeholder -->
              <xsl:value-of select="$replacement/@value"/>
            </xsl:when>
            <xsl:otherwise>
              <!-- Leave placeholder -->
              <xsl:value-of select="concat('[',regex-group(1),']')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:value-of select="."/>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:variable>
    <xsl:value-of select="string-join($result, '')"/>
  </xsl:function>
  
  <!--
    Find a derived thumbnail, preview or medium asset for a product's assets.
    
    Parameters:
      assets: the compact asset list as created by the convertAssetList step
      type:   The derived type (Thumbnail | Preview | Medium)
      main-types: the types to scan when looking for a derived type. If multiple types are spceified
                  they will be scanned in order and the first available one will be returned.
  -->
  <xsl:function name="pms-f:get-derived-asset">
    <xsl:param name="assets"/>
    <xsl:param name="type"/> <!-- Thumbnail, Preview, Medium -->
    <xsl:param name="main-types"/>
    
    <xsl:variable name="derived-types" select="for $t in $main-types
                                               return
                                                 $assets[@ResourceType=$t]/attribute::*[local-name() = $type]"/>
    <!-- Return the first available derived asset -->
    <xsl:sequence select="($assets[@ResourceType=$derived-types])[1]"/>
  </xsl:function>
  
</xsl:stylesheet>
