<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="locale">en_UK</xsl:param>
  <xsl:param name="catalogcode"/>

  <xsl:template match="/">
  <root>
	<xsl:attribute name="locale"><xsl:value-of select="$locale"/></xsl:attribute>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        select s.CatalogCode
             , s.CatalogName
             , s.pdcode
             , s.pdname
             , s.bgroupcode
             , s.bgroupname
             , s.groupcode
             , s.groupname
             , s.categorycode
             , s.categoryname
             , s.SubCategoryCode
             , s.SubCategoryName
             , nvl(count(oc.object_id),0) count
          from categorization s 
	left outer join vw_object_categorization  oc
            on oc.catalogcode = s.catalogcode
            and oc.SubCategory =  s.SubCategorycode
         where s.catalogcode = '<xsl:value-of select="$catalogcode"/>'        
      group by s.CatalogCode
             , s.CatalogName
             , s.pdcode
             , s.pdname
             , s.bgroupcode
             , s.bgroupname
             , s.groupcode
             , s.groupname
             , s.categorycode
             , s.categoryname
             , s.SubCategoryCode
             , s.SubCategoryName
             order by 1,11     
      --order by 1,3,5,7,9,11     
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>
