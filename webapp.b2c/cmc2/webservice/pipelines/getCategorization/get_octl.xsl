<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:inc="http://apache.org/cocoon/include/1.0"
                xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0"
               >
  
  <xsl:import href="../service-base.xsl"/>
  <xsl:import href="../service-constants.xsl"/>

  <xsl:param name="categorizationID" select=""/>
  <xsl:param name="locale"/>
  <xsl:param name="cmc-svc-url"/>
  
  <xsl:template match="/root">
    <root>
      <xsl:variable name="ct" select="if ($locale = $MASTER_LOCALE or $locale = '') then 'Categorization_Raw' else 'Categorization_Translated'"/>
      <xsl:variable name="l" select="if ($locale = $MASTER_LOCALE or $locale = '') then 'none' else $locale"/>
      
      <inc:include src="{svc:get-octl-url($categorizationID,$ct,$l)}"/>
    </root>
  </xsl:template>
</xsl:stylesheet>
