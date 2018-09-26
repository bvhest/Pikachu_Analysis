<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                >
  <!-- -->
  <xsl:param name="svcURL"/>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- hard-coded includes !!?? -->
  <xsl:template match="content[../@valid='true']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
        <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get/PMT_Raw/none/{../@o}"/>
        <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get/RichText_Raw/none/{../@o}"/>
        <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get/PMA_Raw/none/{../@o}"/>
        <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get/GreenData/master_global/{../@o}"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>