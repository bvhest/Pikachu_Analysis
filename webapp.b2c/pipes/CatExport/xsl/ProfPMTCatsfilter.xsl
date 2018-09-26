<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:philips="http://www.philips.com/catalog/recat"
    xmlns:source="http://apache.org/cocoon/source/1.0">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="cached" />

  <xsl:template match="delta">
    <xsl:copy copy-namespaces="no">
      <philips:categories>
        <xsl:apply-templates select="philips:category[philips:status = ('updated','deleted')]"/>
      </philips:categories>
    </xsl:copy>
  </xsl:template>
  
  <!-- Don't send the 'updated' status -->
  <xsl:template match="philips:status[text()='updated']"/>
  
  <!-- Disable below template to send categorization deletes to Atg -->
  <!-- xsl:template match="philips:category[philips:status='deleted']"/ -->
  
</xsl:stylesheet>
