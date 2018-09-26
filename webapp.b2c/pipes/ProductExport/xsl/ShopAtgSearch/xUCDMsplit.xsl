<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ph="http://www.philips.com/catalog/search" 
    exclude-result-prefixes="">

  <xsl:param name="dir" />
  <xsl:param name="country" />
  <xsl:param name="locale" />
  <xsl:param name="isMaster" />
  
  <xsl:variable name="ext" select="'.xml'"/>
  <xsl:variable name="target-locale" select="if ($isMaster != 'true') then $locale else concat('en_', $country)" />
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/ph:products">
    <root process="xUCDMSplit">
      <xsl:for-each-group select="ph:product" group-adjacent="ph:CTN">
        <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
          <source:source>
            <xsl:value-of select="concat($dir, translate(current-grouping-key(),'/','_'), '.', $target-locale, $ext)"/>
          </source:source>
          <source:fragment>
            <ph:products>
              <xsl:apply-templates select="current-group()/../@*|current-group()"/>
            </ph:products>
          </source:fragment>
        </source:write>
      </xsl:for-each-group>
    </root>
  </xsl:template>

</xsl:stylesheet>
