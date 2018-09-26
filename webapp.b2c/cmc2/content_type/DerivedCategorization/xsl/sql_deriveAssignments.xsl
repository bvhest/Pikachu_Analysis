<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cmc2-f="http://www.philips.com/cmc2-f" xmlns:fn="http://www.philips.com/pikachu/this" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="cmc2-f fn">
  
  <xsl:variable name="apos"><xsl:text>'</xsl:text></xsl:variable>
  
  <xsl:function name="fn:whereClause">
    <xsl:param name="cref"/>
    <xsl:for-each select="tokenize($cref,'/')">
      <xsl:choose>
        <xsl:when test="position()=1"> and c.CATALOGCODE = '<xsl:value-of select="."/>'</xsl:when>
        <xsl:when test="position()=2 and not(. = '*')"> and c.GROUPCODE  = '<xsl:value-of select="."/>'</xsl:when>
        <xsl:when test="position()=3 and not(. = '*')"> and c.CATEGORYCODE = '<xsl:value-of select="."/>'</xsl:when>
        <xsl:when test="position()=4 and not(. = '*')"> and c.SUBCATEGORYCODE = '<xsl:value-of select="."/>'</xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:function>
  
  <xsl:function name="fn:whereClause1">
    <xsl:param name="cref"/>
    <xsl:param name="sourcetree"/>
    <xsl:param name="level"/>
    <xsl:choose>
      <xsl:when test="$level='1'"> and c.CATALOGCODE = '<xsl:value-of select="$sourcetree"/>' and c.GROUPCODE  = '<xsl:value-of select="$cref"/>'</xsl:when>
      <xsl:when test="$level='2'"> and c.CATALOGCODE = '<xsl:value-of select="$sourcetree"/>' and c.CATEGORYCODE = '<xsl:value-of select="$cref"/>'</xsl:when>
      <xsl:when test="$level='3'"> and c.CATALOGCODE = '<xsl:value-of select="$sourcetree"/>' and c.SUBCATEGORYCODE = '<xsl:value-of select="$cref"/>'</xsl:when>
    </xsl:choose>
  </xsl:function>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Care Assignments -->
  <xsl:template match="content">
    <xsl:copy>
      <xsl:apply-templates mode="categorization"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@*|node()" mode="categorization">
    <xsl:apply-templates mode="categorization"/>
  </xsl:template>
  
  <xsl:template match="SubCategory" mode="categorization">
    <xsl:variable name="source" select="ancestor::entries/@batchnumber"/>
    <xsl:variable name="objectId" select="SubCategoryCode"/>
    <xsl:variable name="catalogCode" select="ancestor::Catalog/CatalogCode"/>
    
    <xsl:for-each select="CatRef">
      <xsl:variable name="productCatalogs" select="if (@productCatalog != '') then tokenize(@productCatalog,'\s*,\s*') else ($catalogCode)"/>
      <xsl:variable name="CatRefNode" select="if(contains(.,'[')) then substring-before(.,'[') else ."/>
      <xsl:variable name="CatRefValue" select="if(contains(.,'[')) then substring-before(substring-after(.,'['),']') else ''"/>
      <xsl:variable name="CatRefLevel" select="./@level"/>
      <xsl:variable name="CatRefSourceTree" select="./@sourcetree"/>
      <sql:execute-query>
        <sql:query>
          <xsl:if test="$CatRefValue != ''">        
            select DISTINCT v.object_id, v.subcategory,
                            v.catalogcode, v.SOURCE, v.isautogen,
                            v.object_type 
            from (        
          </xsl:if>
          <xsl:variable name="value-codes" select="tokenize(replace($CatRefValue,'\s+', ''), '\+')"/>
          <xsl:for-each select="tokenize($CatRefNode,'\+')">
            <xsl:if test="not(position() = 1)">
              <xsl:text> intersect </xsl:text>
            </xsl:if>
              select distinct oc.object_id 
                            ,'<xsl:value-of select="$objectId"/>' subcategory
                            ,'<xsl:value-of select="$catalogCode"/>'  catalogcode
                            ,'<xsl:value-of select="$source"/>' source
                            ,1 isautogen
                            ,'Product' object_type
              from categorization c
              inner join object_categorization oc
                 on oc.subcategory = c.subcategorycode
                and oc.catalogcode = c.catalogcode
                and oc.deleted = 0
              where exists (select 1 
                            from catalog_objects co 
                            where co.object_id   = oc.object_id 
                              and co.customer_id in ('<xsl:value-of select="string-join($productCatalogs,concat($apos,',',$apos))"/>')
                           )
            <xsl:choose>
              <xsl:when test="$CatRefSourceTree">
                <xsl:value-of select="fn:whereClause1(., $CatRefSourceTree, $CatRefLevel)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="fn:whereClause(.)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
          <xsl:if test="$CatRefValue != ''">        
            ) v
            inner join keyvaluepairs k on k.ctn = v.object_id
            and k.value in ('<xsl:value-of select="string-join($value-codes,concat($apos,',', $apos))"/>')
            <xsl:if test="count($value-codes) gt 1">
              <!-- Make sure all value codes are present -->
              group by v.object_id, v.subcategory,
                v.catalogcode, v.SOURCE, v.isautogen,
                v.object_type
              having count(*) = <xsl:value-of select="count($value-codes)"/>
            </xsl:if>
          </xsl:if>
        </sql:query>
      </sql:execute-query>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
