<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:i="http://apache.org/cocoon/include/1.0">

  <xsl:param name="next" />

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/root">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
      <xsl:if test="$next!='' and empty(report[@name='deleted objects'])">
        <i:include src="{$next}"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="delete">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
      <i:include src="cocoon:/deletedProduct.{@file}"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>