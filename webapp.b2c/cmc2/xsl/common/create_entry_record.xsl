<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:cmc2-f="http://www.philips.com/cmc2-f"
    extension-element-prefixes="cmc2-f">

  <xsl:param name="o" />
  <xsl:param name="ct" />
  <xsl:param name="l" />
  <xsl:param name="ts" />
  <xsl:param name="reload" />
  <xsl:param name="runmode" select="''" />

  <xsl:include href="cmc2.function.xsl" />

  <xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)" />

  <xsl:template match="/">
    <entry o="{$o}" ct="{$ct}" l="{$l}" valid="true">
      <result>OK</result>
      <content />
      <xsl:choose>
        <xsl:when test="$reload='true'">
          <currentmasterlastmodified_ts>
            <sql:execute-query>
              <sql:query>
                select TO_CHAR(masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
                from octl 
                where content_type='<xsl:value-of select="$ct" />'
                  and localisation='<xsl:value-of select="$l" />'
                  and object_id='<xsl:value-of select="$o" />'
              </sql:query>
            </sql:execute-query>
          </currentmasterlastmodified_ts>
          <currentlastmodified_ts>
            <sql:execute-query>
              <sql:query>
                select TO_CHAR(lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts
                from octl
                where content_type='<xsl:value-of select="$ct" />'
                  and localisation='<xsl:value-of select="$l" />'
                  and object_id='<xsl:value-of select="$o" />'
              </sql:query>
            </sql:execute-query>
          </currentlastmodified_ts>
        </xsl:when>
        <xsl:otherwise>
          <currentlastmodified_ts />
          <currentmasterlastmodified_ts />
        </xsl:otherwise>
      </xsl:choose>
      <currentcontent />
      <newcontent />
      <process />
      <octl-attributes>
        <lastmodified_ts><xsl:value-of select="if ($reload='true') then () else $processTimestamp" /></lastmodified_ts>
        <masterlastmodified_ts />
      </octl-attributes>
      <store-outputs />
    </entry>
  </xsl:template>

</xsl:stylesheet>
