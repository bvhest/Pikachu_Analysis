<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:b2b="http://pww.pikachu.philips.com/b2b/function/1.0"
    extension-element-prefixes="b2b"
    exclude-result-prefixes="xs">
  
  <!--
    Fix family codes that are sent ending with _NA or _AP by converting to _EU postfix.
    Since the families are sent as _EU in the categorization feeds
    they are not in the generated family catalogs and cannot be imported.
  -->
  <xsl:function name="b2b:fix-family-code" as="xs:string">
    <xsl:param name="family-code" as="xs:string"/>
    <xsl:value-of select="replace($family-code,'(_NA)|(_AP)$','_EU')"/>
  </xsl:function>
</xsl:stylesheet>