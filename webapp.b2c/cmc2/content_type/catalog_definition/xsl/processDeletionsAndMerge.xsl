<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:i="http://apache.org/cocoon/include/1.0"
                xmlns:email="http://apache.org/cocoon/transformation/sendmail"
                exclude-result-prefixes="i sql email">

  <xsl:param name="destination"/>
  <xsl:param name="system"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Process catalogs that are OK -->
  <xsl:template match="catalog[@action='proceed']">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>

      <xsl:if test="exists(counts/@deleted) and number(counts/@deleted) gt 0">
        <i:include src="cocoon:/doDeletions/{@customer_id}/{@country}"/>
      </xsl:if>

      <i:include src="cocoon:/mergeExternalTable/{@customer_id}/{@country}?destination={$destination}"/>
    </xsl:copy>
  </xsl:template>

  <!-- Create email for catalogs that are not OK -->
  <xsl:template match="catalog[@action='block'][1]">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
    
    <email:sendmail>
      <email:subject>Too many deletions in catalogs (<xsl:value-of select="$system"/>)</email:subject>
      <email:body mime-type="text/plain">
        <xsl:text>Some catalogs have too many deleted products.

</xsl:text>
        <xsl:apply-templates select=".|following-sibling::catalog[@action='block']" mode="email"/>
      </email:body>
    </email:sendmail>
  </xsl:template>
  
  <xsl:template match="catalog" mode="email">
    <xsl:value-of select="concat(@customer_id, ' / ', @country)"/>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="counts/@deleted"/>
    <xsl:text> of </xsl:text>
    <xsl:value-of select="counts/@actual"/>
    <xsl:text> products deleted (</xsl:text>
    <xsl:value-of select="counts/@deleted-relative"/>
    <xsl:text> %) where </xsl:text>
    <xsl:value-of select="counts/@deletions-allowed"/>
    <xsl:text> deletions allowed (</xsl:text>
    <xsl:value-of select="format-number(counts/@threshold-relative,'#0.0')"/>
    <xsl:text> %)

</xsl:text>
    
  </xsl:template>
</xsl:stylesheet>
