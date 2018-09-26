<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" exclude-result-prefixes="sql xsl source dir">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="dir"/>
	<xsl:param name="channel"/>
	<xsl:param name="exportdate"/>
	<!-- -->
	<xsl:template match="/dir:directory">
    <root>
  	  <xsl:for-each-group select="dir:file/dir:xpath/Product/NamingString/Partner" group-by="concat(PartnerBrand/BrandCode,',',PartnerBrandType,',',PartnerProductName)">
        <xsl:for-each select="current-group()">
          <xsl:if test="position() = 1 ">
            <Partner>
              <PartnerBrandCode><xsl:value-of select="PartnerBrand/BrandCode"/></PartnerBrandCode>
              <PartnerBrandName><xsl:value-of select="PartnerBrand/BrandName"/></PartnerBrandName>
              <PartnerBrandType><xsl:value-of select="PartnerBrandType"/></PartnerBrandType>
              <PartnerProductName><xsl:value-of select="PartnerProductName"/></PartnerProductName>
            </Partner>  
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each-group>     
    </root>
	</xsl:template>
	<!-- -->
  <!--
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
  -->
</xsl:stylesheet>
