<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:i="http://apache.org/cocoon/include/1.0"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:param name="timestamp"/>
  <xsl:param name="isdirect"/>  
  
  <xsl:template match="/root">
    <root>
      <xsl:apply-templates select="sql:rowset[@name='notdirect']/sql:row"/>
    </root>
  </xsl:template>

  <xsl:template match="sql:rowset[@name='notdirect']/sql:row"> 
    <i:include src="cocoon:/processBatches/{sql:content_type}/{sql:locale}/{sql:internal_category}/{$timestamp}"/>
  </xsl:template>  

</xsl:stylesheet>