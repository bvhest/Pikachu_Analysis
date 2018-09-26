<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:inc="http://apache.org/cocoon/include/1.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns:txt="http://chaperon.sourceforge.net/schema/text/1.0"
               >
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/txt:text">
    <inc:include src="http://pww.xmlsearch.philips.com/?a=query&amp;databasematch=PEOPLEFINDER&amp;fieldtext=MATCH%7B{encode-for-uri(current())}%7D%3APF_PERSON_LOGIN"/>
  </xsl:template>
</xsl:stylesheet>
