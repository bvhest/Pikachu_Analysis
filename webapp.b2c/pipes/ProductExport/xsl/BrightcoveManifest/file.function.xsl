<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet   version="2.0" 
                  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                  xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                  xmlns:xs="http://www.w3.org/2001/XMLSchema"
				 xmlns:my="http://www.philips.com/local"
				 xmlns:cmc2-f="http://www.philips.com/cmc2-f"
                  extension-element-prefixes="cmc2-f my"
                  exclude-result-prefixes="sql xs"
                  >  
  <!-- -->
  <xsl:import href="../../../../cmc2/xsl/common/cmc2.function.xsl"/>
<!-- -->
  <xsl:function name="my:get-file-name">
    <xsl:param name="id"/>
    <xsl:param name="asset"/>
    
    <xsl:variable name="file-name">
      <xsl:variable name="suffix" select="my:get-file-suffix($asset)"/>
  
      <xsl:choose>
        <xsl:when test="$asset/ResourceType = 'AWR'">
          <!-- Award ranking picture is sent using a different naming convention based on the rating -->
          <xsl:value-of select="concat((tokenize($asset/PublicResourceIdentifier,'/'))[last()],$suffix)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="esc-id" select="cmc2-f:escape-scene7-id($id)"/>
          
          <xsl:if test="$suffix != ''">
            <xsl:value-of select="$esc-id"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="$asset/ResourceType"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="if ($asset/Language!='') then $asset/Language else 'global'"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="$suffix"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:value-of select="$file-name"/>
  </xsl:function>
  
  <xsl:function name="my:get-file-suffix">
    <xsl:param name="asset"/>
    <xsl:choose>
      <xsl:when test="starts-with($asset/ResourceType,'PMT')">
        <!-- Check for two slashes in the URL -->
        <xsl:analyze-string select="$asset/InternalResourceIdentifier" regex="^(.*)/(.+)/(.+)$">
          <xsl:matching-substring>
            <xsl:value-of select="concat(regex-group(2),'_',regex-group(3),'.xml')" />
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:otherwise>
        <xsl:analyze-string select="$asset/InternalResourceIdentifier" regex="^(.*)\.(.+)$">
          <xsl:matching-substring>
            <xsl:choose>
              <xsl:when test="$asset/ResourceType = 'AWR'">
                <xsl:value-of select="concat('.',regex-group(2))" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('001.',regex-group(2))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:otherwise>
    </xsl:choose>        
  </xsl:function>
  <!-- -->
</xsl:stylesheet>  
