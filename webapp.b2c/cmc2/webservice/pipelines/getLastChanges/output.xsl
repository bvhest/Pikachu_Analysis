<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
  <xsl:import href="../service-base.xsl" />

  <!-- Override service-base -->
  <xsl:template match="/|root">
    <xsl:apply-templates select="*" />
  </xsl:template>

  <xsl:template match="sql:rowset">
    <xsl:variable name="total" select="sql:row[1]/sql:total"/>
    <tns:GetLastChangesResponse>
      <tns:Objects totalAmountAvailable="{if($total) then $total else 0}">
        <xsl:apply-templates select="sql:row" />
      </tns:Objects>
    </tns:GetLastChangesResponse>
  </xsl:template>

  <xsl:template match="sql:row">
    <tns:Object documentType="{sql:content_type}" id="{sql:object_id}" lastModified="{sql:lastmodified_ts}"
      locale="{sql:localisation}" type="Product">
      <xsl:apply-templates select="sql:data/*" />
    </tns:Object>
  </xsl:template>

  <xsl:template match="ProductStatus|AuthorisationProfile">
    <xsl:apply-templates select="." mode="transfer-ns" />
  </xsl:template>

  <xsl:template match="*[namespace-uri()='']" mode="transfer-ns">
    <xsl:element name="tns:{local-name()}" namespace="http://pww.cmc.philips.com/CMCService/types/1.0">
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="node()" mode="transfer-ns" />
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
