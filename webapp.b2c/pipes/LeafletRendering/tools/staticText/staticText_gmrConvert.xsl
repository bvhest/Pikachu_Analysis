<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmr="http://www.gnome.org/gnumeric/v7"
                xmlns:ws="http://apache.org/cocoon/source/1.0">
  
  <xsl:param name="output-dir"/>
  <xsl:param name="output-prefix"/>
  
  <xsl:variable name="config">
    <item name="family" sheet-name="Family text" doctype="FMT">
      <locales>
        <xsl:for-each select="/gmr:Workbook/gmr:Sheets/gmr:Sheet[gmr:Name='Family text']/gmr:Cells/gmr:Cell[number(@Row)=0][number(@Col) &gt; 1]">
          <locale l="{text()}" col="{@Col}"/>
        </xsl:for-each>
      </locales>
      <fields>
        <xsl:for-each select="/gmr:Workbook/gmr:Sheets/gmr:Sheet[gmr:Name='Family text']/gmr:Cells/gmr:Cell[number(@Row) &gt; 0][number(@Col) = 0]">
          <field name="{text()}" index="{@Row}"/>
        </xsl:for-each>        
      </fields>
    </item>
    <item name="product" sheet-name="Product text" doctype="PMT">
      <locales>
        <xsl:for-each select="/gmr:Workbook/gmr:Sheets/gmr:Sheet[gmr:Name='Product text']/gmr:Cells/gmr:Cell[number(@Row)=0][number(@Col) &gt; 1]">
          <locale l="{text()}" col="{@Col}"/>
        </xsl:for-each>
      </locales>
      <fields>
        <xsl:for-each select="/gmr:Workbook/gmr:Sheets/gmr:Sheet[gmr:Name='Product text']/gmr:Cells/gmr:Cell[number(@Row) &gt; 0][number(@Col) = 0]">
          <field name="{text()}" index="{@Row}"/>
        </xsl:for-each>        
      </fields>
    </item>
  </xsl:variable>
  
  <xsl:template match="/gmr:Workbook">
    <root>
      <xsl:apply-templates select="gmr:Sheets/gmr:Sheet"/>
    </root>
  </xsl:template>
  
  <xsl:template match="gmr:Sheet">
    <xsl:variable name="sheet" select="."/>
    <xsl:variable name="conf" select="$config/item[@sheet-name=current()/gmr:Name]"/>

    <xsl:if test="$conf">
      <xsl:for-each select="$conf/locales/locale">
        <ws:write>
          <ws:source>
            <xsl:value-of select="concat($output-dir,'/',$output-prefix,$conf/@doctype,'_',@l,'.xml')"/>
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
                </doc:description>
                <doc:language><xsl:value-of select="@l"/></doc:language>
                <doc:document-type><xsl:value-of select="$conf/@doctype"/></doc:document-type>
              </doc:asset>
              <fields>
                <xsl:apply-templates select="$sheet/gmr:Cells/gmr:Cell[number(@Row) &gt; 0][@Col = current()/@col]">
                  <xsl:with-param name="conf" select="$conf"/>
                </xsl:apply-templates>
              </fields>
            </static_text>
          </ws:fragment>
        </ws:write>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="gmr:Cell">
    <xsl:param name="conf"/>
    
    <field id="{$conf/fields/field[@index=current()/@Row]/@name}"><xsl:apply-templates select="text()" mode="split-lines"/></field>
  </xsl:template>
  
  <!--
    Output literal <br/> as XML element.
    Output literal <b> and <i> as XML elements.
  -->
  <xsl:template match="text()" mode="split-lines">
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
