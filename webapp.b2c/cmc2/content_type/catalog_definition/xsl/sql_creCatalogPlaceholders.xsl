<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="timestamp"/>
  <xsl:param name="destination"/>
  <!-- -->
  <xsl:template match="/root">
    <xsl:variable name="p_objects" select="string-join(sql-rowset/sql-row/sql-object_id, ',')" />
    <!-- test if objects have been triggered -->
    <xsl:if test="string-length($p_objects) > 0"> 
      <xsl:copy>
        <sql:execute-query>
            <sql:query name="sql_creCatalogPlaceholders" isstoredprocedure="true">
                BEGIN
                  PCK_CATALOG.create_catalog_placeholders('<xsl:value-of select="sql-rowset/sql-row[1]/sql-catalog_id"/>',0,'<xsl:value-of select="$p_objects"/>');

                  update catalog_objects
                     set needsprocessing_flag = 0
                   where catalog_id   = '<xsl:value-of select="sql-rowset/sql-row[1]/sql-catalog_id"/>'
                     and lastModified = to_date('<xsl:value-of select="$timestamp"/>', 'yyyy-MM-dd"T"hh24:mi:ss')
                     and needsprocessing_flag > 0
                  ;
                EXCEPTION
                   WHEN OTHERS THEN 
                      RAISE;
                END;
            </sql:query>
        </sql:execute-query>
        <xsl:apply-templates />      
      </xsl:copy>
    </xsl:if>
  </xsl:template>
  <!-- -->
   <xsl:template match="@*|node()">
     <xsl:copy copy-namespaces="no">
       <xsl:apply-templates select="@*|node()"/>
     </xsl:copy>
   </xsl:template>
  <!-- -->
</xsl:stylesheet>