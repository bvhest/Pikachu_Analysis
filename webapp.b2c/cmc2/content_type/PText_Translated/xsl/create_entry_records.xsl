<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
        xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="ct"/>
  <xsl:param name="ts"/>
  <xsl:param name="dir"/>
  <xsl:param name="batch"/>
  <!-- -->
  <xsl:template match="/">
    <entries  ct="{$ct}" l="{PackagingText[1]/@languageCode}" ts="{$ts}" dir="{$dir}" batchnumber="{$batch}" division='CE' category="{PackagingText[1]/@category}" workflow="{PackagingText[1]/@workflow}">
      <xsl:copy-of select="PackagingText[1]/originalentriesattributes"/>    
      <xsl:apply-templates select="PackagingText"/>
    </entries>
  </xsl:template>  
  <!-- -->
  <xsl:template match="PackagingText">
    <!-- the content type will not be known in the file so is passed in-->
    <xsl:variable name="objectId" select="@code"/>
    <entry o="{$objectId}"  ct="{$ct}" l="{@targetLocale}" valid="true">
      <result>OK</result>
      <content>
        <xsl:copy-of copy-namespaces="no" select="."/>
      </content>
      <currentlastmodified_ts>
        <sql:execute-query>
          <sql:query>
            select TO_CHAR(lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts 
            from octl where content_type='<xsl:value-of select="$ct"/>' 
            and localisation='<xsl:value-of select="@targetLocale"/>' 
            and object_id='<xsl:value-of select="$objectId"/>'
          </sql:query>
        </sql:execute-query>
      </currentlastmodified_ts>
      <currentmasterlastmodified_ts>
        <sql:execute-query>
          <sql:query>
              select TO_CHAR(masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts 
              from octl where content_type='<xsl:value-of select="$ct"/>' 
              and localisation='<xsl:value-of select="@targetLocale"/>' 
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
        <status>Loaded</status>
        <counterpartstatus>
          <sql:execute-query>
            <sql:query>
                select workflow, valid, result
                from octl_translations where content_type='<xsl:value-of select="$ct"/>' 
                and localisation='<xsl:value-of select="@targetLocale"/>' 
                and object_id='<xsl:value-of select="$objectId"/>'
                and masterlastmodified_ts=to_date('<xsl:value-of select="@masterLastModified"/>','yyyy-mm-dd"T"hh24:mi:ss')
                and lastmodified_ts=to_date('<xsl:value-of select="@lastModified"/>','yyyy-mm-dd"T"hh24:mi:ss')
                and workflow != '<xsl:value-of select="@workflow"/>'
            </sql:query>
          </sql:execute-query>
        </counterpartstatus>            
      </octl-attributes>
    </entry>
  </xsl:template>  
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
</xsl:stylesheet>