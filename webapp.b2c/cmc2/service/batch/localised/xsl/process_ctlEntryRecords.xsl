<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cinclude="http://apache.org/cocoon/include/1.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">  
  <xsl:param name="storeURL"/>
  <xsl:param name="ct"/>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="sourceResult[execution='success']/source">   
    <xsl:choose>
      <xsl:when test="$storeURL != ''">
        <cinclude:include src="{concat($storeURL,'/',.)}"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>        
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>