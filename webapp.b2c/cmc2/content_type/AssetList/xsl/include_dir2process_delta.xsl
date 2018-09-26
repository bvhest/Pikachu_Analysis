<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="output-folder" />
  <xsl:param name="process" />

  <xsl:template match="/">
    <root>
      <xsl:variable name="list">
        <list>
          <xsl:apply-templates />
        </list>
      </xsl:variable>

      <xsl:for-each-group select="$list/list/entry" group-by="@assetId">
        <xsl:for-each select="current-group()">
          <xsl:if test="count(current-group()) = position()">
            <cinclude:include src="cocoon:/{$process}/{$output-folder}/{current-group()/@name}" />
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each-group>
    </root>
  </xsl:template>

  <xsl:template match="//dir:file">
    <entry>
      <xsl:attribute name="name" select="@name" />
      <xsl:attribute name="assetId" select="replace(@name, '.+\.batch_0\.(.+)\.xml', '$1')" />
    </entry>
  </xsl:template>
</xsl:stylesheet>