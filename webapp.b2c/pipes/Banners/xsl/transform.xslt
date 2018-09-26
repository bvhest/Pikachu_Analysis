<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="dir"/>
  <xsl:template match="/root">
    <root>
      <xsl:variable name="fnBase">
        <xsl:value-of select="replace(concat(Bannertype, '_', item), ' ', '')"/>
      </xsl:variable>
      <xsl:variable name="fnLocale">
        <xsl:value-of select="concat(locale, '_', $fnBase)"/>
      </xsl:variable>
      <!-- -->
      <xsl:if test="string-length(item) gt 1">
        <xsl:if test="type = 'jpg'">
          <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
            <source:source>
              <xsl:value-of select="replace(concat($dir, locale, '_', Bannertype, '_', id,'.xml'),' ', '')"/>
            </source:source>
            <source:fragment>
              <xsl:element name="{concat(Bannertype, 'Teaser')}">
                <xsl:attribute name="xsi:noNamespaceSchemaLocation"><xsl:value-of select="concat(Bannertype, 'Teaser')"/></xsl:attribute>
                <TabItem>
                  <TabName>
                    <xsl:value-of select="tabnames"/>
                  </TabName>
                  <Asset>
                    <ImageUrl>
                      <xsl:value-of select="concat('/pageitems/master/grouppage/img/', $fnLocale, '.jpg')"/>
                    </ImageUrl>
                    <xsl:if test="string-length(urls) gt 1">
                      <TargetUrl>
                        <xsl:value-of select="urls"/>
                      </TargetUrl>
                    </xsl:if>
                  </Asset>
                  <Duration>15</Duration>
                </TabItem>
              </xsl:element>
            </source:fragment>
          </source:write>
        </xsl:if>
        <!-- -->
        <xsl:if test="type ne 'jpg'">
          <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
            <source:source>
              <xsl:value-of select="replace(concat($dir, locale, '_', Bannertype, '_', id,'.xml'),' ', '')"/>
            </source:source>
            <source:fragment>
              <xsl:element name="{concat(Bannertype, 'Teaser')}">
                <xsl:attribute name="xsi:noNamespaceSchemaLocation"><xsl:value-of select="concat(Bannertype, 'Teaser')"/></xsl:attribute>
                <TabItem>
                  <TabName>
                    <xsl:value-of select="tabnames"/>
                  </TabName>
                  <Asset>
                    <ImageUrl>
                      <xsl:value-of select="concat('/pageitems/master/grouppage/swf/', $fnBase, '.swf')"/>
                    </ImageUrl>
                    <XMLUrl>
                      <xsl:value-of select="concat('/pageitems/locales/', locale, '/CONSUMER/grouppage/', id, '/config/', $fnLocale, '.xml')"/>
                    </XMLUrl>
                  </Asset>
                  <Duration>15</Duration>
                </TabItem>
              </xsl:element>
            </source:fragment>
          </source:write>
          <!-- -->
          <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
            <source:source>
              <xsl:value-of select="concat($dir, $fnLocale, '.xml')"/>
            </source:source>
            <source:fragment>
              <BannerFlash>
                <TextElements>
                  <TextElement id="header">
                    <Text color="0x00A7BC" font="Gilles Sans" fontSize="30">
                      <xsl:value-of select="headline"/>
                    </Text>
                  </TextElement>
                  <TextElement id="subtitle">
                    <Text color="0x000000" font="Verdana" fontSize="12">
                      <xsl:value-of select="subtitle"/>
                    </Text>
                  </TextElement>
                  <TextElement id="findoutmore">
                    <TargetUrl>
                      <xsl:value-of select="urls"/>
                    </TargetUrl>
                  </TextElement>
                </TextElements>
              </BannerFlash>
            </source:fragment>
          </source:write>
        </xsl:if>
      </xsl:if>
    </root>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
