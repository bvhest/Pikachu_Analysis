<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:source="http://apache.org/cocoon/source/1.0">
  <!--  -->    

  <xsl:param name="targetDir"/>
  
  <xsl:template match="node()|@*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/">
    <root>
      <xsl:for-each select="/root/root">
        <xsl:variable name="cache" select="cache"/>
        <xsl:variable name="merged" select="merged"/>
       
        <xsl:if test="$merged/Users/User/@accountID != ''">
          <xsl:if test="not(deep-equal($cache/Users/User, $merged/Users/User))">
            <source:write>
              <source:source><xsl:value-of select="$targetDir"/><xsl:text>/UAP_</xsl:text><xsl:value-of select="$merged/Users/User/@accountID"/><xsl:text>.xml</xsl:text></source:source>      
              <source:fragment><xsl:apply-templates select="merged/Users"/></source:fragment>
            </source:write>
        </xsl:if>
        </xsl:if>
      </xsl:for-each>
      
      <xsl:for-each select="/root/delete">
        <xsl:apply-templates/>
      </xsl:for-each>

    </root>
  </xsl:template>
</xsl:stylesheet>