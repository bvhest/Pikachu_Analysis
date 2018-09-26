<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:shell="http://apache.org/cocoon/shell/1.0">
  
  <xsl:param name="src-dir" select="'.'"/>
  <xsl:param name="output-file" select="'.'"/>
  
  <xsl:template match="node()|@*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/root[Categorization|ProductTree]">
    <xsl:copy copy-namespaces="no">
      <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
        <source:source>
          <xsl:value-of select="$output-file"/>
        </source:source>
        <source:fragment>
          <Categorization>
            <xsl:apply-templates select="(Categorization|ProductTree)[1]/@DocTimeStamp"/>
            
            <xsl:apply-templates select="Categorization/Catalog|ProductTree"/>
          </Categorization>
        </source:fragment>
      </source:write>
      
      <xsl:apply-templates select="dir:file[@name != 'CE_CategorizationTree.xml']"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="dir:file">
    <shell:delete>
      <shell:source>
        <xsl:value-of select="concat($src-dir,'/',@name)"/>
      </shell:source>
    </shell:delete>
  </xsl:template>
</xsl:stylesheet>