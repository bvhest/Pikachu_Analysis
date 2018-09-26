<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="locale"/>
  
  <xsl:template match="/dir:directory">
    <xsl:copy>
      <xsl:attribute name="name" select="@name"/>
      <xsl:sequence select="dir:file[starts-with(@parent, concat('cache/',$locale,'/'))]"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>