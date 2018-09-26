<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:info="http://www.philips.com/pikachu/3.0/info"
                xmlns:source="http://apache.org/cocoon/source/1.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="doctimestamp"/>
  <xsl:param name="store_dir"/>
  <xsl:param name="ct_dir"/>
  <xsl:param name="filename"/>  
  <xsl:variable name="ts" select="concat( substring($doctimestamp,1,4)
                                         ,'-'
                                         ,substring($doctimestamp,5,2)
                                         ,'-'
                                         ,substring($doctimestamp,7,2)
                                         ,'T'
                                         ,substring($doctimestamp,9,2)
                                         ,':'
                                         ,substring($doctimestamp,11,2)
                                         ,':'
                                         ,substring($doctimestamp,13,2))"/>
  
  <xsl:variable name="incomingdocument" select="document(concat($ct_dir,'/',$filename,'.xml'))"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/octl">
    <source:write>
      <source:source><xsl:value-of select="concat($store_dir,'/RangeTextCatalog_',$doctimestamp,'_def.xml')"/></source:source>
      <source:fragment>
        <xsl:choose>
          <xsl:when test="sql:rowset/sql:row/sql:data/catalog-definition">
            <xsl:apply-templates select="sql:rowset/sql:row/sql:data/catalog-definition"/>
          </xsl:when>
          <xsl:otherwise>
            <catalog-definition o="RangeTextCatalog" l="none" ct="catalog_definition" DocTimeStamp="{$ts}">
              <xsl:for-each select="$incomingdocument/RangeText_Raw/Nodes/Node">
                <object o="{@code}"/>
              </xsl:for-each>
            </catalog-definition>
          </xsl:otherwise>
        </xsl:choose>
      </source:fragment>
    </source:write>
  </xsl:template>
  
  <xsl:template match="catalog-definition">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*[not(local-name(.) eq 'DocTimeStamp')]"/>
      <xsl:attribute name="DocTimeStamp" select="$ts"/>
      <xsl:variable name="existing"><objects><xsl:copy-of select="object"/></objects></xsl:variable>
      <xsl:apply-templates select="node()"/>
      <xsl:for-each select="$incomingdocument/RangeText_Raw/Nodes/Node">
        <xsl:if test="empty($existing/objects/object[@o=current()/@code])">
          <object o="{@code}"/>
        </xsl:if>              
      </xsl:for-each>            
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
