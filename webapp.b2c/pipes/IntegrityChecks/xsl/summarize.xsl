<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" exclude-result-prefixes="sql xsl source dir">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="dir"/>
	<xsl:param name="channel"/>
	<xsl:param name="exportdate"/>
	<!-- -->
	<xsl:template match="/root">
    <root>
    <!--
    <xsl:for-each-group select="root/Partner" group-by="concat(PartnerBrandCode,',',PartnerBrandName,',',PartnerBrandType,',',PartnerProductName)">
        <xsl:for-each select="current-group()">
          <xsl:if test="position() = 1 ">
            <xsl:copy-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each-group>     
      -->
      <xsl:copy-of select="."/>
    </root>
	</xsl:template>
</xsl:stylesheet>
