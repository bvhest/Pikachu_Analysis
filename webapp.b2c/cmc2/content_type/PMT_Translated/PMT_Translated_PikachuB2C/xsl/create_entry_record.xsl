<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cmc2-f="http://www.philips.com/cmc2-f" extension-element-prefixes="cmc2-f">

  <xsl:param name="ct_in"/>
  <xsl:param name="ct_out"/>
  <xsl:param name="l_in"/>
  <xsl:param name="l_out"/>
  <xsl:param name="o"/>
  <xsl:param name="ts"/>
  <xsl:param name="svcURL"/>
  <!-- -->
  <xsl:include href="../../../../xsl/common/cmc2.function.xsl"/>
  <!-- -->
  <xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)" />
  <!-- -->
  <xsl:template match="/">

    <entry  o="{$o}"   ct="{$ct_out}"   l="{$l_out}" valid="true">
      <content>
        <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get/{$ct_in}/{$l_in}/{$o}"/>
      </content>
      <result>OK</result>
      <currentmasterlastmodified_ts/>
      <currentcontent/>
      <newcontent/>
      <process/>
      <octl-attributes>
        <lastmodified_ts><xsl:value-of select="$processTimestamp"/></lastmodified_ts>
        <masterlastmodified_ts/>
      </octl-attributes>
    </entry>
  </xsl:template>
</xsl:stylesheet>