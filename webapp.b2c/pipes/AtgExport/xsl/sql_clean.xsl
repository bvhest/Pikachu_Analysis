<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql">

<xsl:variable name="globalnodes" select="('Concept','Family','Range','Descriptor','KeyBenefitArea','Feature','FeatureLogo','FeatureHighlight','FeatureImage','CSChapter','CSItem','CSValue','AccessoryByPacked','Award','ConsumerSegment')"/>
  <!--  -->
  <xsl:template match="sql:*"/>
  <xsl:template match="@*|node()">
    <xsl:param name="localizednodescodes"/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()">
        <xsl:with-param name="localizednodescodes" select="$localizednodescodes"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  <!--  -->
  <xsl:template match="Product">
    <xsl:variable name="localizednodes" select="descendant::*[local-name()=$globalnodes][element()[ends-with(local-name(),'Code')]][child::*[attribute::localized='1']]"/>
    <xsl:variable name="localizednodescodes">
      <xsl:for-each select="$localizednodes/*[ends-with(local-name(),'Code')]">
        <id><xsl:value-of select="."/></id>
      </xsl:for-each>
    </xsl:variable>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*">
        <xsl:with-param name="localizednodescodes" select="$localizednodescodes"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="element()[local-name() = $globalnodes]/element()[ends-with(local-name(),'Code')]">
    <xsl:param name="localizednodescodes"/>
    <xsl:variable name="ctn" select="replace(ancestor::Product/CTN,'/','_')"/>
    <xsl:copy copy-namespaces="no">
      <xsl:choose>
        <xsl:when test=". = $localizednodescodes/id">
          <xsl:value-of select="if(contains(.,$ctn)) then concat(.,'_L1') else concat(.,'_',$ctn,'_L')"/>
          <xsl:apply-templates select="@*|element()">
            <xsl:with-param name="localizednodescodes" select="$localizednodescodes"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="@*|node()">
            <xsl:with-param name="localizednodescodes" select="$localizednodescodes"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
