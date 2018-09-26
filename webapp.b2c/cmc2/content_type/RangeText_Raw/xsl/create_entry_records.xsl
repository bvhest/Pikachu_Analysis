<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:cmc2-f="http://www.philips.com/cmc2-f" 
    extension-element-prefixes="cmc2-f">
    
  <xsl:param name="ct" />
  <xsl:param name="l" />
  <xsl:param name="ts" />
  <xsl:param name="dir" />
  <xsl:param name="batchnumber" />
  
  <xsl:include href="../../../xsl/common/cmc2.function.xsl" />
  
  <xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)" />
  <xsl:variable name="DocTimeStamp" select="/*/@DocTimeStamp" />
  <xsl:variable name="localisation" select="'none'" />

  <xsl:template match="node()|@*" mode="copy">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="copy" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Node/@code" mode="copy">
    <xsl:attribute name="{local-name()}" select="upper-case(.)" />
  </xsl:template>

  <xsl:template match="Node/@nodeType" mode="copy">
    <xsl:attribute name="{local-name()}" select="lower-case(.)" />
  </xsl:template>

  <xsl:template match="/RangeText_Raw">
    <entries ct="{$ct}" l="{$l}" ts="{$ts}" dir="{$dir}" batchnumber="{$batchnumber}" valid="true">
      <process />
      <globalDocs />
      <xsl:apply-templates select="Nodes/Node" />
    </entries>
  </xsl:template>

  <xsl:template match="/Nodes">
    <entries ct="{$ct}" l="{$l}" ts="{$ts}" dir="{$dir}" batchnumber="{$batchnumber}" valid="true">
      <process />
      <globalDocs />
      <xsl:apply-templates select="Node" />
    </entries>
  </xsl:template>  

  <xsl:template match="ProductRefs" mode="copy">
    <xsl:copy copy-namespaces="no">
      <!-- Merge ProductReferences from direct children and old format -->
      <xsl:for-each-group select="ProductReference[CTN]|../ProductReferences/ProductReference[CTN]" group-by="@ProductReferenceType">
        <ProductReference ProductReferenceType="{current-grouping-key()}">
          <xsl:for-each select="current-group()/CTN">
            <CTN>
              <xsl:attribute name="rank" select="if (exists(@rank)) then 
                                                   @rank 
                                                 else if (exists(following-sibling::ProductReferenceRank)) then
                                                   following-sibling::ProductReferenceRank/text()
                                                 else 
                                                   position()" />
              <xsl:value-of select="." />
            </CTN>
          </xsl:for-each>
        </ProductReference>
      </xsl:for-each-group>
      
      <xsl:apply-templates select="ProductReference[Product]" mode="copy"/>
    </xsl:copy>    
  </xsl:template>
  
  <xsl:template match="ProductReferences" mode="#all" />
  <xsl:template match="Keywords" mode="#all" />
  
  <!-- -->
  <xsl:template match="Node">
    <xsl:variable name="objectId" select="upper-case(@code)" />
    <xsl:variable name="masterLastmodifiedTimestamp" select="substring($DocTimeStamp,1,19)" />
    <xsl:variable name="status" select="MarketingStatus" />
    <entry o="{$objectId}" ct="{$ct}" l="{$localisation}" valid="true">
      <result>OK</result>
      <content>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()" mode="copy" />
        </xsl:copy>
      </content>
      <currentmasterlastmodified_ts>
        <sql:execute-query>
          <sql:query>
            select TO_CHAR(masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
            from octl where content_type='<xsl:value-of select="$ct" />'
            and localisation='<xsl:value-of select="$localisation" />'
            and object_id='<xsl:value-of select="$objectId" />'
          </sql:query>
        </sql:execute-query>
      </currentmasterlastmodified_ts>
      <currentlastmodified_ts />
      <process />
      <!-- This will only be ran when this entry is valid. Therefore, using importExecDelta-->
      <octl-attributes>
        <lastmodified_ts>
          <xsl:value-of select="$processTimestamp" />
        </lastmodified_ts>
        <masterlastmodified_ts>
          <xsl:value-of select="$masterLastmodifiedTimestamp" />
        </masterlastmodified_ts>
        <status>
          <xsl:value-of select="$status" />
        </status>
      </octl-attributes>
      <store-outputs />
    </entry>
  </xsl:template>

</xsl:stylesheet>
