<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0"
                >
                
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:import href="../service-functions.xsl"/>
  <xsl:import href="../service-base.xsl"/>
    
  <!-- Override service-base -->
  <xsl:template match="/">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  
  <xsl:template match="sql:rowset">
    <xsl:variable name="result-list">
      <xsl:apply-templates select="sql:row"/>
    </xsl:variable>
    
    <tns:Objects totalAmountAvailable="{count($result-list/*)}">
      <xsl:copy-of select="$result-list"/>
    </tns:Objects>
  </xsl:template>
  
  <xsl:template match="sql:row">
    <xsl:if test="svc:catalog-allowed(sql:catalogcode)">
      <tns:Object objectID="{sql:catalogcode}" type="Catalog"/>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
