<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
<xsl:param name="threshold"/>
<xsl:param name="ts"/>
<xsl:param name="content_type"/>
<xsl:param name="svcURL"/>
<xsl:param name="overrideCheck">no</xsl:param>

	<xsl:template match="/dir:directory">
    <root>
      <xsl:choose>
        <xsl:when test="count(dir:file) &gt; number($threshold) and not($overrideCheck = 'yes')">
          <cinclude:include src="cocoon:/performSecondaryCheck/{$ts}?filecount={count(dir:file)}"/>
        </xsl:when>
        <xsl:otherwise>
		  <cinclude:include src="{$svcURL}/processControl/sql_storeFileCount/{$content_type}/{count(dir:file)}"/>
          <cinclude:include src="cocoon:/go/{$ts}"/>
        </xsl:otherwise>
      </xsl:choose>
    </root>
	</xsl:template>
</xsl:stylesheet>