<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:include href="pmsBase.xsl"/>
  
  <xsl:template match="content[ancestor::entry/@valid='true']">
    <xsl:variable name="object" select="ancestor::entry/@o" />
    <xsl:copy>
      <sql:execute-query>
        <sql:query name="Categorization">
          SELECT oc.catalogcode
               , c.bgroupcode bugroupcode
               , c.bgroupname bugroupname
               , c.groupcode groupcode
               , c.groupname groupname
               , c.categorycode catcode
               , c.categoryname catname
               , c.subcategorycode subcatcode
               , c.subcategoryname subcatname
            from vw_object_categorization oc
           inner join categorization c
              on c.subcategorycode = oc.subcategory
             and c.catalogcode     = oc.catalogcode
             and oc.catalogcode    = 'MASTER'
           where oc.object_id      = '<xsl:value-of select="$object" />'
        </sql:query>
      </sql:execute-query>

      <xsl:apply-templates select="@*|node()" />

    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
