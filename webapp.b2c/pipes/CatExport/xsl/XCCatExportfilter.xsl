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
      <Products>
     
       <xsl:apply-templates select="Product[philips:status = ('updated','deleted')]"/> 
         
      </Products>
    </xsl:copy>
  </xsl:template>
  
  <!-- Don't send the 'updated' status -->
  <xsl:template match="philips:status[text()= ('updated','deleted')]"/> 
 
</xsl:stylesheet>
