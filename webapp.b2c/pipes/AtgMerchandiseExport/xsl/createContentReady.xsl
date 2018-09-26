<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i="http://apache.org/cocoon/include/1.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:template match="/root">
    <xsl:variable name="runtimestamp" select="sql:rowset[@name='get-channel-data']/sql:row[1]/sql:startexec" />
    <xsl:variable name="timestamp" select="replace(replace(replace(substring($runtimestamp,1,19),':',''),'-',''),' ','')" />
    <root>
      <xsl:copy-of select="sourceResult"/>
      <xsl:apply-templates select="sql:rowset[@name='get-channel-data']/sql:row">
        <xsl:with-param name="timestamp" select="$timestamp"/>
      </xsl:apply-templates>
    </root>
  </xsl:template>
  
  <xsl:template match="sql:row[number(sql:priority_group) = 0]">
    <xsl:param name="timestamp"/>
    <i:include>
      <xsl:attribute name="src">
        <xsl:text>cocoon:/createCONTENTREADY/</xsl:text>
        <xsl:value-of select="$timestamp" />
      </xsl:attribute>
    </i:include>
  </xsl:template>

  <xsl:template match="sql:row[number(sql:priority_group) &gt; 0]">
    <xsl:param name="timestamp"/>
    <i:include>
      <xsl:attribute name="src">
        <xsl:text>cocoon:/createCONTENTREADY/</xsl:text>
        <xsl:value-of select="$timestamp" />
        <xsl:text>/group</xsl:text>
        <xsl:value-of select="format-number(sql:priority_group, '00')" />
      </xsl:attribute>
    </i:include>
  </xsl:template>
</xsl:stylesheet>