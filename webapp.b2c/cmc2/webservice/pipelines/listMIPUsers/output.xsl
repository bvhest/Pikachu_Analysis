<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:inc="http://apache.org/cocoon/include/1.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:autn="http://schemas.autonomy.com/aci/"
               >
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="root">
      <xsl:element name="users">
        <xsl:attribute name="count" select="count(users/user)"/>
        <xsl:for-each select="users/user">
            <xsl:apply-templates select="current()"/>
        </xsl:for-each>
      </xsl:element>
  </xsl:template>
  
  <xsl:template match="autnresponse">
    <xsl:element name="name">
        <xsl:value-of select="responsedata/autn:hit/autn:content/DOCUMENT/PF_PERSON_FULLNAME"/>
    </xsl:element>
    <xsl:element name="email">
        <xsl:value-of select="responsedata/autn:hit/autn:content/DOCUMENT/PF_PERSON_EMAIL"/>
    </xsl:element>
  </xsl:template> 
  
</xsl:stylesheet>
