<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:tns="http://tempuri.org/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
                exclude-result-prefixes="tns"
                >
   
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template> 
   
  <xsl:template match="page"> 
    <xsl:copy-of select="soap:Envelope/soap:Body/tns:GetDetailsResponse/tns:GetDetailsResult" copy-namespaces="no" />

    <!-- 
    <xsl:element name="GetDetailsResult">
      <xsl:element name="Email">
        <xsl:value-of select="soap:Envelope/soap:Body/tns:GetDetailsResponse/tns:GetDetailsResult/tns:Email"/>
      </xsl:element>
    </xsl:element>
    -->
  </xsl:template>
</xsl:stylesheet>