<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"                 
                xmlns:cmc2-f="http://www.philips.com/cmc2-f"
                xmlns:b2b="http://pww.pikachu.philips.com/b2b/function/1.0"
                exclude-result-prefixes="xs source" 
                extension-element-prefixes="cmc2-f b2b">

  <xsl:import href="../../../xsl/common/xucdm_treenode_marketing_1_2_normalize.xsl"/>
  <xsl:include href="../../../xsl/common/cmc2.function.xsl"/>
  <xsl:include href="../../../xsl/common/b2b.functions.xsl"/>
  <!-- -->
  <xsl:param name="ct"/>
  <xsl:param name="ts"/>
  <xsl:param name="dir"/>
  <xsl:param name="batchnumber"/>
  <xsl:param name="reload"/>  
  <!-- -->
  <xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)" />
  <xsl:variable name="DocTimeStamp" select="substring(string(adjust-dateTime-to-timezone(xs:dateTime(/Nodes/@DocTimeStamp))),1,19)"/>
  <!-- -->
  <xsl:template match="node()|@*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template> 
  <!-- Convert AwardCode to uppercase -->  
  <xsl:template match="AwardCode">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="upper-case(.)"/>
    </xsl:copy>
  </xsl:template>   
  <!-- -->  
  <xsl:template match="/Nodes">
    <xsl:apply-templates/>
  </xsl:template>    
  <!-- -->    
  <xsl:template match="@masterLastModified|@lastModified">
    <xsl:attribute name="{local-name()}" select="$DocTimeStamp"/>
  </xsl:template>    
  <!-- -->    
  <xsl:template match="Node">
    <xsl:variable name="masterLastmodifiedTimestamp" select="$DocTimeStamp"/>
    <xsl:variable name="objectId" select="b2b:fix-family-code(@code)"/>
    <xsl:variable name="MarketingVersion" select="MarketingVersion"/>
    <xsl:variable name="status" select="MarketingStatus"/>
    <xsl:variable name="l" select="@Locale"/>
    <entry o="{$objectId}" ct="{$ct}" l="{$l}" valid="true">
      <result>OK</result>
      <content>
        <xsl:apply-imports/>
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
      <currentmarketingversion>
        <sql:execute-query>
          <sql:query>
            select marketingversion                             
            from octl where content_type='<xsl:value-of select="$ct"/>'
            and localisation='<xsl:value-of select="$l"/>'
            and object_id='<xsl:value-of select="$objectId"/>'
          </sql:query>
        </sql:execute-query>
      </currentmarketingversion>     
      <process/>
      <octl-attributes>
        <lastmodified_ts><xsl:value-of select="$processTimestamp"/></lastmodified_ts>
        <masterlastmodified_ts><xsl:value-of select="$masterLastmodifiedTimestamp"/></masterlastmodified_ts>
        <status><xsl:value-of select="$status"/></status>
        <marketingversion><xsl:value-of select="$MarketingVersion"/></marketingversion>
      </octl-attributes>
    </entry>
  </xsl:template>
  
  <!-- Fix family code. See b2b.functions.xsl -->
  <xsl:template match="Node/@code">
    <xsl:attribute name="code" select="b2b:fix-family-code(.)"/>
  </xsl:template>
  
</xsl:stylesheet>