<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:shell="http://apache.org/cocoon/shell/1.0"
    >

  <xsl:param name="source" />
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Remove files that are identical to the cached version -->
  <xsl:template match="remove">
    <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <shell:delete>
      <shell:source>
        <xsl:value-of select="concat($source,replace(@objectid,'/','_'),'.xml')" />
      </shell:source>
    </shell:delete>
    </xsl:copy>
  </xsl:template>

  <!-- Store a merged version -->
  <xsl:template match="store">
    <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
      <source:source>
        <xsl:value-of select="$source"/>
        <xsl:value-of select="replace(ObjectsMsg/Object/ObjectID,'/','_')"/>
        <xsl:text>.xml</xsl:text>
      </source:source>
      <source:fragment>
        <xsl:apply-templates select="ObjectsMsg"/>
      </source:fragment>
    </source:write>
  </xsl:template>

</xsl:stylesheet>