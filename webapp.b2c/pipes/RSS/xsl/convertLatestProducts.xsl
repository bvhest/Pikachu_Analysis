<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="sql xsl cinclude">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!--  -->
  <xsl:template match="/">
    <rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
      <channel>
        <title>Latest Published Products</title>
        <link>http://www.consumer.philips.com</link>
        <description>Latest Published Products</description>
        <xsl:apply-templates/>
      </channel>
    </rss>
  </xsl:template>
  <!--  -->
  <xsl:template match="sql:id"/>
  <!--  -->
  <xsl:template match="sql:lastmodified"/>
  <!--  -->
  <xsl:template match="sql:masterlastmodified"/>
  <!--  -->
  <xsl:template match="sql:division"/>
  <!--  -->
  <xsl:template match="//Product">
    <item>
      <title>
        <xsl:choose>
          <xsl:when test="string-length(NamingString/BrandString) &gt; 0">
            <xsl:value-of select="NamingString/BrandString"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="NamingString/Concept/ConceptName"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="NamingString/Descriptor/DescriptorName"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="CTN"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="NamingString/VersionString"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="NamingString/BrandedFeatureString"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="NamingString/MasterBrand/BrandName"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="NamingString/Concept/ConceptName"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="NamingString/SubBrand/BrandName"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="NamingString/Descriptor/DescriptorName"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="CTN"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="NamingString/VersionString"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="NamingString/BrandedFeatureString"/>
          </xsl:otherwise>
        </xsl:choose>
      </title>
      <link>
        <xsl:value-of select="concat('http://nlvu045.gdc1.ce.philips.com:8888/pichu/xml/masterproduct_nice.html?ctn=',CTN)"/>
      </link>
      <enclosure>
        <xsl:value-of select="concat('http://pww.p3c.philips.com/cgi-bin/newmpr/get.pl?alt=1&amp;defaultimg=1&amp;doctype=RTB&amp;id=', CTN)"/>
      </enclosure>
      <dc:creator>
        <xsl:value-of select="ProductOwner"/>
      </dc:creator>
      <pubDate>
        <xsl:value-of select="@lastModified"/>
      </pubDate>
      <description>
        <table>
          <tr>
            <td>
              <img width="200px">
                <xsl:attribute name="alt" select="CTN"/>
                <xsl:attribute name="src" select="concat('http://pww.p3c.philips.com/cgi-bin/newmpr/get.pl?alt=1&amp;defaultimg=1&amp;doctype=RTB&amp;id=', CTN)"/>
              </img>
            </td>
            <td>
              <xsl:if test="WOW!=''">
                <b>
                  <xsl:value-of select="WOW"/>
                </b>
                <br/>
              </xsl:if>
              <xsl:if test="SubWOW!=''">
                <b>
                  <xsl:value-of select="SubWOW"/>
                </b>
                <br/>
              </xsl:if>
              <xsl:if test="MarketingTextHeader!=''">
                <xsl:value-of select="MarketingTextHeader"/>
                <br/>
              </xsl:if>
              <xsl:if test="MarketingTextBody!=''">
                <xsl:value-of select="MarketingTextBody"/>
                <br/>
              </xsl:if>
            </td>
          </tr>
        </table>
      </description>
    </item>
  </xsl:template>
  <!--  -->
</xsl:stylesheet>
