<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

  <xsl:variable name="apos">'</xsl:variable>

  <xsl:template match="/">
    <root>
      <xsl:apply-templates select="pipelines" />
    </root>
  </xsl:template>

  <xsl:template match="pipelines">
    <xsl:variable name="channel-ids" select="pipeline[@type='channel'][@scheduleId!='']/@scheduleId" />
    <xsl:variable name="channel-names" select="pipeline[@type='channel'][@name!='']/@name" />
    <xsl:variable name="ct-ids" select="pipeline[@type='contentType'][@scheduleId!='']/@scheduleId" />
    <xsl:variable name="ct-names" select="pipeline[@type='contentType'][@name!='']/@name" />

    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        select id, name, pipeline 
        from Channels
        where id in ('<xsl:value-of select="fn:string-join($channel-ids,'$apos,$apos')" />')
        or name in ('<xsl:value-of select="fn:string-join($channel-names,'$apos,$apos')" />')
        
        union
        
        select cts.id, cts.content_type as name, cts.pipeline 
        from content_type_schedule cts
        where cts.id in ('<xsl:value-of select="fn:string-join($ct-ids,concat($apos,',',$apos))" />')
      </sql:query>
    </sql:execute-query>
  </xsl:template>

  <xsl:template match="*|node()">
    <xsl:apply-templates />
  </xsl:template>

</xsl:stylesheet>
