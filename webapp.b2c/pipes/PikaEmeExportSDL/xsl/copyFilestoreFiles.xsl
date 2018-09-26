<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="filestore-path" />
  <xsl:param name="target-path" />

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sql:data">
    <shell:copy overwrite="true" xmlns:shell="http://apache.org/cocoon/shell/1.0">
      <shell:source><xsl:value-of select="concat($filestore-path,'/',text(),'.xml')"/></shell:source>
      <shell:target><xsl:value-of select="concat($target-path,'/',text(),'.xml')"/></shell:target>
    </shell:copy>
    <xsl:next-match />
  </xsl:template>
  
</xsl:stylesheet>