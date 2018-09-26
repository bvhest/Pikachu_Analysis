<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:ws="http://apache.org/cocoon/source/1.0">

  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  
  
  <!--
    Command entry.
    E.g. for product: 910400121312_EU.fr_FR.20100303193233.PSS.pdf;910400121312_EU;PSS;;FRA;;2.0.5
    E.g. gor family:  LP_CF_4IS130_EU.es_ES.20100226163055.FFS.pdf;;FFS;;ESP;;2.0.5;LP_CF_4IS130_EU
  -->
  <xsl:template match="dir:file[number(@size) &gt; 0]">
    <!-- parts: 1 = key, 2 = locale, 3 = type -->
    <xsl:variable name="parts" select="tokenize(@name, '\.')"/>
    <xsl:variable name="ccr-lang-code" select="/root/sql:rowset/sql:row[sql:locale=$parts[2]]/sql:ccr_language_code"/>
    <xsl:choose>
      <xsl:when test="$parts[3] = 'PSS'">
        <xsl:value-of select="string-join((@name, $parts[1], $parts[3], '', $ccr-lang-code, '', '2.0.5'),';')"/><xsl:text>
</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="string-join((@name, '', $parts[3], '', $ccr-lang-code, '', '2.0.5', $parts[1]),';')"/><xsl:text>
</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>  

  <xsl:template match="dir:file[number(@size) = 0]"/>
</xsl:stylesheet>