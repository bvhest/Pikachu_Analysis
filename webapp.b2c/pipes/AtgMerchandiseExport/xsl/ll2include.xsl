<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:template match="/">
    <xsl:variable name="runtimestamp" select="root/sql:rowset[@name='timestamp']/sql:row/sql:startexec" />
    <xsl:variable name="timestamp" select="replace(replace(replace(substring($runtimestamp,1,19),':',''),'-',''),' ','')" />
    <root>
      <xsl:apply-templates select="root/sql:rowset[@name='locales']/sql:row">
        <xsl:with-param name="timestamp" select="$timestamp" />
      </xsl:apply-templates>
    </root>
  </xsl:template>

  <xsl:template match="sql:row">
    <xsl:param name="timestamp" />
    <xsl:variable name="country" select="substring-after(sql:locale,'_')"/>
    <cinclude:include src="{concat('cocoon:/exportSub.',$timestamp,'.',$country,'.',sql:locale,'.',sql:ct,'.',sql:priority_group)}"/>    
  </xsl:template>

</xsl:stylesheet>