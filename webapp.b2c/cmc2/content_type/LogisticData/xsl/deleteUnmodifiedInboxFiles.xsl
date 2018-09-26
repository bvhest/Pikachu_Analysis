<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cinclude="http://apache.org/cocoon/include/1.0"
                xmlns:dir="http://apache.org/cocoon/directory/2.0"
                xmlns:shell="http://apache.org/cocoon/shell/1.0"
                >
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:param name="ctDir"/>
  
  <!--+
      | Filter a file by determining wether there is a copy in the cache and
      | wether this has the same content as the file in the inbox.
      +-->
	<xsl:template match="/">
		<root>
			<xsl:for-each select="//dir:file">
        <!-- Get the content of the file in the inbox -->
        <xsl:variable name="inboxFilePath" select="concat($ctDir,'/inbox/',@name)"/>
        <xsl:variable name="inboxContent">
          <xsl:apply-templates select="document($inboxFilePath)/Products/Product"/>
        </xsl:variable>
        <!-- Get any content from the file in the cache country directory -->
        <xsl:variable name="country" select="substring(@name, 0, 3)"/>
        <xsl:variable name="cachedFilePath" select="concat($ctDir,'/cache/',$country,'/',@name)"/>
        <xsl:variable name="cachedContent">
          <xsl:if test="doc-available($cachedFilePath)">
            <xsl:apply-templates select="document($cachedFilePath)/Products/Product"/>
          </xsl:if>
        </xsl:variable>
        <!-- Compare the two contents -->
        <xsl:variable name="equals" select="deep-equal($cachedContent, $inboxContent)"/>
        <!-- Include all considered file for reporting -->
        <ComparedFile>
          <xsl:attribute name="name" select="@name"/>
          <xsl:attribute name="is_modified" select="not($equals)"/>
          <!-- Delete the file in the inbox if the two are identical -->
          <xsl:if test="$equals = true()">
            <shell:delete>
              <shell:source>
                <xsl:value-of select="$inboxFilePath"/>
              </shell:source>
            </shell:delete>
          </xsl:if>
        </ComparedFile>
      </xsl:for-each>
		</root>
	</xsl:template>

  <!-- Ignore -->
  <xsl:template match="@masterLastModified"/>

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>