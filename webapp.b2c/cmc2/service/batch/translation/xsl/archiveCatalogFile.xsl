<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:shell="http://apache.org/cocoon/shell/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ct"/>
  <xsl:param name="source"/>
  <xsl:param name="target"/>
  <xsl:param name="archiveCatalogFile"/>
  <!-- -->
  <xsl:template match="/">
    <entries ct="{$ct}">
      <entry includeinreport="yes">
        <page catalogfile="{$source}">
          <!-- Process catalog.xml file -->
          <xsl:if test="$archiveCatalogFile='yes'">
            <xsl:call-template name="archiveCatalogFile"/>
          </xsl:if>
        </page>
      </entry>
    </entries>
  </xsl:template>
  <!-- -->
  <xsl:template name="archiveCatalogFile">
    <shell:move overwrite="true">
      <shell:source><xsl:value-of select="$source"/></shell:source>
      <shell:target><xsl:value-of select="$target"/></shell:target>
    </shell:move>
  </xsl:template>
</xsl:stylesheet>