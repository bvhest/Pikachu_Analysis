<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
 xmlns:cmc2-f="http://www.philips.com/cmc2-f" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="cmc2-f" >
  <xsl:template match="content">
  <xsl:copy>
    <sql:execute-query>
      <sql:query>
       update object_categorization oc1
 set deleted = 1, lastmodified = sysdate
 where (oc1.object_id, oc1.subcategory, oc1.catalogcode) in ( 
         select oc.object_id, oc.subcategory, oc.catalogcode from vw_object_categorization oc 
         where oc.catalogcode = '<xsl:value-of select="Catalog/CatalogCode"/>'
         
         minus
		 
         select dc.object_id, dc.subcategory, dc.catalogcode from derivedcat_ext dc 
         where dc.catalogcode = '<xsl:value-of select="Catalog/CatalogCode"/>' 
         
      )
      </sql:query>
    </sql:execute-query>
    <sql:execute-query>
      <sql:query>
update object_categorization oc
 set deleted = 0, lastmodified = sysdate
 where (oc.object_id, oc.subcategory, oc.catalogcode) in ( 
         select dc.object_id, dc.subcategory, dc.catalogcode 
         from derivedcat_ext dc
         where dc.object_id = oc.object_id and dc.subcategory = oc.subcategory and dc.catalogcode = oc.catalogcode 
        )
   and oc.deleted = 1
   and oc.catalogcode = '<xsl:value-of select="Catalog/CatalogCode"/>'
      </sql:query>
    </sql:execute-query>
    <sql:execute-query>
      <sql:query>
         insert into object_categorization obj
           (object_id, subcategory, catalogcode, source, isautogen, object_type, deleted, lastmodified) 
         select distinct dc.object_id, dc.subcategory, dc.catalogcode, dc.source, dc.isautogen, dc.object_type, 0 , sysdate
         
         from derivedcat_ext dc
         
         left outer join object_categorization oc 
           on  oc.object_id = dc.object_id 
          and oc.subcategory = dc.subcategory 
          and oc.catalogcode = dc.catalogcode
         
         where oc.object_id is null
           and dc.catalogcode = '<xsl:value-of select="Catalog/CatalogCode"/>'
      </sql:query>
    </sql:execute-query>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
</xsl:stylesheet>