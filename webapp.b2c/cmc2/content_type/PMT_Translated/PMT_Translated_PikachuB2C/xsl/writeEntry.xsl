<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- 
    This import converts any translated files that are still in xUCDM product marketing 1.1 format
    to xUCDM product marketing 1.2.
    If it is certain that all 1.1 translation files have returned this import can be removed and
    the copy template has to be activated.
  -->
  <xsl:import href="../../../../xsl/common/xucdm_pm11_to_pm12.xsl"/>
  
  <xsl:param name="dir"/>
  <xsl:param name="prefix"/>
  <xsl:param name="filename"/>

  <!-- Activate when 1.1 to 1.2 conversion stylesheet import is disabled
  <xsl:template match="@*|node()" mode="#all">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  -->
  
  <xsl:template match="entries">
    <xsl:variable name="mode">
        <xsl:choose>
          <xsl:when test="starts-with($prefix,'ex_')">
            <xsl:text>export</xsl:text>
          </xsl:when>
          <xsl:when test="starts-with($prefix,'im_')">
            <xsl:text>import</xsl:text>
          </xsl:when>
        </xsl:choose>
    </xsl:variable>
    
    <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
      <source:source>
        <xsl:choose>
          <xsl:when test="$mode='export'">
            <xsl:value-of select="concat($dir,'/temp/',$prefix,@category,'_',@workflow,'_entry_',@ts,'.',@l,'.',@batchnumber,'.xml')"/> 
          </xsl:when>  
          <xsl:when test="$mode='import'">          
            <xsl:value-of select="concat($dir,'/temp/',$prefix,@category,'_',@workflow,'_entry_',@ts,'.',@l,'.',@batchnumber,'.',@subbatchnumber,'.xml')"/> 
          </xsl:when>  
        </xsl:choose>
      </source:source>
      <source:fragment>
        <xsl:copy copy-namespaces="no">
          <xsl:choose>
            <xsl:when test="$mode='import'">
              <xsl:apply-templates select="@*|node()"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="@*|node()" mode="copy-as-is"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:copy>
      </source:fragment>
    </source:write>
  </xsl:template>

  <!-- Override RichText processing to not merge RichTexts -->
  <xsl:template match="RichTexts">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
