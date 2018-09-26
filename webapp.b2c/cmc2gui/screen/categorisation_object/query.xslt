<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1"/>
  <xsl:param name="param2"/>
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:attribute name="id"><xsl:value-of select="$param1"/></xsl:attribute>
      <xsl:attribute name="catalogcode"><xsl:value-of select="$param2"/></xsl:attribute>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
          select omd.object_id
               , omd.division
               , omd.display_name
               , omd.object_type
               , o.status
               , TO_CHAR(o.masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
               , TO_CHAR(o.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts
               , o.content_type
               , o.localisation
               , oc.CATALOGCODE
          from vw_object_categorization oc inner join object_master_data omd
            on oc.object_id = omd.OBJECT_ID
inner join octl o
            on o.object_id = oc.object_id 
         where subcategory = '<xsl:value-of select="$param1"/>'
           and catalogcode = '<xsl:value-of select="$param2"/>'
           and o.content_type = 'PMT_Raw'
           union
          select oc.object_id
               , 'CLS' division
               , oc.object_id display_name
               , 'PCT' object_type
               , o.status
               , TO_CHAR(o.masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
               , TO_CHAR(o.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts
               , o.content_type
               , o.localisation          
               , oc.CATALOGCODE               
            from vw_object_categorization oc
      inner join octl o 
              on o.object_id = oc.object_id 
           where subcategory = '<xsl:value-of select="$param1"/>'
             and catalogcode = '<xsl:value-of select="$param2"/>'
             and o.content_type = 'PCT_Raw'           
      order by object_id
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
