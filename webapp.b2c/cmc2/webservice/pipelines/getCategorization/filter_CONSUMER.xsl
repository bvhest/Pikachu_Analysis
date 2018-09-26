<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0">
  
  <xsl:import href="../service-base.xsl"/>
  
  <xsl:param name="userID" select="''"/>
  <xsl:param name="scopeRestriction" select="'All'"/>
  
  <xsl:param name="categorizationID"/>
  <xsl:param name="locale"/>
  <xsl:param name="nodeType"/>
  <xsl:param name="nodeID"/>
  <xsl:param name="includeProductAssignments"/>
  
  <xsl:template match="octl|sql:*">
    <xsl:apply-templates select="*"/>
  </xsl:template>  

  <xsl:template match="FixedCategorization">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
        <xsl:when test="$nodeType = 'group'">
          <xsl:apply-templates select="ProductDivision/BusinessGroup/Group[GroupCode = $nodeID]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="ProductDivision/BusinessGroup/Group"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
    
  <xsl:template match="Group">
    <xsl:variable name="group">
      <xsl:copy>
        <xsl:apply-templates select="@*|*[local-name()!='Category']"/>
        <xsl:choose>
          <xsl:when test="$nodeType = 'category'">
            <xsl:apply-templates select="Category[CategoryCode = $nodeID]"/>
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

  <xsl:template match="Category">
    <xsl:variable name="cat">
      <xsl:copy>
        <xsl:apply-templates select="@*|*[local-name()!='SubCategory']"/>
        <xsl:choose>
          <xsl:when test="$nodeType = 'subcategory'">
            <!-- 
             <xsl:apply-templates select="SubCategory[@status='Active'][SubCategoryCode = $nodeID][svc:subcat-allowed($uap,SubCategoryCode)]"/>
             -->
            <xsl:apply-templates select="L3/L4/L5/L6/SubCategory[@status=('Active', 'PhasedOut','active')][SubCategoryCode = $nodeID]"/> 
          </xsl:when>
          <xsl:otherwise>
            <!-- 
            <xsl:apply-templates select="SubCategory[@status='Active']"/>
            -->
            <xsl:apply-templates select="L3/L4/L5/L6/SubCategory[@status=('Active', 'PhasedOut','active')][if ($scopeRestriction='My') 
                                                                      then (svc:subcat-allowed($uap,SubCategoryCode)) 
                                                                      else ('true')]"/>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:copy>
    </xsl:variable>
    <xsl:if test="$cat/Category/SubCategory">
      <xsl:copy-of select="$cat"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="SubCategory">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      
      <xsl:if test="$includeProductAssignments = 'true'">
        <xsl:variable name="oc-cat" select="svc:objectcat-code-for-catalog-code($categorizationID)"/>
  
        <sql:execute-query>
          <sql:query>
            select voc.object_id, voc.lastmodified, voc.deleted, pp.namingstringshort
            from vw_object_categorization voc
            inner join pms_products pp
            on voc.object_id = pp.ctn
            where voc.catalogcode = '<xsl:value-of select="$oc-cat"/>'
            and voc.subcategory   = '<xsl:value-of select="SubCategoryCode"/>'
            order by voc.object_id
          </sql:query>
        </sql:execute-query>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
