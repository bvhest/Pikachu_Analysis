<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2" 
    exclude-result-prefixes="xsl" 
    extension-element-prefixes="asset-f">

  <xsl:import href="../../common/xsl/xUCDM-external-assets.xsl" />
  
  <xsl:param name="locale" />
  <xsl:param name="ccr-asset-store" />

  <xsl:template match="/">
    <root>
      <xsl:apply-templates select="@*|node()" />
    </root>
  </xsl:template>

  <xsl:template match="sql:rowset/sql:row">
    <xsl:variable name="escid" select="asset-f:escape-scene7-id(sql:object_id)" />
    <xsl:variable name="CTN" select="sql:object_id" />
    <xsl:variable name="InternalResourceIdentifier" select="sql:internalresourceidentifier" />
    <xsl:variable name="PublicResourceIdentifier" select="sql:publicresourceidentifier" />
    <xsl:variable name="ResourceType" select="sql:doctype" />
    <xsl:variable name="Format" select="sql:format" />
    <xsl:variable name="Publisher" select="sql:publisher" />
    <xsl:variable name="base-name">
      <xsl:value-of select="$escid" />
      <xsl:text>-</xsl:text>
      <xsl:value-of select="$ResourceType" />
      <xsl:text>-</xsl:text>
      <xsl:value-of select="if ($locale!='' and $locale != 'master_global') then $locale else 'global'" />
      <xsl:text>-</xsl:text>
    </xsl:variable>
    <xsl:variable name="file-extension">
      <xsl:choose>
        <xsl:when test="starts-with($ResourceType,'PMT')">
          <!-- Check for two trailing slashes -->
          <xsl:analyze-string select="$InternalResourceIdentifier" regex="^(.*)/(.+)/(.+)$">
            <xsl:matching-substring>
              <xsl:value-of select="concat(regex-group(2),'_',regex-group(3),'.xml')" />
            </xsl:matching-substring>
            <xsl:non-matching-substring>
              <xsl:value-of select="'.ERROR'" />
            </xsl:non-matching-substring>
          </xsl:analyze-string>
        </xsl:when>
        <xsl:otherwise>
          <xsl:analyze-string select="$InternalResourceIdentifier" regex="^(.*)\.(.+)$">
            <xsl:matching-substring>
              <xsl:value-of select="concat('.',regex-group(2))" />
            </xsl:matching-substring>
            <xsl:non-matching-substring>
              <xsl:value-of select="'.ERROR'" />
            </xsl:non-matching-substring>
          </xsl:analyze-string>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="filename">
      <xsl:choose>
        <xsl:when test="starts-with($ResourceType,'PMT')">
          <xsl:value-of select="concat($base-name,$file-extension)" />
        </xsl:when>
        <xsl:when test="starts-with($ResourceType,'AWR')">
          <!-- Award ranking picture is sent using a different naming convention based on the rating -->
          <xsl:value-of select="concat((tokenize($PublicResourceIdentifier,'/'))[last()],$file-extension)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($base-name,'001',$file-extension)" />
          <!-- xsl:number value="fn:abs($position)" format="001" /-->
          <!-- xsl:value-of select="$file-extension" /-->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="not(contains($filename,'ERROR'))">
        <xsl:variable name="request">
          <xsl:text>cocoon:/readResource</xsl:text>
          <xsl:text>?mime-type=</xsl:text>
          <xsl:value-of select="$Format" />
          <xsl:text>&amp;filename=</xsl:text>
          <xsl:value-of select="$filename" />
          <xsl:text>&amp;url=</xsl:text>
          <xsl:choose>
            <xsl:when test="$Publisher = 'CCR'">
							<!-- Retrieve directly from the CCR store on disk -->
              <xsl:value-of select="concat($ccr-asset-store,'/',substring-after($InternalResourceIdentifier,'mprdata/'))" />
            </xsl:when>
            <xsl:otherwise>
							<!-- Retrieve from asset URL -->
              <xsl:value-of select="$InternalResourceIdentifier" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <read>
          <xsl:attribute name="CTN"><xsl:value-of select="$CTN" /></xsl:attribute>
          <xsl:attribute name="request"><xsl:value-of select="$request" /></xsl:attribute>
          <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$request}" />
        </read>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>