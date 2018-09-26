<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:i="http://apache.org/cocoon/include/1.0"
    xmlns:ws="http://apache.org/cocoon/source/1.0">

  <!--
    Split the contents into multiple batch files. 
  -->
  <xsl:param name="process"/>
  <xsl:param name="root-dir"/>
  <xsl:param name="output-dir" select="'/tmp'"/>
  <xsl:param name="threads"/>
  <xsl:param name="prefix" select="'batch.'"/>
  
  <xsl:variable name="l-threads" select="if (matches($threads,'\d+')) then number($threads) else 4"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="root">
    <xsl:copy>
      <xsl:for-each-group select="asset" group-by="(position()-1) mod $l-threads">
        <ws:write>
          <ws:source>
            <xsl:value-of select="concat($output-dir,'/',$prefix,current-grouping-key(),'.xml')"/>
          </ws:source>
          <ws:fragment>
            <batch number="{current-grouping-key()}">
              <xsl:apply-templates select="current-group()"/>
            </batch>
          </ws:fragment>
        </ws:write>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>  

</xsl:stylesheet>