<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:i="http://apache.org/cocoon/include/1.0"
    xmlns:local="http://pww.pkachu.philips.com/functions/local"
    extension-element-prefixes="local">
  
  <xsl:import href="../Assets/XSL/rendering-functions.xsl"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="batch">
    <xsl:copy>
      <xmldata>
        <xsl:apply-templates select="asset"/>
      </xmldata>
      <cachedata>
        <xsl:for-each-group select="asset" group-by="local:get-asset-cache-dir(.)">
          <cachedir path="{current-grouping-key()}">
            <i:include src="cocoon:/readImageCache/{current-grouping-key()}"/>
          </cachedir>
        </xsl:for-each-group>
      </cachedata>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>