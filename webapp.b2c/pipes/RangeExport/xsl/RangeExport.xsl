<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
    xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
    exclude-result-prefixes="cinclude sql">
    
  <xsl:include href="../../../cmc2/xsl/common/cmc2.function.xsl"/>
  
  <xsl:param name="locale"/>
  <xsl:param name="masterlocale"/>
  
  <xsl:variable name="assignments">
    <Assignments>
      <xsl:apply-templates select="/root/Assignments/sql:rowset/sql:row">
        <xsl:sort select="sql:object_id"/>
      </xsl:apply-templates>
    </Assignments>
  </xsl:variable>
  <xsl:variable name="catalogs">
    <Catalogs>
      <xsl:apply-templates select="/root/Catalogs/sql:rowset/sql:row/sql:catalog_type">
        <xsl:sort select="."/>
      </xsl:apply-templates>
    </Catalogs>
  </xsl:variable>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/root">
    <xsl:apply-templates select="Nodes"/>
  </xsl:template>
  
  <xsl:template match="Nodes">
    <xsl:copy copy-namespaces="no">
      <xsl:attribute name="DocTimeStamp" select="substring(string(current-dateTime()),1,19)"/>
      <xsl:attribute name="DocStatus" select="'approved'"/>
      <xsl:variable name="allnodes" select="sql:rowset/sql:row/sql:data/Node"/>
      <xsl:for-each select="$catalogs/Catalogs/sql:catalog_type">
        <xsl:apply-templates select="$allnodes[ProductRefs/ProductReference[@ProductReferenceType='assigned']/CTN = $assignments/Assignments/sql:row[sql:customer_id = current()]/sql:object_id]
                                   | $allnodes[ProductRefs/ProductReference[@ProductReferenceType='assigned']/Product/@ctn = $assignments/Assignments/sql:row[sql:customer_id = current()]/sql:object_id]
                                   | $allnodes[ProductReferences/ProductReference[@ProductReferenceType='assigned']/CTN = $assignments/Assignments/sql:row[sql:customer_id = current()]/sql:object_id]">
          <xsl:with-param name="catalog" select="."/>
        </xsl:apply-templates>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sql:row/sql:data/Node">
    <xsl:param name="catalog"/>
    <xsl:variable name="country" select="if($locale = 'MASTER') then 'MASTER' else if($masterlocale = 'yes') then substring-after($locale,'_') else @Country"/>
    <xsl:copy copy-namespaces="no">
      <xsl:choose>
        <xsl:when test="$locale = 'MASTER' or $masterlocale = 'yes'">
          <xsl:apply-templates select="@*[local-name() = ('lastModified','masterLastModified','code','referenceName','nodeType')]"/>
          <xsl:if test="$locale != 'MASTER'">          
            <xsl:attribute name="Country" select="$country"/>
          </xsl:if>            
          <xsl:attribute name="IsMaster" select="'true'"/>
          <xsl:if test="$locale != 'MASTER'">
            <xsl:attribute name="Locale" select="$locale"/>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="@*[local-name() = ('lastModified','masterLastModified','Country','Locale','code','referenceName','nodeType')]"/>
          <xsl:attribute name="IsMaster" select="'false'"/>
        </xsl:otherwise>
      </xsl:choose>
      
      <xsl:apply-templates select="*"/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove any assigned products that are not in any of the country's catalogs -->  
  <xsl:template match="ProductReference[@ProductReferenceType='assigned']/CTN">
    <xsl:if test="exists($assignments/Assignments/sql:row/sql:object_id[.=current()/text()])">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
  <xsl:template match="ProductReference[@ProductReferenceType='assigned']/Product">
    <xsl:if test="exists($assignments/Assignments/sql:row/sql:object_id[.=current()/@ctn])">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>