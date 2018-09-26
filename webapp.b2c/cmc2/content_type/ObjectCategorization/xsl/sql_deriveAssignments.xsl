<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
 xmlns:cmc2-f="http://www.philips.com/cmc2-f" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="cmc2-f" >
  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:param name="ts"/>
  <xsl:param name="dir"/>
  <xsl:param name="sourcefile"/>
  <xsl:include href="../../../xsl/common/cmc2.function.xsl"/>
  <xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)" />
  <xsl:variable name="source" select="substring-before($sourcefile,'.xml')"/>
  <!-- Care Assignments -->
  <xsl:template match="/Categorization[Catalog/CatalogCode = 'CARE']">
    <entries ct="{$ct}" l="{$l}" ts="{$ts}" dir="{$dir}" batchnumber="{$sourcefile}" valid="true">
      <xsl:apply-templates mode="CareCategorization"/>
    </entries>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()" mode="CareCategorization">
    <xsl:apply-templates mode="CareCategorization"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="SubCategory" mode="CareCategorization">
    <xsl:variable name="contentType" select="$ct"/>
    <xsl:variable name="localisation" select="'none'"/>
    <xsl:variable name="masterLastmodifiedTimestamp" select="substring(../../../../../../@DocTimeStamp,1,19)"/>
    <xsl:variable name="objectId" select="SubCategoryCode"/>
        <xsl:for-each select="CatRef">
          <xsl:variable name="CatRefNode" select="if(contains(.,'[')) then substring-before(.,'[') else ."/>
          <xsl:variable name="CatRefKey" select="if(contains(.,'[')) then substring-before(substring-after(.,'['),'=') else ''"/>
          <xsl:variable name="CatRefValue" select="if(contains(.,'[')) then substring-before(substring-after(substring-after(.,'['),'='),']') else ''"/>
   				<sql:execute-query>
  					<sql:query>
            <!--
              insert into vw_object_categorization(object_id, subcategory, catalogcode, source, isautogen, object_type)
              ( -->
               select distinct oc.object_id 
                              ,'<xsl:value-of select="$objectId"/>' subcategory
                              ,'CARE' catalogcode
                              ,'<xsl:value-of select="$source"/>' source
                              ,1 isautogen
                              ,'Product' object_type
                    from vw_object_categorization oc
              inner join categorization c
                      on oc.subcategory = c.subcategorycode
              <xsl:if test="$CatRefKey != ''">
              inner join keyvaluepairs k
                      on oc.object_id = k.ctn
              </xsl:if>
              where oc.catalogcode = 'MASTER'
              <xsl:choose>
                <xsl:when test="@level='1'">and c.groupcode = '<xsl:value-of select="$CatRefNode"/>'</xsl:when>
                <xsl:when test="@level='2'">and c.categorycode = '<xsl:value-of select="$CatRefNode"/>'</xsl:when>
                <xsl:when test="@level='3'">and c.subcategorycode = '<xsl:value-of select="$CatRefNode"/>'</xsl:when>
              </xsl:choose>
              <xsl:if test="$CatRefKey != ''">
                and k.key = '<xsl:value-of select="$CatRefKey"/>'
                and k.value = '<xsl:value-of select="$CatRefValue"/>'
              </xsl:if>
             <!-- ) -->
  					</sql:query>
  				</sql:execute-query>
       </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
