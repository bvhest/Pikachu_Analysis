<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="AssetsToCompare">
    <xsl:copy copy-namespaces="no">
      <xsl:choose>
        <xsl:when test="deep-equal(ObjectsMsg[1]/Object,ObjectsMsg[2]/Object)">
          <remove objectid="{ObjectsMsg[1]/Object/ObjectID}"/>
        </xsl:when>
        <xsl:otherwise>
          <keep objectid="{ObjectsMsg[1]/Object/ObjectID}">
            <xsl:apply-templates select="store"/>
          </keep>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="root">
    <FilterAssets>
      <xsl:choose>
         <xsl:when test="deep-equal(delta/ObjectsMsg/Object,cache/ObjectsMsg/Object)">
           <remove objectid="{delta/ObjectsMsg/Object/ObjectID}"/>
         </xsl:when>
         <xsl:otherwise>
           <keep objectid="{delta/ObjectsMsg/Object/ObjectID}">
            <xsl:apply-templates select="store"/>
          </keep>
         </xsl:otherwise>
      </xsl:choose>
    </FilterAssets>
  </xsl:template>  
</xsl:stylesheet>
