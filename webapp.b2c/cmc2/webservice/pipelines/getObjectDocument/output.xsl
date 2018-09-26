<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                exclude-result-prefixes="sql"
                >
                
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="contentType"/>
  <xsl:param name="locale"/>
  <xsl:param name="target"/>
  
  <xsl:import href="../service-functions.xsl"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="root">
    <xsl:apply-templates select="*"/>
  </xsl:template>  
    
  <xsl:template match="sql:*">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  
  <xsl:template match="tns:Object[@type!='Error']">
    <xsl:copy>
      <xsl:apply-templates select="@objectID|@locale|@documentType"/>
      <xsl:choose>
        <!--
          If there is a row the octl exists 
        -->
        <xsl:when test="sql:rowset/sql:row">
          <xsl:choose>
            <!-- If there is a data child the octl data is present-->
            <xsl:when test="sql:rowset/sql:row/sql:data/*">
              <xsl:attribute name="lastModified" select="sql:rowset/sql:row/sql:lastmodified"/>
              <xsl:apply-templates select="@type"/>
              <xsl:apply-templates select="sql:rowset/sql:row/sql:data"/>
            </xsl:when>
            <!-- Otherwise the query was performed with a modified since match and the octl wasn't modified -->
            <xsl:otherwise>
              <xsl:attribute name="lastModified" select="sql:rowset/sql:row/sql:lastmodified"/>
              <xsl:attribute name="type">Error</xsl:attribute>
              <xsl:sequence select="svc:get-error(304)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="type">Error</xsl:attribute>
          <xsl:sequence select="svc:get-error(404)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="octl">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  
  <xsl:template match="Product">
    <xsl:choose>
      <xsl:when test="$target='icp'">
        <xsl:apply-templates select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="transfer-ns"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="element()" mode="transfer-ns">
    <xsl:element name="{local-name()}" namespace="http://pww.cmc.philips.com/CMCService/types/1.0">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()" mode="transfer-ns"/>
    </xsl:element>
  </xsl:template>

  <!-- Remove optimization attributes from PMS data -->
  <xsl:template match="@*[$contentType='PMS'][starts-with(local-name(),'_')]"/>
  
  <!-- Remove obsolete EditStatus tag from old PMS objects -->
  <xsl:template match="EditStatus" mode="transfer-ns"/>
</xsl:stylesheet>
