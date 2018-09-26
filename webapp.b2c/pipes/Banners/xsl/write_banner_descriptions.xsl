<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:func="http://www.philips.com/functions/pikachu/1.0"
    extension-element-prefixes="func fn">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="dir"><xsl:text>C:\Temp\</xsl:text></xsl:param>
  
  <xsl:function name="func:locale-file-path">
    <xsl:param name="locale"/>
    <xsl:param name="location"/>
    <xsl:param name="type"/>
    <xsl:if test="$location = 'landingpage'">
      <xsl:value-of select="$locale"/>
      <xsl:text>/CONSUMER/landingpage/</xsl:text>
      <xsl:value-of select="$type"/>
      <xsl:text>/</xsl:text>
    </xsl:if>
    <xsl:if test="$location != 'landingpage'">
      <xsl:value-of select="$locale"/>
      <xsl:text>/CONSUMER/grouppage/</xsl:text>
      <xsl:value-of select="$location"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$type"/><xsl:text>/</xsl:text>
    </xsl:if>
  </xsl:function>

  <xsl:function name="func:swf-file-name">
    <xsl:param name="target-name"/>
    <xsl:text>SeduceMe_</xsl:text>
    <xsl:value-of select="$target-name"/>
    <xsl:text>.swf</xsl:text>
  </xsl:function>

  <xsl:function name="func:swf-config-file-name">
    <xsl:param name="locale"/>
    <xsl:param name="target-name"/>
    <xsl:value-of select="$locale"/>
    <xsl:text>_SeduceMe_</xsl:text>
    <xsl:value-of select="$target-name"/>
    <xsl:text>.xml</xsl:text>
  </xsl:function>

  <xsl:function name="func:swf-file-url">
    <xsl:param name="region"/>
    <xsl:param name="target-name"/>
    <xsl:text>/pageitems/master/</xsl:text>
    <xsl:value-of select="$region"/>
    <xsl:text>/swf/SeduceMe_</xsl:text>
    <xsl:value-of select="$target-name"/>
    <xsl:text>.swf</xsl:text>
  </xsl:function>

  <xsl:function name="func:swf-config-file-url">
    <xsl:param name="locale"/>
    <xsl:param name="location"/>
    <xsl:param name="target-name"/>
    <xsl:text>/pageitems/locales/</xsl:text>
    <xsl:value-of select="func:locale-file-path($locale, $location, 'config')"/>
    <xsl:value-of select="func:swf-config-file-name($locale, $target-name)"/>
  </xsl:function>

  <xsl:function name="func:swf-config-file-store-path">
    <xsl:param name="locale"/>
    <xsl:param name="location"/>
    <xsl:param name="target-name"/>
    <xsl:param name="banner-type"/>
    <xsl:value-of select="$dir"/>
    <xsl:value-of select="func:locale-file-path($locale, $location, 'config')"/>
  </xsl:function>

  <xsl:function name="func:jpg-file-name">
    <xsl:param name="locale"/>
    <xsl:param name="target-name"/>
    <xsl:value-of select="$locale"/>
    <xsl:text>_seduce_</xsl:text>
    <xsl:value-of select="$target-name"/>
    <xsl:text>.jpg</xsl:text>
  </xsl:function>

  <xsl:function name="func:jpg-file-url">
    <xsl:param name="locale"/>
    <xsl:param name="location"/>
    <xsl:param name="target-name"/>
    <xsl:text>/pageitems/locales/</xsl:text>
    <xsl:value-of select="func:locale-file-path($locale, $location, 'img')"/>
    <xsl:value-of select="func:jpg-file-name($locale, $target-name)"/>
  </xsl:function>

  <xsl:function name="func:banner-descriptor-path">
    <xsl:param name="locale"/>
    <xsl:param name="location"/>
    <xsl:value-of select="$dir"/>
    <xsl:if test="$location = 'landingpage'">
      <xsl:value-of select="func:locale-file-path($locale, $location, 'config')"/>
      <xsl:value-of select="$locale"/>
      <xsl:text>_seduceme.xml</xsl:text>
    </xsl:if>
    <xsl:if test="$location != 'landingpage'">
      <xsl:value-of select="func:locale-file-path($locale, $location, 'config')"/>
      <xsl:value-of select="$locale"/>
      <xsl:text>_SeduceMe_</xsl:text>
      <xsl:value-of select="$location"/>
      <xsl:text>.xml</xsl:text>
    </xsl:if>
  </xsl:function>

  <xsl:function name="func:banner-flash-path">
    <xsl:param name="locale"/>
    <xsl:param name="location"/>
    <xsl:param name="target-name"/>
    <xsl:value-of select="$dir"/>
    <xsl:value-of select="func:locale-file-path($locale, $location, 'config')"/>
    <xsl:value-of select="$locale"/>
    <xsl:text>_SeduceMe_</xsl:text>
    <xsl:value-of select="$target-name"/>
    <xsl:text>.xml</xsl:text>
  </xsl:function>

  <xsl:template match="location">
    <xsl:apply-templates select="." mode="banner-descriptor"/>
    <xsl:apply-templates select="target[@type='swf']" mode="banner-flash"/>
  </xsl:template>
  
  <xsl:template match="location" mode="banner-descriptor">
    <xsl:variable name="content" select="ancestor::content"/>
    <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
      <source:source>
        <xsl:value-of select="func:banner-descriptor-path($content/locale/text(), @name/string())"/>
      </source:source>
      <source:fragment>
        <SeduceMeTeaser xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                        xsi:noNamespaceSchemaLocation="SeduceMeTeaser.xsd">
          <xsl:apply-templates select="target" mode="banner-descriptor">
            <xsl:with-param name="content" select="$content"/>
          </xsl:apply-templates>
        </SeduceMeTeaser>
      </source:fragment>
    </source:write>
  </xsl:template>
  
  <xsl:template match="target[@type='swf']" mode="banner-descriptor">
    <xsl:param name="content"/>
    <TabItem>
      <TabName>
        <xsl:choose>
          <xsl:when test="fn:string-length(@tabname) > 0">
            <xsl:value-of select="@tabname"/>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
        </xsl:choose>
      </TabName>
      <Asset>
        <ImageUrl>
          <xsl:value-of select="func:swf-file-url($content/region/text(), @name/string())"/>
        </ImageUrl>
        <XMLUrl>
          <xsl:value-of select="func:swf-config-file-url($content/locale/text(), @group/string(), @name/string())"/>
        </XMLUrl>
      </Asset>
      <Duration><xsl:value-of select="@duration"/></Duration>
    </TabItem>
  </xsl:template>
  
  <xsl:template match="target[@type='jpg']" mode="banner-descriptor">
    <xsl:param name="content"/>
    <TabItem>
      <TabName>
        <xsl:choose>
          <xsl:when test="@tabname">
            <xsl:value-of select="@tabname"/>
          </xsl:when>
          <xsl:otherwise><xsl:text>No name specified</xsl:text></xsl:otherwise>
        </xsl:choose>
      </TabName>
      <Asset>
        <ImageUrl>
          <xsl:value-of select="func:jpg-file-url($content/locale/text(), @group/string(), @name/string())"/>
        </ImageUrl>
        <TargetUrl>
          <xsl:value-of select="url"/>
        </TargetUrl>
      </Asset>
      <Duration><xsl:value-of select="@duration"/></Duration>
    </TabItem>
  </xsl:template>

  <xsl:template match="target[@type='swf']" mode="banner-flash">
    <xsl:variable name="content" select="ancestor::content"/>
    <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
      <source:source>
        <xsl:value-of select="func:banner-flash-path($content/locale/text(), @group/string(), @name/string())"/>
      </source:source>
      <source:fragment>
        <BannerFlash>
          <TextElements>
            <xsl:apply-templates select="text|url" mode="banner-flash"/>
          </TextElements>
        </BannerFlash>
      </source:fragment>
    </source:write>
  </xsl:template>

  <xsl:template match="text" mode="banner-flash">
    <xsl:if test="fn:string-length(text()) > 0">
      <TextElement id="{@type}">
        <Text color="{@color}" fontSize="{@fontSize}">
          <xsl:value-of select="text()"/>
        </Text>
      </TextElement>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="url" mode="banner-flash">
    <TextElement id="findOutMore">
      <TargetUrl>
        <xsl:value-of select="text()"/>
      </TargetUrl>
    </TextElement>
  </xsl:template>

  <xsl:template match="node()|@*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
