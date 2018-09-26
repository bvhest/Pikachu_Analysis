<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0"
>
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:param name="timestamp"/>  
  
  <xsl:template match="/root">
    <root>
      <xsl:apply-templates select="sql:rowset/sql:row"/>
    </root>
  </xsl:template>

  <xsl:template match="sql:rowset/sql:row">
    <xsl:choose>
      <xsl:when test="//root/@seo='yes'">
         <cinclude:include src="cocoon:/createExportBatches/{sql:content_type}/{sql:locale}/{sql:internal_category}/{$timestamp}?seo=yes"/>    
      </xsl:when>
      <xsl:otherwise>
         <cinclude:include src="cocoon:/createExportBatches/{sql:content_type}/{sql:locale}/{sql:internal_category}/{$timestamp}"/>    
      </xsl:otherwise>    
    </xsl:choose>
  </xsl:template>  

</xsl:stylesheet>