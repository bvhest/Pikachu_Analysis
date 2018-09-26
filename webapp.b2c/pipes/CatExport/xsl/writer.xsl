<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:source="http://apache.org/cocoon/source/1.0">
  
  <xsl:param name="fullexport" />
  <xsl:param name="dir" />
  <xsl:param name="channel" />
  <xsl:param name="ct" />
  <xsl:param name="ts" />
  <xsl:param name="end" />

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <!-- replace cached with new content -->
  <xsl:template match="new">
    <xsl:if test="$fullexport='yes'">
      <source:write>
        <source:source>
          <xsl:value-of select="concat($dir,'outbox/',$channel,'_',$ct,'_',$ts, '_', $end)" />
        </source:source>
        <source:fragment>
          <xsl:apply-templates select="@*|node()" />
        </source:fragment>
      </source:write>
    </xsl:if>
    <source:write>
      <source:source>
        <xsl:value-of select="concat($dir,'cache/',$channel,'_',$ct,'_',$end)" />
      </source:source>
      <source:fragment>
        <xsl:apply-templates select="@*|node()" />
      </source:fragment>
    </source:write>
  </xsl:template>

  <xsl:template match="delta">
    <xsl:if test="not($fullexport='yes')">
      <source:write>
        <source:source>
          <xsl:value-of select="concat($dir,'outbox/',$channel,'_',$ct,'_',$ts, '_', $end)" />
        </source:source>
        <source:fragment>
          <xsl:apply-templates select="@*|node()" />
        </source:fragment>
      </source:write>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
