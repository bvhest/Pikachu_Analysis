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
    <group>
      <xsl:variable name="files-to-merge" select="tokenize($files, ' ')" />

      <xsl:for-each select="$files-to-merge">
      <source>
        <cinclude:include>
          <xsl:attribute name="src" select="concat('cocoon:/readFile/', concat($source-folder, '/'), .)" />
        </cinclude:include>
      </source>
      </xsl:for-each>
      <source>
        <cinclude:include>
          <xsl:attribute name="src"
            select="concat('cocoon:/readFile/', concat($cache-folder, '/UAP_'), substring($files-to-merge[1], 9))" />
        </cinclude:include>
      </source>
    </group>
  </xsl:template>
</xsl:stylesheet>
