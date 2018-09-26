<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:pms-f="http://www.philips.com/pika/pms/1.0"
  exclude-result-prefixes="sql"
  extension-element-prefixes="pms-f">
  
  <xsl:import href="pms.functions.xsl"/>
  
  <!--  -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*" />  
    </xsl:copy>
  </xsl:template>
  
  <!-- -->
  <xsl:template match="Product/SignerId" />
  <xsl:template match="Product/SignerName" />

	<!-- 2010-08-10, JWE: force Asset id to contain CTN 
		Can be removed when all assets have been regenerated (most of the time they're not refreshed
		when PMS is updated)
	-->
	<xsl:template match="Assets/Asset/id">
		<id>
			<xsl:value-of select="../../../MasterData/CTN"/>
		</id>
	</xsl:template>

  <xsl:template match="Product">
    <xsl:variable name="CTN" select="/entry/@o"/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates /> 
      <SignerId>
        <xsl:variable name="OldSignerId" select="SignerId"/>
        <xsl:variable name="NewSignerId" select="pms-f:product-signer-id($CTN)"/>
        
        <xsl:choose>
          <xsl:when test="$NewSignerId != ''">
            <xsl:value-of select="$NewSignerId"/>
          </xsl:when>
          <xsl:otherwise>
          	<xsl:value-of select="$OldSignerId"/>
          </xsl:otherwise>
        </xsl:choose>
      </SignerId>
      <SignerName>
        <xsl:variable name="OldSignerName" select="SignerName"/>
        <xsl:variable name="NewSignerName" select="pms-f:product-signer-name($CTN)"/>
        
        <xsl:choose>
          <xsl:when test="$NewSignerName != ''">
            <xsl:value-of select="$NewSignerName"/>
          </xsl:when>
          <xsl:otherwise>
          	<xsl:value-of select="$OldSignerName"/>
          </xsl:otherwise>
        </xsl:choose>
      </SignerName>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
