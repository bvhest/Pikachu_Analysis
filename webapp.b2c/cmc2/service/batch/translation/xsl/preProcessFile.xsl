<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!--  -->
  <xsl:template match="text()">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>
  <!--  -->
  <xsl:template match="@*|element()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!--  -->
  <xsl:template match="trans">
      <xsl:apply-templates select="node()"/>
  </xsl:template>
  <!--  -->
  <xsl:template match="currentlastmodified_ts">
    <xsl:copy>
      <xsl:apply-templates select="sql:rowset/sql:row/sql:lastmodified_ts/text()"/>
    </xsl:copy>
  </xsl:template>
  <!--  -->  
  <xsl:template match="currentmasterlastmodified_ts">
    <xsl:copy>
      <xsl:apply-templates select="sql:rowset/sql:row/sql:masterlastmodified_ts/text()"/>
    </xsl:copy>
  </xsl:template>
  <!-- For PMT_Translated -->  
  <xsl:template match="currentpmtlocalisedmasterlastmodified_ts">
    <xsl:copy>
      <xsl:apply-templates select="sql:rowset/sql:row/sql:masterlastmodified_ts/text()"/>
    </xsl:copy>
  </xsl:template>  
  <!--  -->    
  <xsl:template match="counterpartstatus">
    <xsl:copy>
      <xsl:for-each select="sql:rowset/sql:row">
        <workflow><xsl:value-of select="sql:workflow"/></workflow>
        <valid><xsl:value-of select="sql:valid"/></valid>        
        <result><xsl:value-of select="sql:result"/></result>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>  
  <!--  -->
  <xsl:template match="processing-instruction('xml-stylesheet')"/>
  <!-- Remove Assets that were included in the export -->
	<xsl:template match="Assets"/>
	<!--  -->
</xsl:stylesheet>
