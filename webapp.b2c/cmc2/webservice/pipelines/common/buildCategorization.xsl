<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:template match="/">
    <object-categorization>  
      <xsl:apply-templates select="sql:rowset/sql:row"/>
    </object-categorization>
  </xsl:template>
  
  <xsl:template match="sql:row">
    <object>
      <id>
        <xsl:value-of select="sql:object_id"/>
      </id>
      <categorizations>
        <internal-categorization>
          <xsl:apply-templates select="*"/>
        </internal-categorization>
      </categorizations>
    </object>
  </xsl:template>

  <xsl:template match="sql:object_id"/>

  <xsl:template match="sql:groupcode">
    <GroupCode>
      <xsl:value-of select="."/>
    </GroupCode>
  </xsl:template>
  
  <xsl:template match="sql:categorycode">
    <CategoryCode>
      <xsl:value-of select="."/>
    </CategoryCode>
  </xsl:template>

  <xsl:template match="sql:subcategorycode">
    <SubCategoryCode>
      <xsl:value-of select="."/>
    </SubCategoryCode>
  </xsl:template>
</xsl:stylesheet>
