<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
        xmlns:sql="http://apache.org/cocoon/SQL/2.0"
        >
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="ct"/>
  <xsl:param name="ts"/>
  <xsl:variable name="runts" select="concat(substring($ts,1,4),'-',substring($ts,5,2),'-',substring($ts,7,2),'T',substring($ts,9,2),':',substring($ts,11,2),':',substring($ts,13,2))"/>
  <xsl:param name="dir"/>
  <xsl:param name="filename"/>
  <xsl:param name="batch"/>
  <xsl:param name="subbatch"/>
  <!-- -->    
  <xsl:template match="Nodes">
    <entries  ct="{$ct}" l="{@l}" ts="{$ts}" dir="{$dir}" batchnumber="{$batch}" subbatchnumber="{$subbatch}" category="{@category}" division="{@division}">
      <xsl:copy-of select="originalentriesattributes"/>
      <xsl:apply-templates select="Node"/>
    </entries>
  </xsl:template>  
  <!-- -->  
  <xsl:template match="Node">
    <xsl:variable name="objectId" select="@code"/>
    <xsl:variable name="status" select="MarketingStatus"/>
    <entry o="{$objectId}"  ct="{$ct}" l="{../@targetLocale}" valid="true" resetflagsonfailure="false">
      <result>OK</result>
      <content>
        <xsl:copy-of copy-namespaces="no" select="."/>
      </content>
      <currentlastmodified_ts>
        <sql:execute-query>
          <sql:query>
              select TO_CHAR(lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts 
              from octl where content_type='<xsl:value-of select="$ct"/>' 
              and localisation='<xsl:value-of select="../@targetLocale"/>' 
              and object_id='<xsl:value-of select="$objectId"/>'
          </sql:query>
        </sql:execute-query>
      </currentlastmodified_ts>
      <currentmasterlastmodified_ts>
        <sql:execute-query>
          <sql:query>
              select TO_CHAR(masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts 
              from octl where content_type='<xsl:value-of select="$ct"/>' 
              and localisation='<xsl:value-of select="../@targetLocale"/>' 
              and object_id='<xsl:value-of select="$objectId"/>'
          </sql:query>
        </sql:execute-query>
      </currentmasterlastmodified_ts>
      <currentcontent/>
      <newcontent/>
      <process/>
      <octl-attributes>
        <lastmodified_ts><xsl:value-of select="@lastModified"/></lastmodified_ts>
        <masterlastmodified_ts><xsl:value-of select="@masterLastModified"/></masterlastmodified_ts>
        <remark><xsl:value-of select="$filename"/></remark>
        <status><xsl:value-of select="$status"/></status>
        <needsprocessing_flag><xsl:value-of select="'-1'"/></needsprocessing_flag>
      </octl-attributes>
    </entry>      
  </xsl:template>  
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
