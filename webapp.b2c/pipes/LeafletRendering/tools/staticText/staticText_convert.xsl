<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmr="http://www.gnome.org/gnumeric/v7"
                xmlns:ws="http://apache.org/cocoon/source/1.0">
  
  <xsl:param name="output-dir"/>
  <xsl:param name="output-prefix"/>
  
  <xsl:template match="/static-texts">
    <root>
      <xsl:apply-templates />
    </root>
  </xsl:template>
  
  <xsl:template match="product-leaflet|family-leaflet">
      <xsl:variable name="doc-type" select="if (local-name() = 'product-leaflet') then 'PMT' else 'FMT'"/>
      
      <xsl:for-each select="fields/field[1]/locales/*">
        <xsl:variable name="locale" select="local-name()"/>
        <ws:write>
          <ws:source>
            <xsl:value-of select="concat($output-dir,'/',$output-prefix,$doc-type,'_',$locale,'.xml')"/>
          </ws:source>
          <ws:fragment>
            <static_text xmlns:doc="http://www.relate4u.com/xsl/documentation" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="static_text_file_locale.xsd">
              <doc:asset>
                <doc:author>
                  <doc:name>Pikachu</doc:name>
                  <doc:company>Philips, Eindhoven</doc:company>
                  <doc:email>pikachu.b2b.support@philips.com</doc:email>
                </doc:author>
                <doc:description>
                  Static text file for Philips Lighting product brochures XSL-FO stylesheet.
                  This file contains translated static text fields which are not available in the product XML files.
                  Last updated: <xsl:value-of select="current-dateTime()"/>
                </doc:description>
                <doc:language><xsl:value-of select="$locale"/></doc:language>
                <doc:document-type><xsl:value-of select="$doc-type"/></doc:document-type>
              </doc:asset>
              <fields>
                <xsl:apply-templates select="ancestor::fields/field">
                  <xsl:with-param name="locale" select="$locale"/>
                </xsl:apply-templates>
              </fields>
            </static_text>
          </ws:fragment>
        </ws:write>
      </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="field">
    <xsl:param name="locale"/>
    <xsl:variable name="field-text" select="locales/*[local-name() = $locale]/text()"/>
    <xsl:variable name="l-field-text" select="if ($field-text != '') then $field-text else locales/*[local-name() = 'en_US']/text()"/>
    <field id="{key/text()}"><xsl:apply-templates select="$l-field-text" mode="convert"/></field>
  </xsl:template>
  
  <!--
    Output literal <br/> as XML element.
    Output literal <b>, <i>, etc as XML elements.
  -->
  <xsl:template match="text()" mode="convert">
    <xsl:analyze-string select="." regex="&lt;br/?&gt;">
      <xsl:matching-substring>
        <br/>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:analyze-string select="." regex="&lt;(\w+)&gt;(.+?)&lt;/(\w+)&gt;">
          <xsl:matching-substring>
            <xsl:element name="{regex-group(1)}">
              <xsl:value-of select="regex-group(2)"/>
            </xsl:element>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <xsl:value-of select="."/>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>
  
</xsl:stylesheet>
