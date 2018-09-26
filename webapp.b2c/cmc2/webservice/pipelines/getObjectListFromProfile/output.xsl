<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                >
  <xsl:param name="maxNum" select="0"/>
  <xsl:param name="lastID"/>
                  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:import href="../service-functions.xsl"/>
  
  <xsl:template match="/root">
  	<xsl:variable name="total" select="sum(sql:rowset/@nrofrows)"/>
    <tns:Objects totalAmountAvailable="{if($total) then $total else 0}">
      <xsl:apply-templates select="sql:rowset/sql:row"/>
    </tns:Objects>
  </xsl:template>
  
  <xsl:template match="sql:row">
    <tns:Object objectID="{sql:object_id}" type="Product" lastModified="{sql:lastmodified}"/>
  </xsl:template>
</xsl:stylesheet>
