<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i="http://apache.org/cocoon/include/1.0">

  <xsl:param name="svcURL"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="globalDocs">
    <xsl:copy>
      <i:include src="{$svcURL}common/get/FilterRules/none/filterrules"/>
    </xsl:copy>
  </xsl:template>
    
</xsl:stylesheet>