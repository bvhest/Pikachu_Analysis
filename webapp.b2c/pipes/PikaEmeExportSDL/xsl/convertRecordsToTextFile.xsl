<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:local="http://local-functions">

  <xsl:param name="column-separator" select="'|'"/>

  <xsl:template match="/root">
    <xsl:apply-templates select="sql:rowset/sql:row/sql:*"/>
  </xsl:template>
  
  <xsl:template match="sql:row/sql:*[position()=last()]">
    <xsl:value-of select="local:text-field(text())"/>
    <xsl:value-of select="'&#13;'" />
    <!-- NEWLINE -->
    <xsl:text>
</xsl:text>
  </xsl:template>
  
  <xsl:template match="sql:row/sql:*[position() &lt; last()]">
    <xsl:value-of select="local:text-field(text())" />
    <xsl:value-of select="$column-separator" />
  </xsl:template>
  
  <xsl:template match="sql:row/sql:searchtext" priority="10">
    <xsl:value-of select="substring-before(text(),'|')"/>
    <xsl:value-of select="$column-separator" />
  </xsl:template>
  
  <!--
    Strip the milliseconds from a timestamp field.
    Cut off all fields to a max. length of 255, because external table fields cannot be longer.
  -->
  <xsl:function name="local:text-field">
    <xsl:param name="field"/>
    <xsl:choose>
      <xsl:when test="$field != ''">
        <!-- xsl:analyze-string regex="(\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2})\.\d+" select="$field" -->
        <xsl:value-of select="substring(replace($field,'(\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2})\.\d+','$1'), 1, 250)"/>
      </xsl:when>
    </xsl:choose>
  </xsl:function>
</xsl:stylesheet>