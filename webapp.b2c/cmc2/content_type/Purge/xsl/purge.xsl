<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="ct"/>
  <xsl:param name="ts"/>    
  <xsl:param name="l"/>      
  <xsl:param name="max_history_versions"/>
  <xsl:param name="purge"/> 
    
    <xsl:template match="/">
      <entries ct="{$ct}" l="{$l}" ts="{$ts}">
        <entry>
          <result>OK</result>
          <sql:execute-query>
            <sql:query isstoredprocedure="true">
BEGIN
   BATCH_PRE_PROCESSING.purge_octl_store(<xsl:value-of select="$max_history_versions"/>,'<xsl:value-of select="$purge"/>');
END;
            </sql:query>
          </sql:execute-query>
        </entry>
      </entries>
    </xsl:template>

</xsl:stylesheet>