<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
        xmlns:sql="http://apache.org/cocoon/SQL/2.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:param name="runmode" select="''"/>
  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:param name="ts"/>
  <xsl:param name="dir"/>
  <xsl:param name="batchnumber"/>
  <xsl:param name="reload"/>
  
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
      
  <!-- -->  
  <xsl:template match="/root">
    <entries ct="{$ct}" l="{$l}"  ts="{$ts}" dir="{$dir}" batchnumber="{$batchnumber}" >
      <process/>
      <globalDocs/>    
      <xsl:call-template name="get_entry_records"/>
      <store-outputs/>
    </entries>
  </xsl:template>
  <!-- -->
  <xsl:template name="get_entry_records">
    <sql:execute-query>
      <sql:query>
        select oc.content_type
             , oc.localisation
             , oc.object_id
             , '<xsl:value-of select="$ts"/>' as ts
        from octl_control oc
        where oc.modus        = '<xsl:value-of select="$modus"/>'
          and oc.content_type = '<xsl:value-of select="$ct"/>' 
          and oc.localisation = '<xsl:value-of select="$l"/>' 
          and oc.batch_number = <xsl:value-of select="$batchnumber"/>
      </sql:query>
    </sql:execute-query>
  </xsl:template>
</xsl:stylesheet>