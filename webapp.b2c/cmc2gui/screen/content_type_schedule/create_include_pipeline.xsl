<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:i="http://apache.org/cocoon/include/1.0"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:param name="gui_url"/>
  <xsl:param name="pipe"/>
  <xsl:param name="usefullpath">no</xsl:param>
  
  <xsl:template match="/">
    <root>
      <xsl:apply-templates select="//sql:rowset/sql:row"/>
    </root>
  </xsl:template>
<!--
  "cocoon:/{global:gui_url}xml/cron.xml?job={request-param:param1}&amp;pipe=cmc2/content_type/{request-param:param1}?schedule_id={request-param:param3}"
  -->
  <xsl:template match="sql:row"> 
    <xsl:variable name="base_pipeline" select="if ($pipe='') then sql:pipeline else $pipe"/>
    <xsl:variable name="pipeline" select="if (contains($base_pipeline,'?')) 
                                               then concat($base_pipeline,'%26schedule_id=',sql:id) 
                                          else if(contains($base_pipeline,'%3F')) 
                                               then concat($base_pipeline,'%26schedule_id=',sql:id) 
                                          else concat($base_pipeline,'%3Fschedule_id=',sql:id)"/>
    <i:include>
      <xsl:attribute name="src">
        <xsl:text>cocoon:/</xsl:text>
        <xsl:value-of select="$gui_url"/>
        <xsl:text>xml/cron.xml?job=</xsl:text>
        <xsl:value-of select="sql:content_type"/>
        <xsl:text>&amp;usefullpath=</xsl:text>
        <xsl:value-of select="$usefullpath"/>
        <xsl:text>&amp;pipe=</xsl:text>
        <xsl:value-of select="replace(replace($pipeline,'\?','%3F'),'&amp;','%26')"/>
        <!-- xsl:value-of select="$pipeline"/-->
      </xsl:attribute>      
    </i:include>
  </xsl:template>  

</xsl:stylesheet>