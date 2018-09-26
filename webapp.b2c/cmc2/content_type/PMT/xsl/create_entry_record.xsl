<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:cmc2-f="http://www.philips.com/cmc2-f"
    extension-element-prefixes="cmc2-f">

  <xsl:param name="ct" />
  <xsl:param name="ts" />
  <xsl:param name="reload" />
  <xsl:param name="runmode" select="''"/>
  
  <xsl:import href="base.xsl"/>
  <xsl:include href="../../../xsl/common/cmc2.function.xsl" />
  
  <xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)" />

  <xsl:template match="@*|node()" mode="#all">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="/entries">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates select="octl[@ct='PMT_Translated']/sql:rowset/sql:row" />
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <!--xsl:template match="entries/octl[not(@ct='PMT_Translated')]"/-->
  <xsl:template match="entries/octl[@ct='PMT_Translated']/sql:rowset/sql:row">
    <xsl:variable name="o" select="sql:object_id" />
    <xsl:variable name="l" select="sql:localisation" />
    <entry o="{$o}" ct="{$ct}" l="{$l}" valid="true">
      <result>OK</result>
      <content>
        <octl ct="PMT_Translated">
          <sql:rowset>
            <xsl:next-match />
          </sql:rowset>
        </octl>        
        <octl ct="PMT_LocContent">
          <sql:rowset>
            <xsl:apply-templates select="ancestor::entries/octl[@ct='PMT_LocContent']/sql:rowset/sql:row[sql:object_id = current()/sql:object_id and sql:localisation = current()/sql:localisation]" mode="copy"/>            
          </sql:rowset>
        </octl>        
        <octl ct="PMT_Master">
          <sql:rowset>
            <xsl:apply-templates select="ancestor::entries/octl[@ct='PMT_Master']/sql:rowset/sql:row[sql:object_id = current()/sql:object_id]" />
          </sql:rowset>
        </octl>
        <octl ct="AssetList">
          <sql:rowset>        
            <xsl:if test="$l-master-assets-from = 'assetlist'">
              <xsl:apply-templates select="ancestor::entries/octl[@ct='AssetList']/sql:rowset/sql:row[sql:object_id = current()/sql:object_id and sql:localisation = 'master_global']" mode="copy"/>
            </xsl:if>
            <xsl:apply-templates select="ancestor::entries/octl[@ct='AssetList']/sql:rowset/sql:row[sql:object_id = current()/sql:object_id and sql:localisation = current()/sql:localisation]" mode="copy"/>
          </sql:rowset>        
        </octl>
        <octl ct="GreenData">
          <sql:rowset>
            <xsl:apply-templates select="ancestor::entries/octl[@ct='GreenData']/sql:rowset/sql:row[sql:object_id = current()/sql:object_id]" />
          </sql:rowset>
        </octl>
      </content>
      <xsl:choose>
        <xsl:when test="$reload='true'">
          <currentmasterlastmodified_ts>
            <xsl:value-of select="ancestor::entries/octl[@ct='PMT']/sql:rowset/sql:row[sql:object_id = current()/sql:object_id and sql:localisation = current()/sql:localisation]/sql:masterlastmodified_ts"/>
          </currentmasterlastmodified_ts>
          <currentlastmodified_ts>
            <xsl:value-of select="ancestor::entries/octl[@ct='PMT']/sql:rowset/sql:row[sql:object_id = current()/sql:object_id and sql:localisation = current()/sql:localisation]/sql:lastmodified_ts"/>
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
