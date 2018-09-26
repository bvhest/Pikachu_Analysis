<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >
  <!-- -->
  <xsl:param name="o"/>
  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:param name="input_ct"/>
  <!-- -->
   <xsl:template match="@*|node()">
      <xsl:copy copy-namespaces="no">
         <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
   </xsl:template> 
  <!-- -->
   <xsl:template match="content[../@valid='true']">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
         <sql:execute-query>
            <sql:query name="current-secondary-derived-relations">  
            SELECT INPUT_CONTENT_TYPE
                 , INPUT_LOCALISATION
                 , INPUT_OBJECT_ID
              FROM  octl_relations 
             WHERE OUTPUT_CONTENT_TYPE = '<xsl:value-of select="$ct"/>'
               AND OUTPUT_LOCALISATION = '<xsl:value-of select="$l"/>'
               AND OUTPUT_OBJECT_ID    = '<xsl:value-of select="$o"/>'
            <xsl:if test="$input_ct != ''">
               AND INPUT_CONTENT_TYPE = '<xsl:value-of select="$input_ct"/>'
            </xsl:if>
               AND ISSECONDARY = 1
               AND ISDERIVED = 1
            </sql:query>
         </sql:execute-query>
      </xsl:copy>
   </xsl:template>
  <!-- -->
</xsl:stylesheet>