<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i="http://apache.org/cocoon/include/1.0"
  xmlns:s="http://apache.org/cocoon/source/1.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:param name="ctURL"/>
  <xsl:param name="export"/>
  <xsl:param name="ts"/>
  
  <xsl:template match="sql:row">
    <s:write>
      <s:source>
        <xsl:variable name="lang" select="ancestor::language/@name"/>
        <xsl:variable name="id" select="translate(sql:object_id[1], '/. ', '___')"/>      
        <xsl:value-of select="concat($export, '/', 'PMT_Translated', '/outbox/', $id, '_',$lang, '.xml')"/>
      </s:source>
      <s:fragment>
        <root >
        <xsl:copy-of select="../@locales"/>
        <i:include src="{$ctURL}/PMT_Translated/process/{sql:localisation}/{$ts}/{sql:object_id[1]}"/>
        </root>
      </s:fragment>
    </s:write>
  </xsl:template>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>