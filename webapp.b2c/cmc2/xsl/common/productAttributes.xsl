<xsl:stylesheet version="2.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="BrandName|BrandString">
    <xsl:element name="{node-name(.)}"><xsl:value-of select="replace(.,'PHILIPS','Philips')"/></xsl:element>       
  </xsl:template>  

  <xsl:template match="Product">
    <xsl:copy>
      <xsl:apply-templates select="@*[not(local-name()='lastModified' or local-name()='masterLastModified')]"/>
      <xsl:attribute name="masterLastModified" select="../../octl-attributes/masterlastmodified_ts"/>
      <xsl:attribute name="lastModified" select="../../octl-attributes/lastmodified_ts"/>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- No special handling for Product inside ProductReference -->
  <xsl:template match="ProductReference/Product" priority="1">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="entry[@ct='RangeText_Translated']/content/Node">
    <xsl:copy>
      <xsl:apply-templates select="@*[not(local-name()='lastModified' or local-name()='masterLastModified')]"/>
      <xsl:attribute name="masterLastModified" select="../../octl-attributes/masterlastmodified_ts"/>
      <xsl:attribute name="lastModified" select="../../octl-attributes/lastmodified_ts"/>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>  

  <xsl:template match="octl-attributes/islocalized">  
    <islocalized><xsl:value-of select="if(../../content/node()/@IsLocalized='true') then 1 else 0"/></islocalized>
  </xsl:template>  

</xsl:stylesheet>