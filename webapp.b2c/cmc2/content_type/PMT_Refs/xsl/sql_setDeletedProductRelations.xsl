<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    >

  <xsl:param name="ct"/>
  <xsl:param name="locale"/>
  
  <xsl:variable name="apos"><xsl:text>'</xsl:text></xsl:variable>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/root">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <!-- process the deletes if present -->
      <xsl:if test="delete">
        
        <!--
          Select per 500 to avoid the database limit of the in operator.
          If the number of products becomes very large the processing
          should really be implemented as a batched process.
          
          Trigger related product PMT_Master-records for processing
          is performed with a trigger on the object_relations table:

        -->
        <xsl:for-each-group select="delete" group-by="(position() - 1)  idiv 500">
          <sql:execute-query name="updateDeletedObjRelations">
            <sql:query name="updateDeletedObjRelations">
update object_relations
   set deleted = 1
 where rel_type       = 'PRD_ACC'
   and object_id_tgt in ('<xsl:value-of select="string-join(current-group()[(position() - 1)  idiv 500 = number(current-grouping-key())]/@id, concat($apos,',',$apos))"/>')
   and deleted        = 0
            </sql:query>
          </sql:execute-query>
        </xsl:for-each-group>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
    
</xsl:stylesheet>