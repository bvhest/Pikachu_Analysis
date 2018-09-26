<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:variable name="snow" select="replace(replace(substring(xs:string(current-dateTime()),1,16),':',''),'-','')"/>
  <xsl:param name="master"/>
  <!-- -->
  <xsl:template match="/root">
    <root>
      <xsl:apply-templates select="sql:rowset/sql:row/sql:locale" mode="locale"/>
      <xsl:if test="$master = 'yes'">
        <cinclude:include>
          <xsl:attribute name="src">cocoon:/exportLocale.<xsl:value-of select="$snow"/>.MASTER?master=yes</xsl:attribute>
        </cinclude:include>
      </xsl:if>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:locale" mode="locale">
    <xsl:variable name="locale" select="."/>
    <xsl:if test="following-sibling::sql:masterlocaleenabled='1'">
      <cinclude:include>
        <xsl:attribute name="src">cocoon:/exportLocale.<xsl:value-of select="$snow"/>.<xsl:value-of select="$locale"/>?masterlocale=yes</xsl:attribute>
      </cinclude:include>
    </xsl:if>
    <xsl:if test="following-sibling::sql:enabled='1'">
      <cinclude:include>
        <xsl:attribute name="src">cocoon:/exportLocale.<xsl:value-of select="$snow"/>.<xsl:value-of select="$locale"/>?masterlocale=no</xsl:attribute>
      </cinclude:include>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
