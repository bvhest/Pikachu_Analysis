<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0">
  
  <xsl:import href="filter.xsl"/>
  <xsl:import href="../em-functions.xsl"/>
 
  <xsl:template match="FixedCategorization">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
        <xsl:when test="$nodeType = 'division'">
          <xsl:apply-templates select="ProductDivision[ProductDivisionCode = $nodeID]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="ProductDivision"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ProductDivision">
    <xsl:variable name="division">
      <xsl:copy>
        <xsl:apply-templates select="@*|*[local-name()!='BusinessGroup']"/>
        <xsl:choose>
          <xsl:when test="$nodeType = 'bg'">
            <xsl:apply-templates select="BusinessGroup[BusinessGroupCode = $nodeID]"/>
          </xsl:when>
          <xsl:when test="$nodeType = 'bgmip'">
            <xsl:apply-templates select="BusinessGroup[BusinessGroupCode = ('6911','6918','9042','9044','9050','9051')]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="BusinessGroup"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:copy>
    </xsl:variable>
    
    <xsl:if test="$division/ProductDivision/BusinessGroup">
      <xsl:copy-of select="$division"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="BusinessGroup">
    <xsl:variable name="businessGroup">
      <xsl:copy>
        <xsl:apply-templates select="@*|*[local-name()!='Group']"/>
        <xsl:choose>
          <xsl:when test="$nodeType = 'group'">
            <xsl:apply-templates select="Group[GroupCode = $nodeID]"/>
          </xsl:when>
          <xsl:when test="$nodeType = 'bgmip'">
            <xsl:apply-templates select="Group[not(GroupCode = ('0624','0655','0661'))]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="Group"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:copy>
    </xsl:variable>
    
    <xsl:if test="$businessGroup/BusinessGroup/Group">
      <xsl:copy-of select="$businessGroup"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="Group">
    <xsl:variable name="group">
      <xsl:copy>
        <xsl:apply-templates select="@*|*[local-name()!='Category']"/>
        <xsl:choose>
          <xsl:when test="$nodeType = 'category'">
            <xsl:apply-templates select="Category[CategoryCode = $nodeID]"/>
          </xsl:when>
          <xsl:when test="$nodeType = 'bgmip'">
            <xsl:apply-templates select="Category[not(CategoryCode = ('E82','X13','C97','D22','D25','D27','D30','D37','D42'))]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="Category"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:copy>
    </xsl:variable>
    <xsl:if test="$group/Group/Category">
      <xsl:copy-of select="$group"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="SubCategory">
    <xsl:if test="not(SubCategoryCode = ('7651','7666','2166','7909','7911','7939','7918','7920','7921','7922','7923','7928','7931','1208','1848',
                                         '2023','2029','2032','2192','2359','2614','2635','2636','2393','2394','2041','2634','3758','3961','3967',
                                         '3970','3994','2642','2645','3488'))">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      
        <xsl:if test="$includeProductAssignments = 'true'">
          <xsl:variable name="oc-cat" select="svc:objectcat-code-for-catalog-code($categorizationID)"/>
  
          <sql:execute-query>
            <sql:query>
              select voc.object_id, voc.lastmodified, voc.deleted, pp.namingstringshort
              from object_categorization voc
              left join pms_products pp
              on voc.object_id = pp.ctn
              where voc.catalogcode = '<xsl:value-of select="$oc-cat"/>'
              and voc.subcategory   = '<xsl:value-of select="SubCategoryCode"/>'
              order by voc.object_id
            </sql:query>
          </sql:execute-query>
        </xsl:if>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
