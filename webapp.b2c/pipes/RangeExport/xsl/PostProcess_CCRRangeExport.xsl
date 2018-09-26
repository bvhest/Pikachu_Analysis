<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    exclude-result-prefixes="sql">

  <xsl:param name="exportdate" />

  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()" />
  </xsl:template>

  <xsl:template match="Nodes">
    <Nodes docTimestamp="{concat(substring($exportdate,1,4),'-'
                                ,substring($exportdate,5,2),'-'
                                ,substring($exportdate,7,2),'T'
                                ,substring($exportdate,10,2),':'
                                ,substring($exportdate,12,2),':00'  ) }">
      <xsl:apply-templates select="@*|node()" />
    </Nodes>
  </xsl:template>

  <xsl:template match="Node">
    <Node type="Cluster">
      <Code>
        <xsl:value-of select="@code" />
      </Code>
      <ReferenceName>
        <xsl:value-of select="@referenceName" />
      </ReferenceName>
    </Node>
  </xsl:template>
</xsl:stylesheet>
