<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:template match="/">
    <xsl:variable name="runtimestamp" select="root/sql:rowset/sql:row[1]/sql:startexec" />
    <xsl:variable name="timestamp" select="replace(replace(replace(substring($runtimestamp,1,19),':',''),'-',''),' ','')" />
    <root>
      <xsl:apply-templates select="root/sql:rowset/sql:row/sql:locale">
        <xsl:with-param name="timestamp" select="$timestamp"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="root/sql:rowset/sql:row/sql:masterlocale[. != '']">
        <xsl:with-param name="timestamp" select="$timestamp"/>
      </xsl:apply-templates>
    </root>
  </xsl:template>
  
  <xsl:template match="sql:locale|sql:masterlocale">
    <xsl:param name="timestamp" />
    <xsl:variable name="priority-group" select="../sql:priority_group" />
    <cinclude:include>
      <xsl:attribute name="src">
        <xsl:text>cocoon:/archive/</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$timestamp" />
        <!-- Locales with a priority_group greater than zero are archived into a subdirectory per group -->
        <xsl:if test="number($priority-group) &gt; 0">
          <xsl:text>/group</xsl:text>
          <xsl:value-of select="format-number($priority-group,'00')"/>
        </xsl:if>
      </xsl:attribute>
    </cinclude:include>
  </xsl:template>
</xsl:stylesheet>