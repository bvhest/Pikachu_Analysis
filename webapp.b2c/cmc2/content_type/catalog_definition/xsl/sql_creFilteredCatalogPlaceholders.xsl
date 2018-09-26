<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="timestamp"/>
  <xsl:param name="destination"/>
  <!-- -->
  <xsl:template match="/">
     <xsl:apply-templates select="entries/entry/content/catalog-definition"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="catalog-definition">
    <xsl:variable name="p_objects" select="string-join(object/@o, ',')" />
    <!-- in case of a PackagingCatalog, provide a value for the value of the lastmodified-column:  -->
    <xsl:variable name="lastmodified" select="if ($timestamp='') then @DocTimeStamp else $timestamp" />
    <!-- test if objects have been triggered -->
    <xsl:if test="string-length($p_objects) > 0"> 
        <sql:execute-query>
            <sql:query name="sql_creFilteredCatalogPlaceholders" isstoredprocedure="true">
                BEGIN
                  PCK_CATALOG.create_catalog_placeholders('<xsl:value-of select="@o"/>',0,'<xsl:value-of select="$p_objects"/>');

                  update catalog_objects
                     set needsprocessing_flag = 0
                   where catalog_id            = '<xsl:value-of select="@o"/>'
                     and lastModified          = to_date('<xsl:value-of select="$lastmodified"/>', 'yyyy-MM-dd"T"hh24:mi:ss')
                     and needsprocessing_flag != 0
                  ;
                EXCEPTION
                   WHEN OTHERS THEN 
                      RAISE;
                END;
            </sql:query>
        </sql:execute-query>
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