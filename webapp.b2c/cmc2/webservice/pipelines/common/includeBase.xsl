<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:i="http://apache.org/cocoon/include/1.0">
  
  <xsl:param name="__auth_user"/>
  <xsl:param name="__noauth"/>
  
  <xsl:template match="/root">
    <xsl:copy>
      <xsl:if test="not(__noauth)">
        <user-profile>
          <i:include src="cocoon:/common/getUAP"/>
        </user-profile>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
