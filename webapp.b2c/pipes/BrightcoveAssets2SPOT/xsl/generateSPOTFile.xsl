<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="dir xs xsl">
  <!-- 
     | BHE (2/10/2009): - changed ProductsMsg/@version from "1.0" to 2.0
     |                  - removed copy of CTN element.
     |-->
  <xsl:param name="targetDir"/>
  <xsl:param name="cacheDir"/>
  <xsl:param name="deletedAssetsReport"/>
  <!-- -->
  <xsl:variable name="timestamp" select="substring(xs:string(current-dateTime()),1,19)"/>
  <xsl:variable name="timestampnumeric" select="replace(replace(replace($timestamp,':',''),'-',''),'T','')"/>
  <xsl:variable name="v_deletedAssetsReport" select="document(concat('../',$deletedAssetsReport))"/>
  <!-- -->
  <xsl:template match="/dir:directory">
    <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
      <source:source><xsl:value-of select="concat($targetDir,'/xSPOT_Asset_020.PMT.',$timestampnumeric,'.xml')"/></source:source>
      <source:fragment>
        <ProductsMsg docTimestamp="{$timestamp}" version="2.0">
          <!-- deleted assets -->
          <xsl:apply-templates select="$v_deletedAssetsReport/root/ProductsMsg/Product">
            <xsl:sort select="CTN"/>
          </xsl:apply-templates>
          <!-- changed assets -->
          <xsl:for-each select="dir:file/dir:xpath/Product">
          <Product>
            <xsl:variable name="cachedDoc" select="if(doc-available(concat('../',$cacheDir,replace(CTN,'/','_'),'.xml')))
                                                   then doc(concat('../',$cacheDir,replace(CTN,'/','_'),'.xml'))
                                                   else ()"/>
            <xsl:variable name="incomingDoc" select="."/>
            <xsl:variable name="content">
              <xsl:for-each select="Asset">
                <xsl:copy-of select="."/>
              </xsl:for-each>
              <xsl:for-each select="$cachedDoc/ProductsMsg/Product/Asset">
                <xsl:choose>
                  <xsl:when test="$incomingDoc/Asset[ResourceType = current()/ResourceType and Language = current()/Language]"/>
                    <!-- do nothing -->
                  <xsl:otherwise>
                     <xsl:apply-templates select="." mode="copydeletedasset"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:variable>
<!-- BHE: element CTN is not conform the latest XML Schema: removed 6/10/2009.
            <xsl:copy-of select="CTN"/>
-->
            <ObjectType>CTV</ObjectType>
            <ObjectKey><xsl:value-of select="CTN"/></ObjectKey>
            <CTV_ID><xsl:value-of select="CTN"/></CTV_ID>            
            <xsl:apply-templates select="$content">
              <xsl:sort select="ResourceType"/>
              <xsl:sort select="Language"/>
            </xsl:apply-templates>
          </Product>
          </xsl:for-each>
        </ProductsMsg>
      </source:fragment>
    </source:write>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()" mode="copydeletedasset">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="copydeletedasset"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="License" mode="copydeletedasset">
    <License>Obsolete</License>
  </xsl:template>
  <!-- filter out CTN's -->
  <xsl:template match="CTN" />
</xsl:stylesheet>
