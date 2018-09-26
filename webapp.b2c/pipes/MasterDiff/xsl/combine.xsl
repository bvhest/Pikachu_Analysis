<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml XmlDiff-test.xml?>
<xsl:stylesheet version="2.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:template match="/dir:directory">
    <root>
      <xsl:apply-templates select="dir:file/dir:xpath/root"/>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="dir:file/dir:xpath/root">
      <xsl:apply-templates select="node()[LocaleValue or MasterValue]"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="node()[LocaleValue or MasterValue]">
    <data>
      <locale><xsl:value-of select="../Locale"/></locale>
      <ctn><xsl:value-of select="../CTN"/>
      </ctn>
      <code>
        <xsl:value-of select="concat(name(), ' ')"/>
        <xsl:apply-templates select="node()[name() != 'LocaleValue' and name() !='MasterValue']" mode="now"/>
      </code>
      <MasterValue>
        <xsl:value-of select="MasterValue"/>
      </MasterValue>
      <LocaleValue>
        <xsl:value-of select="LocaleValue"/>
      </LocaleValue>
    </data>
  </xsl:template>
  <!-- -->
  <xsl:template mode="now" match="*">
    <xsl:text>(</xsl:text>
    <xsl:value-of select="concat(name(),'= ',text())"/>
    <xsl:text>)</xsl:text>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
