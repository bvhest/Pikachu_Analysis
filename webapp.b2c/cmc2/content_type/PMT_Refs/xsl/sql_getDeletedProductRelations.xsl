<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="ct"/>

  <xsl:template match="/">
    <root>
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
        <sql:execute-query>
          <sql:query>
            <!-- retrieve 'Deleted' accessories -->
            select unique object_id_tgt as object_id 
              from object_relations
             where rel_type      = 'PRD_ACC'
               and deleted       = 1
             order by 1
          </sql:query>
        </sql:execute-query>
      </xsl:copy>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>