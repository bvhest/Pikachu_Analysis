<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
                xmlns:pms-f="http://www.philips.com/pika/pms/1.0"
                xmlns:ccr="http://www.philips.com/ccr/functions"
                >
  <xsl:import href="../../../content_type/PMS/xsl/pms.functions.xsl" />                
  <xsl:import href="../em-functions.xsl"/>
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:param name="userID" select="''"/>
  <xsl:param name="contentType" select="''"/>
  <xsl:param name="ctnRestriction" select="''"/>
  <xsl:param name="locales" select="''"/>
  <xsl:param name="pmt-edit-url" select="''"/>
  <xsl:param name="assets-edit-url" select="''"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/">
    <xsl:element name="GetUploadURLRoot">
      <xsl:attribute name="DocTimeStamp" select="em:formatDate(current-dateTime())"/>
      <xsl:attribute name="DocStatus" select="'draft'"/>
      <xsl:attribute name="xsi:noNamespaceSchemaLocation" select="'xUCDM_getUploadURL_EMP v1.xsd'"/>
      
      <xsl:element name="CallParameters">
        <xsl:call-template name="CallParameters">
          <xsl:with-param name="userID" select="$userID"/>
          <xsl:with-param name="contentType" select="$contentType"/>
          <xsl:with-param name="ctnRestriction" select="$ctnRestriction"/>
          <xsl:with-param name="locales" select="$locales"/>
        </xsl:call-template>
      </xsl:element>
      
      <xsl:element name="UploadURL">
        <xsl:choose>
          <xsl:when test="$contentType = 'PMT_Raw'"> 
            <xsl:variable name="map">
	          <param name="user_id" value="{$userID}"/>
	          <param name="product_id" value="{$ctnRestriction}"/>
	        </xsl:variable>
	        <xsl:if test="$pmt-edit-url != ''">
	          <xsl:value-of select="pms-f:fill-placeholders($pmt-edit-url, $map)"/>
	        </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="map">
              <param name="doc_type" value="{$contentType}"/>
              <param name="searchstring" value="{ccr:getSearchString($ctnRestriction)}"/>
              <param name="languages" value="{ccr:getLanguages($locales)}"/>
              <param name="products" value="{ccr:getProducts($ctnRestriction)}"/>
            </xsl:variable>
            <xsl:if test="$assets-edit-url != ''">
              <xsl:value-of select="pms-f:clean-empty-url-params(pms-f:fill-placeholders($assets-edit-url, $map))"/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="CallParameters">
    <xsl:param name="userID" select="''"/>
    <xsl:param name="contentType" select="''"/>
    <xsl:param name="ctnRestriction" select="''"/>
    <xsl:param name="locales" select="''"/>
  
    <xsl:element name="userID">
      <xsl:value-of select="$userID"/>
    </xsl:element>
    <xsl:element name="contentType">
      <xsl:value-of select="$contentType"/>
    </xsl:element>
    <xsl:element name="ctnRestriction">
      <xsl:for-each select="tokenize($ctnRestriction, ',')">
        <xsl:element name="item">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
    <xsl:element name="locales">
      <xsl:for-each select="tokenize($locales, ',')">
        <xsl:element name="item">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <xsl:function name="ccr:getSearchString">
    <xsl:param name="ctns"/>
  
    <xsl:value-of select="string-join(for $i in tokenize($ctns, ',') return concat('ctn%3D', $i), ' ')"/>
  </xsl:function>
  
  <xsl:function name="ccr:getLanguages">
    <xsl:param name="languages"/>
    
    <xsl:variable name="result">
      
      <xsl:for-each select="tokenize($languages, ',')"> 
        <xsl:text>&amp;</xsl:text>
        <xsl:text>language_</xsl:text>
        <xsl:value-of select="position()"/>
        <xsl:text>=</xsl:text>
        <xsl:value-of select="upper-case(current())"/>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:value-of select="$result"/>
  </xsl:function>
  
  <xsl:function name="ccr:getProducts">
    <xsl:param name="products"/>
    
    <xsl:variable name="result">
      <xsl:for-each select="tokenize($products, ',')"> 
        <xsl:text>&amp;</xsl:text>
        <xsl:text>product_</xsl:text>
        <xsl:value-of select="position()"/>
        <xsl:text>=</xsl:text>
        <xsl:value-of select="current()"/>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:value-of select="$result"/>
  </xsl:function>
</xsl:stylesheet>
