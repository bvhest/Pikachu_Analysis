<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
   
  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>  
  <!-- -->  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>  
  <!-- -->  
    <xsl:template match="sql:*|sql:rowset|sql:row|sql:data|sql:data/object|object/@id">
        <xsl:apply-templates select="@*|node()"/>        
    </xsl:template>
  <!-- -->
    <xsl:template match="sql:content_type|sql:localisation|sql:object_id|sql:masterlastmodified_ts|sql:lastmodified_ts|sql:status"/>
  <!-- -->        
  <xsl:template match="Node">
    <xsl:copy-of select="."/>
  </xsl:template>
  
</xsl:stylesheet>
