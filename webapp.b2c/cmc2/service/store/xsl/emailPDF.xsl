<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:email="http://apache.org/cocoon/transformation/sendmail">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="dir"/>
  <xsl:param name="sender"/>
  <xsl:param name="server"/>
  <!--  -->
  <xsl:template match="/">
    <root>
      <xsl:apply-templates/>
    </root>
  </xsl:template>
  <!--  -->
  <xsl:template match="entry[string-length(content/PackagingProjectTranslations/@addressee) &gt; 0]">
    <xsl:variable name="recipient" select="content/PackagingProjectTranslations/@addressee"/>
    <xsl:variable name="docStatus" select="octl-attributes/status"/>
    <xsl:choose>
      <xsl:when test="@valid='true'">
        <document>
          <email:sendmail>
            <email:from><xsl:value-of select="'central.marketing.support@philips.com'"/></email:from>
            <email:to><xsl:value-of select="$recipient"/></email:to>
            <!--email:to><xsl:value-of select="'addanotherrecipienthere@philips.com'"/></email:to-->
            <email:subject><xsl:value-of select="concat('Packaging Translation Brief for CTN ',replace(substring-after(@o,'PP_'),'_','/'))"/></email:subject>

            <email:attachment name="{concat(@ct,'.',@o,'.', $docStatus/text(),'.',@l,'.pdf')}" mime-type="application/pdf" src="{concat($dir,'/',@ct,'/outbox/',@ct,'.',@o,'.', $docStatus/text(),'.',@l,'.pdf')}"/>
            <email:body mime-type="text/plain">
Dear colleague,

Please find attached the available translations for packaging in PDF format.
Document Name: <xsl:value-of select="concat(@ct,'.',@o,'.', $docStatus/text(),'.',@l,'.pdf')"/>
Document Status: <xsl:value-of select="content/PackagingProjectTranslations/@docStatus"/>
Document Date: <xsl:value-of select="replace(content/PackagingProjectTranslations/@docTimeStamp,'T',' ')"/>

<xsl:if test="$docStatus = 'PRELIMINARY'"><xsl:text>

Note: Some translations are still in progress.</xsl:text></xsl:if>
<!--
<xsl:copy-of select="."/>
-->
</email:body>
          </email:sendmail>
        </document>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
