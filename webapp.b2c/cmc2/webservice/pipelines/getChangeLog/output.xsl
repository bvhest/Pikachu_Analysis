<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                exclude-result-prefixes="sql"
                >
                
  <xsl:import href="../service-base.xsl"/>
  
  <!-- Override service-base -->
  <xsl:template match="/">
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <xsl:template match="/root">
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <xsl:template match="sql:rowset">
    <!--
    <xsl:variable name="total" select="sql:row[1]/sql:total"/>
    <tns:GetChangeLogResponse totalAmountAvailable="{if($total) then $total else 0}">
    -->
    <tns:GetChangeLogResponse>
      <xsl:apply-templates select="sql:row"/>
    </tns:GetChangeLogResponse>
  </xsl:template>
  
  <xsl:template match="sql:row">
      <tns:Change documentType="{sql:content_type}" locale="{sql:localisation}" objectID="{sql:object_id}"  timestamp="{sql:lastmodified_ts}" /> 
  </xsl:template>
</xsl:stylesheet>
