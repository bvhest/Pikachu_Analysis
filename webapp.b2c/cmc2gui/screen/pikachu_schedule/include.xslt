<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="page">home</xsl:param>
  <xsl:param name="section"/>
  <!-- -->
  <xsl:template match="/">
      <cinclude:include>      
        <xsl:variable name="pre-pipe" select="concat(substring-before(sql:rowset/sql:row[1]/sql:cron_entry,'pipe='),'pipe=')"/> 
        <xsl:variable name="pipe" select="substring-after(sql:rowset/sql:row[1]/sql:cron_entry,'pipe=')"/> 
        <xsl:variable name="stem" select="if(contains($pipe,'?')) then substring-before($pipe,'?') else $pipe"/> 
        <xsl:variable name="request-params" select="if(contains($pipe,'?')) then concat('?', substring-after($pipe,'?')) else ''"/> 
        <xsl:variable name="esc-request-params" select="encode-for-uri($request-params)"/>
        <xsl:attribute name="src"><xsl:value-of select="concat($pre-pipe,$stem,'/runPipeline',$esc-request-params)"/></xsl:attribute>
        <!--xsl:attribute name="src"><xsl:value-of select="concat(sql:rowset/sql:row/sql:cron_entry,'/runPipeline')"/></xsl:attribute-->
      </cinclude:include>
  </xsl:template>
</xsl:stylesheet>
