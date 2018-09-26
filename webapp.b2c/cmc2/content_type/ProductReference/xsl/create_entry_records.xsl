<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
 xmlns:cmc2-f="http://www.philips.com/cmc2-f" extension-element-prefixes="cmc2-f" >
  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:param name="ts"/>
  <xsl:param name="dir"/>
  <xsl:param name="batchnumber"/>
  <xsl:param name="reload"/>  
  <!-- -->
  <xsl:include href="../../../xsl/common/cmc2.function.xsl"/>
  <!-- -->
  <xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)" />
  <!-- -->
  <xsl:template match="/ProductReferences">
     <entries ct="{$ct}" l="none" ts="{$ts}" dir="{$dir}" batchnumber="{$batchnumber}" valid="true">
		  <process/>
		  <globalDocs/>
      <xsl:apply-templates select="ProductReferenceObject"/>
         </entries>
  </xsl:template>
  <!-- -->
  <xsl:template match="ProductReferenceObject">
    <xsl:variable name="masterLastmodifiedTimestamp" select="substring(@lastModified,1,19)"/>
    <xsl:variable name="objectId" select="CTN"/>
    <xsl:variable name="status" select="'Loaded'"/>
    <entry o="{$objectId}"  ct="{$ct}" l="none"  valid="true">
      <result>OK</result>
      <content>
        <xsl:copy-of select="."/>
      </content>
      <currentmasterlastmodified_ts>
        <sql:execute-query>
          <sql:query>
            select TO_CHAR(masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
            from octl where content_type='<xsl:value-of select="$ct"/>'
            and localisation='none'
            and object_id='<xsl:value-of select="$objectId"/>'
          </sql:query>
        </sql:execute-query>
      </currentmasterlastmodified_ts>
      <currentlastmodified_ts>
        <sql:execute-query>
          <sql:query>
            select TO_CHAR(lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts                             
            from octl where content_type='<xsl:value-of select="$ct"/>'
            and localisation='none'
            and object_id='<xsl:value-of select="$objectId"/>'
          </sql:query>
        </sql:execute-query>
      </currentlastmodified_ts>
      <currentmarketingversion/>
      <process/>
      <octl-attributes>
        <xsl:choose>
          <xsl:when test="not($reload='true')">
            <lastmodified_ts><xsl:value-of select="$processTimestamp"/></lastmodified_ts>
            <masterlastmodified_ts><xsl:value-of select="$masterLastmodifiedTimestamp"/></masterlastmodified_ts>
          </xsl:when>
          <xsl:otherwise>
            <lastmodified_ts/>
            <masterlastmodified_ts/>
          </xsl:otherwise>          
        </xsl:choose>
        <status><xsl:value-of select="$status"/></status>
        <marketingversion/>
      </octl-attributes>
    </entry>
  </xsl:template>
</xsl:stylesheet>
