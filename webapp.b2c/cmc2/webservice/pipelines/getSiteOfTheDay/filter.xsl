<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:autn="http://schemas.autonomy.com/aci/" xmlns:xslt2="urn:xslt2Functions" exclude-result-prefixes="xs xslt2 autn">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="yes" />

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/">
    <xsl:apply-templates select="rss/channel/item[1]"/>
  </xsl:template>
  
  <xsl:template match="rss/channel/item[1]">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
 
  <xsl:template match="description">
    <xsl:copy>
      <xsl:apply-templates select="text()"/>
    </xsl:copy> 
  </xsl:template>
  
</xsl:stylesheet>