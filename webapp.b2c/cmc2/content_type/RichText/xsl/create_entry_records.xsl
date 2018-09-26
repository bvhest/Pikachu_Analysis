<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cmc2-f="http://www.philips.com/cmc2-f" extension-element-prefixes="cmc2-f">
	<xsl:param name="ct"/>
	<xsl:param name="ts"/>
	<xsl:param name="dir"/>
	<xsl:param name="batchnumber"/>
	<xsl:include href="../../../xsl/common/cmc2.function.xsl"/>
	<xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)"/>
	<xsl:variable name="DocTimeStamp" select="/RichText/@DocTimeStamp"/>
  <xsl:variable name="masterLastmodifiedTimestamp" select="substring($DocTimeStamp,1,19)"/>  
	
	<xsl:template match="/RichText">
    <xsl:variable name="objects"><objects><xsl:copy-of select="object"/></objects></xsl:variable>
    <xsl:for-each-group select="object" group-by="@l">
  		<entries ct="{$ct}" l="{@l}" ts="{$ts}" dir="{$dir}" batchnumber="{$batchnumber}" valid="true">
  			<process/>
  			<globalDocs/>			    
        <xsl:apply-templates select="$objects/objects/object[@l=current-grouping-key()]">
          <xsl:with-param name="locale" select="current-grouping-key()"/>
        </xsl:apply-templates>
      </entries>
    </xsl:for-each-group>      
  </xsl:template>
  
  <xsl:template match="object">
    <xsl:param name="locale"/>
    <entry o="{@object_id}" ct="{$ct}" l="{$locale}" valid="true">
      <result>OK</result>
      <content>
        <object>
          <id><xsl:value-of select="@object_id"/></id>
          <xsl:copy-of select="RichTexts"/>
        </object>
      </content>
      <currentmasterlastmodified_ts>
        <sql:execute-query>
          <sql:query>
            select TO_CHAR(masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
            from octl where content_type='<xsl:value-of select="$ct"/>'
            and localisation='<xsl:value-of select="$locale"/>'
            and object_id='<xsl:value-of select="@object_id"/>'
          </sql:query>
        </sql:execute-query>
      </currentmasterlastmodified_ts>
      <currentlastmodified_ts/>
      <process/>
      <!-- This will only be ran when this entry is valid. Therefore, using importExecDelta-->
      <octl-attributes>
        <lastmodified_ts>
          <xsl:value-of select="$processTimestamp"/>
        </lastmodified_ts>
        <masterlastmodified_ts>
          <xsl:value-of select="$masterLastmodifiedTimestamp"/>
        </masterlastmodified_ts>
        <status>Loaded</status>
      </octl-attributes>
      <store-outputs/>
    </entry>
	</xsl:template>
</xsl:stylesheet>
