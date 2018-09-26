<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:inc="http://apache.org/cocoon/include/1.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
               >
  
  <xsl:param name="objects"/>
  
  <xsl:template match="/root">
    <xsl:variable name="object-ids" select="fn:tokenize($objects,',')"/>
    <tns:Objects totalAmountAvailable="{count($object-ids)}">
      <xsl:for-each select="$object-ids">
        <xsl:variable name="objectID" select="fn:substring-before(.,'|')"/>
        <inc:include src="cocoon:/getObjectDocument?objectID={$objectID}"/>
      </xsl:for-each>
    </tns:Objects>
  </xsl:template>
</xsl:stylesheet>
