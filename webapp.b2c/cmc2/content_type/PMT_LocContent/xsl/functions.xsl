<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:my="http://pww.pikachu.philips.com/functions/local"
  >
  
  <xsl:function name="my:ctn-from-filename">
    <xsl:param name="filename"/>
    <!-- Strip the locale part and replace an underscore followed by two digits with a slash -->
    <xsl:value-of select="replace(replace($filename,'_.._..\.xml$',''),'_(\d\d)$','/$1')"/>
  </xsl:function>  
  
</xsl:stylesheet>