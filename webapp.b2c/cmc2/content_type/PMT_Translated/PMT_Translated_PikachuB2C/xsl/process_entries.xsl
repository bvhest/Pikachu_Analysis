<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- Clean content returned from call to service 'get' routine -->
  <xsl:template match="octl|sql:rowset|sql:row|sql:data">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:*"/>
  <!-- -->
  <xsl:template match="octl-attributes[../@valid='true']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()[not(local-name()='masterlastmodified_ts' or local-name()='status' or local-name()='marketingversion' )]"/>
      <xsl:element name="masterlastmodified_ts"><xsl:value-of select="../content/octl/sql:rowset/sql:row[sql:content_type='PMT_Localised']/sql:masterlastmodified_ts"/></xsl:element>
      <xsl:element name="status">
        <xsl:value-of select="../content/octl/sql:rowset/sql:row[sql:content_type='PMT_Localised']/sql:status"/>
      </xsl:element>
      <xsl:element name="marketingversion">
        <xsl:value-of select="../content/octl/sql:rowset/sql:row[sql:content_type='PMT_Localised']/sql:marketingversion"/>
      </xsl:element>
    </xsl:copy>
  </xsl:template>
  <!-- -->
 </xsl:stylesheet>
