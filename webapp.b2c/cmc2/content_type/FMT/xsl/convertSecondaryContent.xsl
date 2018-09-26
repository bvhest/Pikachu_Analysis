<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    exclude-result-prefixes="sql">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ObjectAssetList">      
    <xsl:variable name="objectassets">
      <!-- Merge assets from primary data and secondary data -->
      <xsl:for-each-group select="octl/sql:rowset/sql:row|Object" group-by="concat(sql:object_id,id)">
        <Object>       
          <id><xsl:value-of select="current-grouping-key()"/></id>
          <xsl:for-each select="current-group()/sql:data/object/Asset[ResourceType!='BLR']|current-group()/Asset[ResourceType!='BLR']">
            <xsl:sort select="ResourceType"/>
            <xsl:apply-templates select="."/>
          </xsl:for-each>
        </Object>
      </xsl:for-each-group>
    </xsl:variable>
    <xsl:copy>
     <xsl:apply-templates select="$objectassets/Object">
       <xsl:sort select="id"/>
     </xsl:apply-templates>
     
     <xsl:apply-templates/>
    </xsl:copy>
    
    <!-- Copy the secondary relations that have to be created -->
    <xsl:apply-templates select="secondary-relation"/>
  </xsl:template>
    
  <xsl:template match="octl[sql:rowset]"/>
</xsl:stylesheet>
