<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
 xmlns:cmc2-f="http://www.philips.com/cmc2-f" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="cmc2-f" >
  <xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:param name="ts"/>
  <xsl:param name="dir"/>
  <xsl:include href="../../../xsl/common/cmc2.function.xsl"/>
  	<xsl:variable name="fd">
		<xsl:text>|</xsl:text>
	</xsl:variable>
	<xsl:variable name="rd">
		<xsl:text>&#x0A;</xsl:text>
	</xsl:variable>
  <!-- -->
  <xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)" />
  <!-- -->
  <xsl:template match="/KeyValuePairs">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="object">
    <xsl:apply-templates select="@*|node()">
      <xsl:with-param name="mlm" select="@masterLastModified"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="KeyValuePair">
    <xsl:param name="mlm"/>
    <!--xsl:value-of select="string-join((CTN,Key,Value,Type,UnitOfMeasure,'ACTIVE',$mlm),'|')"/-->
    <!--xsl:value-of select="string-join((../@object_id,Key,Value,Type,UnitOfMeasure,$mlm,upper-case(@action)),'|')"/>| -->
     <xsl:value-of select="concat(../@object_id,$fd,Key,$fd,Value,$fd,Type,$fd,UnitOfMeasure,$fd,$mlm,$rd)"/>
</xsl:template>
</xsl:stylesheet>
