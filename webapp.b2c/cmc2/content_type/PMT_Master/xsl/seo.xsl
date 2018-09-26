<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:cmc2-f="http://www.philips.com/cmc2-f"
    exclude-result-prefixes="sql cinclude"
    extension-element-prefixes="cmc2-f">

  <xsl:include href="../../../xsl/common/cmc2.function.xsl"/>

  <!--
    Add SEOProductName
    Between (optional) ProductName and (optional) NamingString.
    Since ModelYears is the last mandatory element before the SEOProductName we use that as our key element.
  -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ModelYears">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
    <xsl:apply-templates select="ProductDivision|ProductOwner|DTN|ProductName|FullProductName"/>
    
    <SEOProductName romanize="true">
      <xsl:variable name="locale" select="ancestor::entry/@l"/>
      <xsl:attribute name="locale">
        <xsl:value-of select="if ($locale != '' and $locale != 'master_global') then $locale else 'en_US'"/>
      </xsl:attribute>
      
      <xsl:value-of select="cmc2-f:deriveSEOProductName(../NamingString)"/>
    </SEOProductName>
  </xsl:template>

</xsl:stylesheet>
