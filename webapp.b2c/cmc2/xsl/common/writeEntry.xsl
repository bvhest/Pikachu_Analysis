<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="dir">
    <xsl:text>test</xsl:text>
  </xsl:param>
  <xsl:param name="prefix"/>

  <xsl:template match="/">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="entries">
    <xsl:variable name="division" select="if (@division) then  concat(@division, '_') else ''" />
    <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
      <source:source>
        <xsl:value-of select="concat($dir,'/temp/',$prefix, $division,'entry_',@ts,'.',@l,'.',@batchnumber,'.xml')" />
      </source:source>
      <source:fragment>
        <xsl:copy-of copy-namespaces="no" select="." />
      </source:fragment>
    </source:write>
  </xsl:template>

</xsl:stylesheet>
