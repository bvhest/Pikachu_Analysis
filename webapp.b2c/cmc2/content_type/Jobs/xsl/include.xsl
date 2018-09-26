<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0">
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="ct"/>
  <xsl:param name="ts"/>
  <xsl:param name="includefile"/>
  <xsl:param name="usefullpath">no</xsl:param>
  <xsl:param name="guidir"/>
  <xsl:variable name="d_includefile" select="if(string-length($includefile) &gt; 0) then if($usefullpath != 'yes') then document(concat($guidir,'/screen/',$includefile)) else document($includefile) else ()"/>
  <xsl:template match="/">
    <entries ct="{$ct}" ts="{$ts}">
      <filedata>
        <xsl:copy-of select="$d_includefile"/>
      </filedata>
    </entries>
	</xsl:template>

</xsl:stylesheet>