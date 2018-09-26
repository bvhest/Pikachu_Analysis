<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="msxsl xhtml">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="yes" />

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/">
    <Site>
      <xsl:apply-templates select="item"/>
    </Site>
  </xsl:template>
  
  <xsl:template match="item">
    <xsl:element name="Title">
      <xsl:value-of select="title"/>
    </xsl:element>
    <xsl:element name="Link">
      <xsl:value-of select="link"/>
    </xsl:element>
    <xsl:element name="Image">
      <xsl:variable name="imageUrlStart" select="substring-after(description, 'src=')"/>
      <xsl:variable name="imageUrlEnd" select="substring-before($imageUrlStart, ' alt=')"/>
      
      <xsl:value-of select="substring($imageUrlEnd, 2, string-length($imageUrlEnd) - 2)"/>
    </xsl:element>
    <xsl:element name="Description">
      <xsl:value-of select="substring-after(description, '&lt;br /&gt;')"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>