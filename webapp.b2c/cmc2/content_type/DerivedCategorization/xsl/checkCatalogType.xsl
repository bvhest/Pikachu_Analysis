<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0">
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ct"/>
  <xsl:param name="timestamp"/> 
	<xsl:template match="/root">
    <xsl:copy copy-namespaces="no">
     	<xsl:if test="reports/root/root/entry[@o = 'CARE'][@valid = 'true'] or root/root/entry[@o = 'CARE'][@valid = 'true']"> 
          <i:include src="cocoon:/processUnmapped/{$ct}/{$timestamp}"/>
        </xsl:if>
        
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>