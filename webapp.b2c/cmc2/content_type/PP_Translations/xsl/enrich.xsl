<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="PackagingProjectConfiguration">
    <PackagingProjectTranslations>
      <xsl:apply-templates select="@*[not(local-name()='validate' or local-name()='division' or local-name()='noNamespaceSchemaLocation')]"/>
      <xsl:apply-templates select="ancestor::content/secondary/octl/sql:rowset/sql:row[sql:content_type='PText_Raw']/sql:data/PackagingText/@remarks"/>
      <xsl:apply-templates select="Localizations"/>
      <xsl:variable name="Localizations" select="Localizations/node()"/>
      <xsl:apply-templates select="ancestor::content/secondary/octl/sql:rowset/sql:row[sql:content_type='PText_Raw']">
        <xsl:with-param name="Localizations" select="$Localizations"/>
      </xsl:apply-templates>
    </PackagingProjectTranslations>
  </xsl:template>
  <!-- -->
  <xsl:template match="@docTimeStamp">
    <xsl:attribute name="docTimeStamp"><xsl:value-of select="ancestor::entry/octl-attributes/lastmodified_ts"/></xsl:attribute>
  </xsl:template>
  <!-- -->
  <xsl:template match="Localizations">
    <xsl:element name="Versioning" inherit-namespaces="no">
      <DocStatus/>
      <xsl:element name="Input" inherit-namespaces="no">
        <LanguageCode>Configuration</LanguageCode>
        <MasterLastModified>
          <xsl:value-of select="substring(replace(ancestor::PackagingProjectConfiguration/@docTimeStamp,'T',' '),1,19)"/>
        </MasterLastModified>
        <LastModified>
          <xsl:value-of select="replace(ancestor::entry/octl-attributes/lastmodified_ts,'T',' ')"/>
        </LastModified>
      </xsl:element>
      <xsl:element name="Input" inherit-namespaces="no">
        <LanguageCode>Source Text</LanguageCode>
        <MasterLastModified>
          <xsl:value-of select="replace(ancestor::content/secondary/octl/sql:rowset/sql:row[sql:content_type='PText_Raw']/sql:masterlastmodified_ts,'T',' ')"/>
        </MasterLastModified>
        <LastModified>
          <xsl:value-of select="replace(ancestor::content/secondary/octl/sql:rowset/sql:row[sql:content_type='PText_Raw']/sql:lastmodified_ts,'T',' ')"/>
        </LastModified>
      </xsl:element>
      <xsl:apply-templates select="Localization"/>
    </xsl:element>
  </xsl:template>
  <!-- -->
  <xsl:template match="Localization">
    <xsl:variable name="lc" select="@languageCode"/>
    <xsl:element name="Input" inherit-namespaces="no">
      <LanguageCode>
        <xsl:value-of select="$lc"/><xsl:if test="ancestor::content/secondary/octl/sql:rowset/sql:row[sql:localisation=replace($lc,'-','_')]/sql:data/PackagingText/PackagingTextItem/ItemText[@translated='no']"><xsl:text> (partial translations received)</xsl:text></xsl:if>
      </LanguageCode>
      <MasterLastModified>
        <xsl:value-of select="replace(ancestor::content/secondary/octl/sql:rowset/sql:row[sql:localisation=replace($lc,'-','_')]/sql:masterlastmodified_ts,'T',' ')"/>
      </MasterLastModified>
      <LastModified>
        <xsl:value-of select="replace(ancestor::content/secondary/octl/sql:rowset/sql:row[sql:localisation=replace($lc,'-','_')]/sql:lastmodified_ts,'T',' ')"/>
      </LastModified>
    </xsl:element>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:row[sql:content_type='PText_Raw']">
    <xsl:param name="Localizations"/>
    <xsl:apply-templates select="sql:data/PackagingText/PackagingTextItem">
      <xsl:with-param name="Localizations" select="$Localizations"/>
    </xsl:apply-templates>
  </xsl:template>
  <!-- -->
  <xsl:template match="PackagingTextItem">
    <xsl:param name="Localizations"/>
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <xsl:variable name="textcode" select="@code"/>
      <xsl:variable name="sourcetext" select="ItemText"/>
      <xsl:variable name="content" select="ancestor::content"/>
      <xsl:copy-of select="ItemText" copy-namespaces="no"/>
      <!--xsl:for-each select="$content/secondary/octl/sql:rowset/sql:row[sql:content_type='PText_Translated']/sql:data/PackagingText/PackagingTextItem[@code=$textcode][@translated='yes']"-->
      <xsl:for-each select="$content/secondary/octl/sql:rowset/sql:row[sql:content_type='PText_Translated']/sql:data/PackagingText/PackagingTextItem[@code=$textcode][not(ItemText/@translated='no')]">
        <Translation languageCode="{replace(../@languageCode,'_','-')}">
          <ItemTextTranslation>
            <xsl:if test="normalize-space($sourcetext/text())!=normalize-space(source/ItemText/text())">
              <xsl:attribute name="outOfDate" select="'true'"/>
            </xsl:if>
            <xsl:value-of select="ItemText"/>
          </ItemTextTranslation>
        </Translation>
      </xsl:for-each>  
      <xsl:for-each select="$Localizations">
        <xsl:sort select="@languageCode"/>
        <xsl:variable name="lc" select="replace(./@languageCode,'_','-')"/>
        <xsl:if test="not(empty($lc) or $lc='')">
          <!--xsl:if test="not(exists($content/secondary/octl/sql:rowset/sql:row[replace(sql:localisation,'_','-')=$lc]/sql:data/PackagingText/PackagingTextItem[@code=$textcode][@translated='yes']))"-->
          <xsl:if test="not(exists($content/secondary/octl/sql:rowset/sql:row[replace(sql:localisation,'_','-')=$lc]/sql:data/PackagingText/PackagingTextItem[@code=$textcode][not(ItemText/@translated='no')]))">
            <Translation languageCode="{$lc}">
              <ItemTextTranslation>
                <xsl:value-of select="'not yet available'"/>
              </ItemTextTranslation>
            </Translation>
          </xsl:if>
        </xsl:if>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="secondary"/>
  <!-- -->
</xsl:stylesheet>
