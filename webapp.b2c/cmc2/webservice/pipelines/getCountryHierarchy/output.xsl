<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:inc="http://apache.org/cocoon/include/1.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="xhtml xsl fn inc tns"
               >
       
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xhtml:tr" mode="collectRegion">
    <xsl:if test="xhtml:td[2] = '2'">
      <xsl:element name="Region">
        <xsl:attribute name="code" select="current()/xhtml:td[3]/xhtml:a/xhtml:b"/>
        <xsl:attribute name="position" select="position()"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="xhtml:tr" mode="collectCountry">
    <xsl:if test="xhtml:td[2] = '3'">
      <xsl:element name="Country">
        <xsl:attribute name="code" select="current()/xhtml:td[3]/xhtml:a/xhtml:b"/>
        <xsl:attribute name="position" select="position()"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="xhtml:tr" mode="region">
    <xsl:param name="regions"/>
    <xsl:param name="countries"/>
    
    <xsl:if test="xhtml:td[2] = '2'">
      <xsl:element name="Region">
        <xsl:attribute name="level" select="current()/xhtml:td[2]"/>
        <xsl:attribute name="code" select="current()/xhtml:td[3]/xhtml:a/xhtml:b"/>
        <xsl:attribute name="name" select="current()/xhtml:td[5]"/>
    
        <xsl:variable name="currentCode" select="current()/xhtml:td[3]/xhtml:a/xhtml:b"/>
        <xsl:variable name="currentPosition" select="$regions/*[@code=$currentCode]/@position"/>
        
        <xsl:variable name="nextCode" select="following-sibling::xhtml:tr[@class='domain-DATA-light'][xhtml:td[2] = '2']/xhtml:td[3]/xhtml:a/xhtml:b"/>
        <xsl:variable name="nextRegion" select="$regions/*[@code=$nextCode[1]]/@position"/>
        
        <xsl:apply-templates select="following-sibling::xhtml:tr[@class='domain-DATA-light']
                                                                [xhtml:td[2] = '3']" mode="country">
          <xsl:with-param name="country-positions" select="$countries"/>
          <xsl:with-param name="country-position-from" select="$currentPosition"/>
          <xsl:with-param name="country-position-to" select="$nextRegion"/>                                            
        </xsl:apply-templates>
        
    </xsl:element>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="xhtml:tr" mode="country">
    <xsl:param name="country-positions"/>
    <xsl:param name="country-position-from"/>
    <xsl:param name="country-position-to"/>

    <xsl:variable name="current-position" select="number($country-positions/*[@code=current()/xhtml:td[3]/xhtml:a/xhtml:b]/@position)"/>

    <xsl:if test="empty($country-position-to) or (number($country-position-from) &lt; $current-position and $current-position &lt; number($country-position-to))">  
      <xsl:element name="Region">
        <xsl:attribute name="level" select="current()/xhtml:td[2]"/>
        <xsl:attribute name="code" select="current()/xhtml:td[3]/xhtml:a/xhtml:b"/>
        <xsl:attribute name="name" select="current()/xhtml:td[5]"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="xhtml:html"> 
    <xsl:element name="CountryHierarchy">
      <xsl:attribute name="functional-code" select="'Internal2'"/>
      <xsl:attribute name="name" select="'Internal Hierarchy - BMC'"/>
      
      <xsl:element name="Remarks">
        <xsl:text>BMC CoD Hierarchy</xsl:text>
      </xsl:element>
      <xsl:element name="Regions">
      
      <xsl:variable name="world" select="//xhtml:table[@class='CR-table']/xhtml:tr[@class='domain-DATA-light'][xhtml:td[2] = '1']"/>
      <xsl:variable name="regions" >
        <xsl:apply-templates select="//xhtml:table[@class='CR-table']/xhtml:tr[@class='domain-DATA-light']" mode="collectRegion"/>
      </xsl:variable>
      <xsl:variable name="countries">
        <xsl:apply-templates select="//xhtml:table[@class='CR-table']/xhtml:tr[@class='domain-DATA-light']" mode="collectCountry"/>
      </xsl:variable>

      <xsl:element name="Region">
        <xsl:attribute name="level" select="$world/xhtml:td[2]"/>
        <xsl:attribute name="code" select="$world/xhtml:td[3]/xhtml:a/xhtml:b"/>
        <xsl:attribute name="name" select="$world/xhtml:td[5]"/>
        
        <xsl:apply-templates select="//xhtml:table[@class='CR-table']/xhtml:tr[@class='domain-DATA-light']" mode="region">
          <xsl:with-param name="regions" select="$regions"/>
          <xsl:with-param name="countries" select="$countries"/>
        </xsl:apply-templates>
      </xsl:element>
      
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>