<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:param name="catalogCode" select="'CONSUMER'"/>
  <xsl:param name="objectId"/>
  
  <xsl:template match="/root">
      <sql:execute-query>
        <sql:query>
          select oc.object_id, c.groupcode, c.categorycode, c.subcategorycode 
            from vw_object_categorization oc
           inner join categorization c 
              on c.catalogcode     = '<xsl:value-of select="$catalogCode"/>'
             and c.subcategorycode = oc.subcategory
           where oc.object_id   = '<xsl:value-of select="$objectId"/>'
             and oc.catalogcode = c.catalogcode
        </sql:query>
      </sql:execute-query>
  </xsl:template>
</xsl:stylesheet>
