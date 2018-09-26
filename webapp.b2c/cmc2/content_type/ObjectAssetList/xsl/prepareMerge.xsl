<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
    xmlns:shell="http://apache.org/cocoon/shell/1.0">

  <xsl:param name="files" />
  <xsl:param name="source-folder" />
  <xsl:param name="cache-folder" />
  <xsl:param name="processed-folder" />

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/">
    <root>
      <xsl:variable name="files-to-merge" select="tokenize($files, ' ')" />
      <delta>
        <xsl:for-each select="$files-to-merge">
          <cinclude:include>
            <xsl:attribute name="src" select="concat('cocoon:/readFile/', concat($source-folder, '/'), .)" />
          </cinclude:include>
          <shell:move>
            <shell:source>
              <xsl:value-of select="concat($source-folder, '/', .)" />
            </shell:source>
            <shell:target>
              <xsl:value-of select="concat($processed-folder, '/', .)" />
            </shell:target>
          </shell:move>
        </xsl:for-each>
      </delta>

      <cache>
        <cinclude:include>
          <xsl:attribute name="src"
            select="concat('cocoon:/readFile/', concat($cache-folder, '/'), replace($files-to-merge[1], '.+\.batch_\d+\.(.+)\.xml', '$1'), '.xml')" />
        </cinclude:include>
      </cache>
    </root>
  </xsl:template>
</xsl:stylesheet>
