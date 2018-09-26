<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >

  <!-- Note: as of writing (25 Apr 2008) a product is stated as belonging to a maximum of one range, so we take the first range secondary only -->

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="secondary" />
  <!-- -->
  <xsl:template match="Product">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  <!-- 
     | Convert Clusters.
     -->
  <xsl:template match="ProductClusters">
    <xsl:variable name="CTN" select="ancestor::entry/@o" />
    <xsl:copy copy-namespaces="no">
      <!-- Copy the existing clusters -->
      <xsl:apply-templates select="*"/>
      <!-- Add any additional clusters -->
      <xsl:for-each select="ancestor::entry/content/secondary/octl/sql:rowset/sql:row[sql:content_type='RangeText_Raw']/sql:data/Node[not(@code=current()/ProductCluster/@code)]">
        <xsl:element name="ProductCluster">
          <xsl:variable name="code" select="@code" />
          <xsl:attribute name="type" select="@nodeType" />
          <xsl:attribute name="code" select="@code" />
          <xsl:attribute name="referenceName" select="if (@referenceName!='') then @referenceName else Name" />
          <!-- rank-attribute is mandatory in the ProductExport, but not (always) present for variations -->
          <xsl:choose>
             <xsl:when test="ProductReferences/ProductReference[CTN=$CTN][1]/ProductReferenceRank != ''
                           or ProductRefs/ProductReference/CTN[.=$CTN]/@rank != ''
                           or ProductRefs/ProductReference/Product[@ctn=$CTN]/@rank != ''">
                <xsl:attribute name="rank" select="ProductReferences/ProductReference[CTN=$CTN][1]/ProductReferenceRank
                                                 | ProductRefs/ProductReference/CTN[.=$CTN]/@rank
                                                 | ProductRefs/ProductReference/Product[@ctn=$CTN]/@rank" />
             </xsl:when>
             <xsl:otherwise>
                <xsl:attribute name="rank">
                   <xsl:choose>
                      <xsl:when test="ProductRefs/ProductReference/Product[@ctn=$CTN]">
                         <xsl:value-of select="ProductRefs/ProductReference/Product[@ctn=$CTN]/position()"/>
                      </xsl:when>
                      <xsl:otherwise>1</xsl:otherwise>
                   </xsl:choose>
                </xsl:attribute>
             </xsl:otherwise>
          </xsl:choose>
          <xsl:element name="Name">
            <xsl:value-of select="Name" />
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>