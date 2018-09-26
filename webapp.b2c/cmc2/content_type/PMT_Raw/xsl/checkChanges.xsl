<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:i="http://apache.org/cocoon/include/1.0"
    xmlns:email="http://apache.org/cocoon/transformation/sendmail"
    xmlns:shell="http://apache.org/cocoon/shell/1.0"
    xmlns:source="http://apache.org/cocoon/source/1.0"
  >

  <xsl:param name="deletions-threshold"/>
  <xsl:param name="changes-threshold"/>
  <xsl:param name="override"/>
  <xsl:param name="ct-dir"/>
  <xsl:param name="timestamp"/>
  <xsl:param name="content_type"/>
  <xsl:param name="svcURL"/>

  <xsl:template match="@*|node()" mode="#all">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="root">
    <xsl:variable name="deletions-count" select="count(report[@name='deleted-products']/delete)"/>
    <xsl:variable name="changes-count" select="count(report[@name='changed-products']/modified)"/>
    <xsl:copy copy-namespaces="no">
      <xsl:choose>
        <xsl:when test="$override != 'yes' and ($changes-count gt number($changes-threshold) or $deletions-count gt number($deletions-threshold))">
          <i:include src="cocoon:/restoreInbox"/>
          
          <xsl:call-template name="create-email">
            <xsl:with-param name="deletions-count" select="$deletions-count"/>
            <xsl:with-param name="changes-count" select="$changes-count"/>
          </xsl:call-template>
          <xsl:call-template name="create-errorfile">
            <xsl:with-param name="deletions-count" select="$deletions-count"/>
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
			<i:include src="{$svcURL}/processControl/sql_storeFileCount/{$content_type}/{$changes-count}"/>		  
            <i:include src="cocoon:/go/{$timestamp}"/>
          </report>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="report[@name='deleted-products']" mode="continue">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|delete" mode="continue"/>
    </xsl:copy>
  </xsl:template> 

  <!-- Put the products that were deleted in the inbox and set the status to 'Deleted' -->
  <xsl:template match="delete" mode="continue">
    <i:include src="cocoon:/prepareDeletedProduct/{text()}.xml"/>
  </xsl:template> 

  <xsl:template match="report[@name='changed-products']" mode="continue">
    <xsl:copy copy-namespaces="no">
      <xsl:attribute name="name" select="'identical-products'"/>
      <xsl:apply-templates select="identical[empty(@keep)]" mode="continue"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Delete the inbox files of unchanged products so they are not imported -->
  <xsl:template match="identical" mode="continue">
    <shell:delete>
      <shell:source><xsl:value-of select="concat($ct-dir,'/inbox/',text(),'.xml')"/></shell:source>
    </shell:delete>
  </xsl:template> 

  <xsl:template name="create-email">
    <xsl:param name="deletions-count"/>
    <xsl:param name="changes-count"/>

    <email:sendmail>
      <email:subject>PMT_Raw: Too many modifications in the feed</email:subject>
      <email:body mime-type="text/plain">
        <xsl:text>Number of deletions: </xsl:text>
        <xsl:value-of select="$deletions-count"/><xsl:text>
</xsl:text>
        <xsl:text>Number of allowed deletions: </xsl:text>
        <xsl:value-of select="$deletions-threshold"/><xsl:text>

</xsl:text>
        <xsl:text>Number of changed products: </xsl:text>
        <xsl:value-of select="$changes-count"/><xsl:text>
</xsl:text>
        <xsl:text>Number of allowed changes: </xsl:text>
        <xsl:value-of select="$changes-threshold"/><xsl:text>
</xsl:text>
      </email:body>
      <xsl:if test="$deletions-count gt 0">
        <email:attachment name="deletedproducts.txt" mime-type="text/plain">
          <email:content>
            <xsl:for-each select="report[@name='deleted-products']/delete">
              <xsl:value-of select="."/>
              <xsl:text>
</xsl:text>
            </xsl:for-each>
          </email:content>
        </email:attachment>
      </xsl:if>

      <xsl:if test="$changes-count gt 0">
        <email:attachment name="changedproducts.txt" mime-type="text/plain">
          <email:content>
            <xsl:for-each select="report[@name='changed-products']/modified">
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
    <xsl:param name="deletions-count"/>
    <xsl:param name="changes-count"/>

    <xsl:variable name="now" select="format-dateTime(current-dateTime(), '[Y0001][M01][D01]T[H01][m01][s01]')"/>
    <source:write>
      <source:source>
        <xsl:value-of select="concat($ct-dir,'/logs/ErrorReport_', $now, '.xml')"/>
      </source:source>
      <source:fragment>
        <error>
          <message>PMT_Raw: Too many modifications in the feed</message>
          <changes actual="{$changes-count}" allowed="{$changes-threshold}">
            <xsl:for-each select="report[@name='changed-products']/modified">
              <id><xsl:value-of select="."/></id>
            </xsl:for-each>
          </changes>
          <deletions actual="{$deletions-count}" allowed="{$deletions-threshold}">
            <xsl:for-each select="report[@name='deleted-products']/delete">
              <id><xsl:value-of select="."/></id>
            </xsl:for-each>
          </deletions>
        </error>
      </source:fragment>
    </source:write>
  </xsl:template>
  
</xsl:stylesheet>
