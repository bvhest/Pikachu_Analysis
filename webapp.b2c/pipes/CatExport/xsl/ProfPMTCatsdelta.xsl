<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:philips="http://www.philips.com/catalog/recat">

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="delta">
    <xsl:copy copy-namespaces="no">
      <xsl:for-each select="/root/new/philips:categories/philips:category">
        <xsl:variable name="id" select="philips:id" />
        <xsl:variable name="parentCategory" select="philips:parentCategory" />
        <xsl:copy>
          <xsl:apply-templates select="@*|node()" />
          <philips:status>
            <xsl:choose>
              <xsl:when test="deep-equal(.,../../../cached/philips:categories/philips:category[philips:id=$id][philips:parentCategory=$parentCategory] )">
                <xsl:text>exists</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>updated</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </philips:status>
        </xsl:copy>
      </xsl:for-each>

      <xsl:for-each select="/root/cached/philips:categories/philips:category">
        <xsl:variable name="id" select="philips:id" />
        <xsl:variable name="parentCategory" select="philips:parentCategory" />
        <xsl:if test="not(../../../new/philips:categories/philips:category[philips:id=$id][philips:parentCategory=$parentCategory] )">
          <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
            <philips:status>deleted</philips:status>
          </xsl:copy>
        </xsl:if>
      </xsl:for-each>

    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
