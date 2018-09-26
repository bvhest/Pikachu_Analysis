<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:shell="http://apache.org/cocoon/shell/1.0" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:philips="http://www.philips.com/catalog/recat">

  <xsl:param name="sourceDir" as="xs:string" />
  <xsl:param name="targetDir" as="xs:string" />
  <xsl:param name="archiveFTPDir" as="xs:string" />
  <xsl:param name="cacheDir" as="xs:string" />
  <xsl:param name="fullExport" as="xs:string" />

  <xsl:template match="/">
    <page>
      <xsl:apply-templates select="//dir:file" />
    </page>
  </xsl:template>

  <xsl:template match="dir:file[dir:xpath/Categorization/Catalog/FixedCategorization
                     | dir:xpath/philips:categories/philips:category 
                     | dir:xpath/Products/Product]">
    <!--
      2010-10-04, JWE: The explicit copy of the resulting files to archive_ftp provides us
      a copy of actual output. This copy ensures that we know what we have sent at what time,
      irrespective of manual modifications of the archive content by the ATG loader.
    -->
    <shell:copy overwrite="true">
      <shell:source>
        <xsl:value-of select="concat($sourceDir,'/',@name)" />
      </shell:source>
      <shell:target>
        <xsl:value-of select="concat($archiveFTPDir,'/',@name)" />
      </shell:target>
    </shell:copy>
    <!--
      For a full export store the resulting file in the cache as well, removing the timestamp from the name.
    -->
    <xsl:if test="$fullExport='yes'">
      <shell:copy overwrite="true">
        <shell:source>
          <xsl:value-of select="concat($sourceDir,'/',@name)" />
        </shell:source>
        <shell:target>
          <xsl:value-of select="concat($cacheDir,'/',replace(@name,'\d{8}T\d{6}_',''))" />
        </shell:target>
      </shell:copy>
    </xsl:if>
    
    <shell:move overwrite="true">
      <shell:source>
        <xsl:value-of select="concat($sourceDir,'/',@name)" />
      </shell:source>
      <shell:target>
        <xsl:value-of select="concat($targetDir,'/',@name)" />
      </shell:target>
    </shell:move>
  </xsl:template>
  
  <!--
    Delete files that do not have any meaningful content.
  -->
  <xsl:template match="dir:file[not(dir:xpath/Categorization/Catalog/FixedCategorization
                     | dir:xpath/philips:categories/philips:category
                     | dir:xpath/Products/Product)]">
    <shell:delete>
      <shell:source>
        <xsl:value-of select="concat($sourceDir,'/',@name)" />
      </shell:source>
    </shell:delete>
  </xsl:template>
</xsl:stylesheet>