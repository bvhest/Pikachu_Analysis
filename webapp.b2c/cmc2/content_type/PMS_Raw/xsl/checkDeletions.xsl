<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:param name="threshold" />
  <xsl:param name="overrideCheck"/>
  
  <xsl:template match="/root">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:choose>
        <xsl:when test="count(delete) &gt; number($threshold) and not($overrideCheck = 'yes')">
          <cinclude:include src="cocoon:/abortDeletions?filecount={count(delete)}" />
        </xsl:when>
        <xsl:otherwise>
          <!-- Copy the delete elements to proceed -->
          <xsl:sequence select="delete"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>