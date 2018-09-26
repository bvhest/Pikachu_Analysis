<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
  exclude-result-prefixes="sql"
  >

  <xsl:param name="ts" />

  <xsl:template match="/">
    <root>
      <xsl:apply-templates select="root/sql:rowset/sql:row"/>
    </root>
  </xsl:template>

  <xsl:template match="sql:row">
    <cinclude:include>
      <xsl:attribute name="src" select="concat('cocoon:/exportAssets.', $ts, '.', sql:locale)" />
    </cinclude:include>
    <!-- Disabled until Scene7 processes deletions. Also needs code fix. -->
    <!-- cinclude:include>
      <xsl:attribute name="src" select="concat('cocoon:/deletedAssetsList.', $ts, '.', sql:locale)" />
    </cinclude:include -->
    <cinclude:include>
      <xsl:attribute name="src" select="concat('cocoon:/updateTimestamps.', $ts, '.', sql:locale)" />
    </cinclude:include>
  </xsl:template>

</xsl:stylesheet>