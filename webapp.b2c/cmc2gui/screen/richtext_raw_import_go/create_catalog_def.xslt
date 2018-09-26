<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:info="http://www.philips.com/pikachu/3.0/info"
                xmlns:source="http://apache.org/cocoon/source/1.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="project_code"/>
  <xsl:param name="store_dir"/>
  
  <xsl:variable name="current-datetime" select="replace(string(current-dateTime()),'.*(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}).*','$1')"/>
  <xsl:variable name="current-timestamp" select="replace($current-datetime,'[^0-9]','')"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/octl">
    <source:write>
      <source:source><xsl:value-of select="concat($store_dir,'/RichTextCatalog_',$current-timestamp,'_def.xml')"/></source:source>
      <source:fragment>
        <xsl:choose>
          <xsl:when test="sql:rowset/sql:row/sql:data/catalog-definition">
            <xsl:apply-templates select="sql:rowset/sql:row/sql:data/catalog-definition"/>
          </xsl:when>
          <xsl:otherwise>
            <catalog-definition o="PackagingCatalog" l="none" ct="catalog_definition" DocTimeStamp="{$current-datetime}">
              <object o="{$project_code}"/>
            </catalog-definition>
          </xsl:otherwise>
        </xsl:choose>
      </source:fragment>
    </source:write>
  </xsl:template>
  
  <xsl:template match="catalog-definition">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*[not(local-name(.) eq 'DocTimeStamp')]"/>
      <xsl:attribute name="DocTimeStamp" select="$current-datetime"/>
      <xsl:apply-templates select="node()"/>
      <xsl:if test="empty(object[@o='Rich])">
        <object o="{$project_code}"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
