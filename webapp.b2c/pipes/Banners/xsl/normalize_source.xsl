<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:ci="http://apache.org/cocoon/include/1.0"
    >
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="dir"/>
  
  <xsl:variable name="locations">
    <xsl:variable name="first-location-pos" select="fn:index-of(/ss:Workbook/ss:Worksheet[1]/ss:Table/ss:Row[1]/ss:Cell, /ss:Workbook/ss:Worksheet[1]/ss:Table/ss:Row[1]/ss:Cell[ss:Data[text()='Bannertype']])"/>
    <xsl:for-each select="/ss:Workbook/ss:Worksheet[1]/ss:Table/ss:Row[1]/ss:Cell[ss:Data[text()='Bannertype']]/following-sibling::ss:Cell">
      <location name="{ss:Data/text()}" column-index="{string($first-location-pos + position())}"/>
    </xsl:for-each>
  </xsl:variable>

  <xsl:template match="/">
    <log>
      <xsl:apply-templates select="ss:Workbook/ss:Worksheet[1]/ss:Table/ss:Row[position() > 1][ss:Cell[1]/ss:Data/text() = '1']"/>
    </log>
  </xsl:template>
  <!-- -->
  <xsl:template match="ss:Row">
    <xsl:variable name="row" select="."/>
    <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
      <source:source>
        <xsl:value-of select="concat($dir, ss:Cell[4]/ss:Data/text(), '.xml')"/>
      </source:source>
      <source:fragment>
        <root>
          <content>
            <region><xsl:value-of select="fn:normalize-space(ss:Cell[2]/ss:Data/text())"/></region>
            <language><xsl:value-of select="fn:normalize-space(ss:Cell[3]/ss:Data/text())"/></language>
            <locale><xsl:value-of select="fn:normalize-space(ss:Cell[4]/ss:Data/text())"/></locale>
            <country><xsl:value-of select="fn:normalize-space(ss:Cell[5]/ss:Data/text())"/></country>
            <banner-type><xsl:value-of select="fn:normalize-space(ss:Cell[6]/ss:Data/text())"/></banner-type>
            <locations>
              <xsl:for-each select="$locations/location">
                <xsl:variable name="column-index" select="@column-index"/>
                <xsl:variable name="targets" select="$row/ss:Cell[position() = $column-index]/ss:Data/text()"/>
                <location name="{fn:normalize-space(@name)}">
                  <xsl:if test="fn:string-length($targets) > 0 and fn:lower-case($targets) != 'x'">
                    <xsl:for-each select="fn:tokenize($targets, '\s+/\s+')">
                      <target name="{.}"/>
                    </xsl:for-each>
                  </xsl:if>
                </location>
              </xsl:for-each>
            </locations>
          </content>
          <content-specs>
            <ci:include src="cocoon:/normalized-excel/content_specifics.xml"/>
          </content-specs>
          <translations>
            <url>
              <ci:include src="cocoon:/normalized-excel/translations_url.xml"/>
            </url>
            <!--
              Translations from text elements and tab names are in one file with
              multiple sheets
            -->
            <text>
              <ci:include src="cocoon:/normalized-excel/translations_textelements.xml"/>
            </text>
          </translations>
        </root>
      </source:fragment>
    </source:write>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
