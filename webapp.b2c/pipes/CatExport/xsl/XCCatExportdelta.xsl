<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:philips="http://www.philips.com/catalog/recat">

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="delta">
    <xsl:copy copy-namespaces="no">
      <xsl:for-each select="/root/new/Products/Product">
        <xsl:variable name="ctn" select="CTN" />
        <xsl:variable name="parentStatus" select="Status" />
        <xsl:copy>
          <xsl:apply-templates select="@*|node()" />
	      	<!-- <new><xsl:copy-of select="."/></new>
	      	<cache><xsl:copy-of select="../../../cached/Products/Product[CTN=$ctn][Status=$parentStatus]"/></cache> -->
          <philips:status>
            <xsl:choose>
              <xsl:when test="deep-equal(.,../../../cached/Products/Product[CTN=$ctn][Status=$parentStatus] )">
                <xsl:text>exists</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>updated</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </philips:status>
        </xsl:copy>
      </xsl:for-each>

      <xsl:for-each select="/root/cached/Products/Product">
        <xsl:variable name="ctn" select="CTN" />
        <xsl:variable name="parentStatus" select="Status" />
        <xsl:if test="not(../../../new/Products/Product[CTN=$ctn][Status=$parentStatus] )">
          <xsl:copy>
           <!--  <xsl:apply-templates select="@*|node()" /> --> 
           <xsl:attribute name="Country" select="@Country"/>
           <xsl:attribute name="Locale" select="@Locale"/>
           <xsl:attribute name="LastModified" select="@LastModified"/>
           <xsl:apply-templates select="ID"/>
           <xsl:apply-templates select="CTN"/>
           <xsl:apply-templates select="ProductType"/>
           <Status>Deleted</Status>
           <xsl:apply-templates select="Categorization"/>
           <xsl:apply-templates select="ProductName"/>
           <philips:status>deleted</philips:status>
          </xsl:copy>
        </xsl:if>
      </xsl:for-each>

    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
