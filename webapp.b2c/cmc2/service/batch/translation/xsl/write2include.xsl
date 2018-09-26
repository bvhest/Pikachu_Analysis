<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i="http://apache.org/cocoon/include/1.0">

  <xsl:param name="prefix"/>

  <xsl:template match="batch">
  <!-- Parameters: {1} = ct  {2} = ts  {3} = division  {4} = category -->
    <i:include src="{$prefix}/{@ct}/{@ts}/{@division}/{@category}"/>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>