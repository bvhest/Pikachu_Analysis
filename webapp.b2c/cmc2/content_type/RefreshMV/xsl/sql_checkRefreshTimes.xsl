<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:param name="view-name" select="''"/>
  <!-- -->
  <xsl:template match="node()|@*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>        
  <!-- -->  
  <xsl:template match="entry">
    <entry includeinreport='no'>
      <sql:execute-query>
        <sql:query>
          SELECT mview_name
               , last_refresh_DATE 
               , compile_state
               , case when last_refresh_DATE > sysdate -1/24 
                      then 'OK' 
                      else 'STALE' end 
                 as refreshstatus 
            FROM all_mviews
         <xsl:choose>
           <xsl:when test="$view-name != ''">
           WHERE mview_name = '<xsl:value-of select="$view-name"/>'
           </xsl:when>
           <xsl:otherwise>
           WHERE mview_name != 'MV_PMS_PROD_OBJ_MASTER_DATA'
           </xsl:otherwise>
         </xsl:choose>
             AND owner = sys_context('USERENV', 'CURRENT_SCHEMA')
        </sql:query>
      </sql:execute-query>
    </entry>
  </xsl:template>
</xsl:stylesheet>