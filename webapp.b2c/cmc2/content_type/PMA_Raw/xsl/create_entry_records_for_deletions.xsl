<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
 xmlns:cmc2-f="http://www.philips.com/cmc2-f" extension-element-prefixes="cmc2-f" >
  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:param name="ts"/>
  <xsl:param name="dir"/>
  <xsl:param name="batchnumber"/>
  <xsl:include href="../../../xsl/common/cmc2.function.xsl"/>
  <!-- -->
  <xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)" />
  <!-- -->
  <xsl:template match="entries">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>      
      <xsl:apply-templates select="process"/>      
      <xsl:apply-templates select="entry"/>      
      <xsl:variable name="incoming-ids"><xsl:for-each select="entry/@o"><o><xsl:value-of select="."/></o></xsl:for-each></xsl:variable>
      <xsl:variable name="stored-ids"><xsl:for-each select="globalDocs/currentcontent/sql:rowset/sql:row/sql:object_id"><o><xsl:value-of select="."/></o></xsl:for-each></xsl:variable>
      <xsl:for-each select="$stored-ids/o">
        <xsl:if test="not($incoming-ids/o[.=current()])">
          <xsl:variable name="o" select="."/>          
          <entry o="{$o}" ct="{$ct}" l="{$l}" valid="true">
            <result>OK</result>
            <content>
              <object o="{$o}" l="{$l}">
                <Awards/>
              </object>
            </content>
            <store-outputs/>
            <currentmasterlastmodified_ts>
              <sql:execute-query>
                <sql:query>
                  select TO_CHAR(masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
                  from octl where content_type='<xsl:value-of select="$ct"/>'
                  and localisation='<xsl:value-of select="$l"/>'
                  and object_id='<xsl:value-of select="$o"/>'
                </sql:query>
              </sql:execute-query>
            </currentmasterlastmodified_ts>
            <currentlastmodified_ts/>
            <octl-attributes>
              <lastmodified_ts><xsl:value-of select="$processTimestamp"/></lastmodified_ts>
              <masterlastmodified_ts><xsl:value-of select="$processTimestamp"/></masterlastmodified_ts>
              <status>Loaded</status>
            </octl-attributes>
          </entry>     
        </xsl:if>          
      </xsl:for-each>
      <xsl:apply-templates select="globalDocs"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->    
  <xsl:template match="globalDocs/currentrelations">
    <xsl:element name="{local-name()}">
      <xsl:for-each select="sql:rowset/sql:row">
        <relation>
          <xsl:apply-templates mode="strip-sql"/>
        </relation>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  <!-- -->
  <xsl:template match="globalDocs/currentcontent">
    <xsl:element name="{local-name()}">
      <xsl:for-each select="sql:rowset/sql:row">
        <octl>
          <xsl:apply-templates mode="strip-sql"/>
        </octl>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  <!-- -->
  <xsl:template match="globalDocs/currentoctls">
    <xsl:element name="{local-name()}">
      <xsl:attribute name="content_type" select="@content_type"/>
      <xsl:for-each select="sql:rowset/sql:row">
        <xsl:apply-templates mode="strip-sql"/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:*" mode="strip-sql">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="node()|@*" mode="strip-sql"/>
    </xsl:element>
  </xsl:template>
  <!-- -->
  <xsl:template match="node()|@*" mode="strip-sql">
      <xsl:copy>
      <xsl:apply-templates select="node()|@*" mode="strip-sql"/>
      </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>