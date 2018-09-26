<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:inc="http://apache.org/cocoon/include/1.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
               >
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="tns:Object">
    <inc:include src="cocoon:/getObjectDocument?objectID={@objectID}&amp;__noauth=1"/>
  </xsl:template>
</xsl:stylesheet>
