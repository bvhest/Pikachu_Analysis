<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cmc2-f="http://www.philips.com/cmc2-f" extension-element-prefixes="cmc2-f">
  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:param name="ts"/>
  <xsl:param name="dir"/>
  <xsl:param name="batchnumber"/>
  <xsl:param name="mode"/>
  <xsl:include href="../../../xsl/common/cmc2.function.xsl"/>
  <xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)"/>
  <xsl:variable name="DocTimeStamp" select="/Localizations/@DocTimeStamp"/>
  <xsl:variable name="masterLastmodifiedTimestamp" select="substring($DocTimeStamp,1,19)"/>
  <xsl:variable name="contentType" select="$ct"/>
  <xsl:variable name="localisation" select="'none'"/>
  <xsl:variable name="status" select="'Loaded'"/>
  <!-- -->
  <xsl:template match="/Localizations">
    <entries ct="{$contentType}" l="{$localisation}" ts="{$ts}" dir="{$dir}" batchnumber="{$batchnumber}" valid="true">
      <process/>
      <globalDocs/>
      <xsl:apply-templates select="Localization"/>
    </entries>
  </xsl:template>
  <!-- -->
  <xsl:template match="Localization">
    <xsl:variable name="objectId" select="@code"/>
      <entry o="{$objectId}" ct="{$ct}" l="{$localisation}" valid="true">
        <result>OK</result>
        <content>
          <xsl:copy-of select="."/>
        </content>
        <xsl:if test="$mode='reprocessexistingcontent'">
          <currentrelations>
            <sql:rowset name="relations">
              <xsl:copy-of select="../currentrelations/sql:rowset/sql:row[sql:input_object_id=current()/@code]"/>
            </sql:rowset>
          </currentrelations>
        </xsl:if>
        <currentmasterlastmodified_ts>
          <sql:execute-query>
            <sql:query>
              select TO_CHAR(masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
              from octl where content_type='<xsl:value-of select="$ct"/>'
              and localisation='<xsl:value-of select="$localisation"/>'
              and object_id='<xsl:value-of select="$objectId"/>'
            </sql:query>
          </sql:execute-query>
        </currentmasterlastmodified_ts>
        <currentlastmodified_ts/>
        <process/>
        <octl-attributes>
          <lastmodified_ts>
              <xsl:value-of select="$processTimestamp"/>
          </lastmodified_ts>
          <masterlastmodified_ts>
              <xsl:value-of select="$masterLastmodifiedTimestamp"/>
          </masterlastmodified_ts>
        <status><xsl:value-of select="$status"/></status>
        </octl-attributes>
      <store-outputs/>
    </entry>
  </xsl:template>
</xsl:stylesheet>