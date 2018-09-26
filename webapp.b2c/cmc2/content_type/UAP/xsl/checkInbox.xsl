<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!--  -->    

  <xsl:param name="ts"/>

  <xsl:template match="/">
    <root>
      <xsl:if test="exists(dir:directory[@name='inbox']/dir:file)">
	      <cinclude:include src="{concat('cocoon:/processInbox/', $ts)}"/>	
      </xsl:if>
    </root>
  </xsl:template>
</xsl:stylesheet>