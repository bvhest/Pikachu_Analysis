<?xml version="1.0" encoding="UTF-8"?>
	<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:i="http://apache.org/cocoon/include/1.0"
    xmlns:email="http://apache.org/cocoon/transformation/sendmail"
    xmlns:source="http://apache.org/cocoon/source/1.0">

  <xsl:param name="changes-threshold"/>
  <xsl:param name="override"/>
  <xsl:param name="ct-dir"/>
  <xsl:param name="timestamp"/>
  
  <xsl:template match="@*|node()" mode="#all">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template> 
  
  <!-- Clean sourceResult and its related tags -->
  <xsl:template match="sourceResult"/>
 
  <xsl:template match="dir:directory">
    <xsl:variable name="changes-count" select="count(//Directory/directory/FilterAssets/keep)"/>
	<root>
    <xsl:copy copy-namespaces="no">
	  <xsl:choose>
        <xsl:when test="$override != 'yes' and ($changes-count gt number($changes-threshold))">
           <i:include src="cocoon:/restoreInbox"/> 
          
          <xsl:call-template name="create-email">
            <xsl:with-param name="changes-count" select="$changes-count"/>
          </xsl:call-template>
          <xsl:call-template name="create-errorfile">
            <xsl:with-param name="changes-count" select="$changes-count"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise> 
          <!--
            Changes are within bounds or we are running in override mode so we can continue.
          -->
          <xsl:apply-templates select="report" mode="continue"/> 
          
          <!-- Perform the actual import -->
         <report name="run">
            <i:include src="cocoon:/performImport/{$timestamp}"/>
          </report>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy></root>
  </xsl:template> 

  <xsl:template name="create-email">
    <xsl:param name="changes-count"/>
    <email:sendmail>
      <email:subject>AssetList: Too many modifications in the feed</email:subject>
      <email:body mime-type="text/plain">
        <xsl:text>Number of changed assets: </xsl:text>
        <xsl:value-of select="$changes-count"/><xsl:text>
</xsl:text>
        <xsl:text>Number of allowed changes: </xsl:text>
        <xsl:value-of select="$changes-threshold"/><xsl:text>
</xsl:text>
      </email:body>
      <xsl:if test="$changes-count gt 0">
        <email:attachment name="changedAssets.txt" mime-type="text/plain">
          <email:content>
            <xsl:for-each select="//Directory/directory/FilterAssets/keep/@ctn">
              <xsl:value-of select="."/>
              <xsl:text>
</xsl:text>
            </xsl:for-each>
          </email:content>
        </email:attachment>
      </xsl:if>
    </email:sendmail>
  </xsl:template>

  <xsl:template name="create-errorfile">
    <xsl:param name="changes-count"/>
    <xsl:variable name="now" select="format-dateTime(current-dateTime(), '[Y0001][M01][D01]T[H01][m01][s01]')"/>
    <source:write>
      <source:source>
        <xsl:value-of select="concat($ct-dir,'/logs/ErrorReport_', $now, '.xml')"/>
      </source:source>
      <source:fragment>
        <error>
          <message>AssetList: Too many modifications in the feed</message>
          <changes actual="{$changes-count}" allowed="{$changes-threshold}">
            <xsl:for-each select="//Directory/directory/FilterAssets/keep/@ctn">
              <id><xsl:value-of select="."/></id>
            </xsl:for-each>
          </changes>
         </error>
      </source:fragment>
    </source:write>
  </xsl:template> 
  
</xsl:stylesheet>
