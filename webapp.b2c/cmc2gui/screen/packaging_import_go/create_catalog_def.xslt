<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:source="http://apache.org/cocoon/source/1.0"
                >

  <xsl:param name="project_code"/>
  <xsl:param name="store_dir"/>
  
  <xsl:variable name="current-datetime" select="replace(string(current-dateTime()),'.*(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}).*','$1')"/>
  <xsl:variable name="current-timestamp" select="replace($current-datetime,'[^0-9]','')"/>
  
  <xsl:template match="/root">
    <source:write>
      <source:source><xsl:value-of select="concat($store_dir,'/PackagingCatalog_',$current-timestamp,'_def.xml')"/></source:source>
      <source:fragment>
        <catalog-definition o="PackagingCatalog" l="none" ct="catalog_definition" DocTimeStamp="{$current-datetime}">
          <object o="{$project_code}"/>
        </catalog-definition>
      </source:fragment>
    </source:write>
  </xsl:template>
  
</xsl:stylesheet>
