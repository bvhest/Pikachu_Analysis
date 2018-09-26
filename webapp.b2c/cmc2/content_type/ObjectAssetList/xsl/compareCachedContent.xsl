<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:variable name="debug" select="false()"/>
  <xsl:template match="ObjectAssetsToCompare">
    <xsl:variable name="cachedContent">
      <xsl:apply-templates select="ObjectsMsg[1]/Object" mode="copy"/>
    </xsl:variable>
    <xsl:variable name="newContent">
      <xsl:apply-templates select="ObjectsMsg[2]/Object" mode="copy"/>
    </xsl:variable>
    <FilterObjectAssets>
      <xsl:choose>
        <xsl:when test="deep-equal($cachedContent,$newContent)">
          <identical><xsl:value-of select="ObjectsMsg[1]/Object/ObjectID"/></identical>
        </xsl:when>
        <xsl:otherwise>not equal</xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$debug">
       <xsl:variable name="isidentical" select="deep-equal($cachedContent,$newContent)"/>
        <compare isidentical="{$isidentical}">
          <currentContent><xsl:copy-of select="$cachedContent"/></currentContent>
          <newContent><xsl:copy-of select="$newContent"/></newContent>
        </compare>
      </xsl:if>      
    </FilterObjectAssets>
  </xsl:template>  
  <!-- -->
  <xsl:template match="@*|node()" mode="copy">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="copy"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="Object" mode="copy">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*" mode="copy"/>
      <xsl:apply-templates select="node()[local-name()!='Asset']" mode="copy"/>
      <xsl:apply-templates select="Asset" mode="copy">
        <xsl:sort select="ResourceType"/>
        <xsl:sort select="Language"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  <!-- -->  
  <!-- Filter out BLR assets (low-res Brand logo) and GAL (Global Award Master) -->
  <xsl:template match="Asset[ResourceType=('BLR','GAL')]" mode="copy"/>    
  <!-- Ignore LastModified TS and Creator -->    
  <xsl:template match="Asset/Modified" mode="copy"/>      
  <xsl:template match="Asset/Creator" mode="copy"/>      
  <!-- Ignore whitespace-only nodes -->    
  <xsl:template match="text()[normalize-space() = '']" mode="copy"/>  
</xsl:stylesheet>
