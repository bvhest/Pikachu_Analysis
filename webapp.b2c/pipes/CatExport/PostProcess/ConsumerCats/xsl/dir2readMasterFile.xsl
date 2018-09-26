<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:i="http://apache.org/cocoon/include/1.0">
    
  <!-- Read the latest master file -->
  <xsl:template match="/dir:directory">
    <mastertree original-filename="{dir:file[position()=last()]/@name}">
      <xsl:if test="exists(dir:file)">
        <i:include src="cocoon:/read/{dir:file[position()=last()]/@name}" />
      </xsl:if>
    </mastertree>
  </xsl:template>
</xsl:stylesheet>