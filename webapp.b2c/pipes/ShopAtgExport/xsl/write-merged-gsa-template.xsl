<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:source="http://apache.org/cocoon/source/1.0">

  <xsl:param name="target-path"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>	

  <xsl:template match="/root">
    <source:write>
      <source:source>
        <xsl:value-of select="$target-path" />
      </source:source>
      <source:fragment>
        <gsa-template>
          <import-items>
            <xsl:apply-templates select="gsa-template/import-items/add-item">
              <xsl:sort select="@id" />
            </xsl:apply-templates>
          </import-items>
        </gsa-template>
      </source:fragment>
    </source:write>
  </xsl:template>  
</xsl:stylesheet>