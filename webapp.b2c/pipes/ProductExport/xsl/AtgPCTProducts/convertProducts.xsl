<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
                xmlns:data="http://www.philips.com/cmc2-data"
                exclude-result-prefixes="sql xsl cinclude data" 
            >
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!--  base the transformation on the default xUCDM transformation -->
  <xsl:import href="../xUCDM.1.2.convertProducts.xsl" />
  <!--  -->
  <xsl:param name="doctypesfilepath"/>
  <xsl:param name="type"/>
  <xsl:param name="channel"/>
  <!--  no selection needed: the assetchannel is for ATG -->
  <xsl:variable name="assetschannel">ATG_PCT</xsl:variable>
  <!--  -->
  <xsl:variable name="doctypes" select="document($doctypesfilepath)/doctypes"/>
  <xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>
  <xsl:variable name="nonimagepath" select="'http://www.p4c.philips.com/cgi-bin/dcbint/get?id='"/>
  
  <xsl:template name="doKeyValuePairs">
    <xsl:choose>
      <xsl:when test="$type = 'locale'">
        <xsl:apply-templates select="ProductImage" />
        <xsl:apply-templates select="HasSoftwareAsset" />
      </xsl:when>
      <xsl:when test="$type = 'masterlocale'"> <!-- Not relevant -->
        <!-- use PMT/PCT -->
        <xsl:apply-templates select="../../sql:pmt/Product/ProductImage" />
        <xsl:apply-templates select="../../sql:pmt/Product/HasSoftwareAsset" />
      </xsl:when>
      <xsl:when test="$type = 'master'">
        <!-- use PMT_Master -->
        <xsl:apply-templates select="ProductImage" />
        <xsl:apply-templates select="HasSoftwareAsset" />
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="ProductImage">
    <KeyValuePair>
      <Key>ProductImage</Key>
      <Value><xsl:value-of select="."/></Value>
      <Type>String</Type>
    </KeyValuePair>
  </xsl:template>

  <xsl:template match="HasSoftwareAsset">
    <KeyValuePair>
      <Key>HasSoftwareAsset</Key>
      <Value><xsl:value-of select="if (.='Y') then 'true' else 'false'"/></Value>
      <Type>Boolean</Type>
    </KeyValuePair>
  </xsl:template>
</xsl:stylesheet>