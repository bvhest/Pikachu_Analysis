<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/publisher-upload-manifest">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="notify" />
      <!-- Remove duplicate assets -->
      <xsl:for-each-group select="asset" group-by="@refid">
        <xsl:sort select="@refid" />
        <xsl:apply-templates select=".[1]" />
      </xsl:for-each-group>
      <!-- 
        Remove duplicate titles preserving the oldest start-date and newest end-date of all titles.
        start and end dates are converted from attibutes to <tag> elements. 
      -->
      <xsl:for-each-group select="title" group-by="@refid">
        <xsl:sort select="@refid" />
        <xsl:element name="title">
          <xsl:variable name="start-date">
            <xsl:for-each select="current-group()/@start-date">
              <xsl:sort order="ascending" />
              <xsl:if test="position()=1">
                <xsl:value-of select="." />
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>
          <xsl:variable name="end-date">
            <xsl:for-each select="current-group()/@end-date">
              <xsl:sort order="descending" />
              <xsl:if test="position()=1">
                <xsl:value-of select="." />
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>
          <xsl:for-each select="current-group()">
            <xsl:if test="position() = 1">
              <xsl:apply-templates select="@*[not(local-name() = ('start-date', 'end-date'))]" />
              <!-- xsl:attribute name="start-date" select="$start-date"/>
				   <xsl:attribute name="end-date" select="$end-date"/ -->
              <xsl:apply-templates select="node()[not(starts-with(., 'CTN') or starts-with(., 'BasicType'))] " />
              <xsl:element name="tag">
                <xsl:value-of select="concat('start-date=',$start-date)" />
              </xsl:element>
              <xsl:element name="tag">
                <xsl:value-of select="concat('end-date=',$end-date)" />
              </xsl:element>
            </xsl:if>
            <xsl:apply-templates select="node()[starts-with(., 'CTN') or starts-with(., 'BasicType')]" />
          </xsl:for-each>
        </xsl:element>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
