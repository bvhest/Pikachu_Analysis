<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"                 
                xmlns:cmc2-f="http://www.philips.com/cmc2-f" 
                extension-element-prefixes="cmc2-f" >

  <xsl:param name="ct"/>
  <xsl:param name="ts"/>
  <xsl:param name="dir"/>
  <xsl:param name="batchnumber"/>
  <xsl:param name="reload"/>  
  
  <xsl:include href="../../../xsl/common/cmc2.function.xsl"/>
  
  <xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)" />
  <xsl:variable name="DocTimeStamp" select="substring(string(adjust-dateTime-to-timezone(xs:dateTime(/Products/@DocTimeStamp))),1,19)"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>   
	    
  <xsl:template match="/Products">
    <xsl:apply-templates/>
  </xsl:template>    
      
  <xsl:template match="@masterLastModified|@lastModified">
    <xsl:attribute name="{local-name()}" select="$DocTimeStamp"/>
  </xsl:template>    
      
  <xsl:template match="Product">
    <xsl:variable name="masterLastmodifiedTimestamp" select="$DocTimeStamp"/>
    <xsl:variable name="objectId" select="CTN"/>
    <xsl:variable name="status" select="if (string(@status) != '') then string(@status) else 'Loaded'"/>
    <xsl:variable name="l" select="@Locale"/>
    <entry o="{$objectId}" ct="{$ct}" l="{$l}" valid="true">
      <result>OK</result>
      <content>
        <xsl:copy copy-namespaces="no">
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </content>
      <currentmasterlastmodified_ts>
        <sql:execute-query>
          <sql:query>
            select TO_CHAR(masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
            from octl where content_type='<xsl:value-of select="$ct"/>'
            and localisation='<xsl:value-of select="$l"/>'
            and object_id='<xsl:value-of select="$objectId"/>'
          </sql:query>
        </sql:execute-query>
      </currentmasterlastmodified_ts>
      <currentlastmodified_ts>
        <sql:execute-query>
          <sql:query>
            select TO_CHAR(lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts                             
            from octl where content_type='<xsl:value-of select="$ct"/>'
            and localisation='<xsl:value-of select="$l"/>'
            and object_id='<xsl:value-of select="$objectId"/>'
          </sql:query>
        </sql:execute-query>
      </currentlastmodified_ts>
      <process/>
      <secondary/>
      <octl-attributes>
        <lastmodified_ts><xsl:value-of select="$processTimestamp"/></lastmodified_ts>
        <masterlastmodified_ts><xsl:value-of select="$masterLastmodifiedTimestamp"/></masterlastmodified_ts>
        <status><xsl:value-of select="$status"/></status>
      </octl-attributes>
    </entry>
  </xsl:template>
</xsl:stylesheet>
