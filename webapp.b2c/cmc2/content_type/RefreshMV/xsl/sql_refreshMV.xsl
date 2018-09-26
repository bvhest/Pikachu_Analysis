<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:param name="ct"/>
  <xsl:param name="ts"/>
  <xsl:param name="l"/>
  <xsl:param name="view-name" select="''"/>
  <xsl:variable name="apos">'</xsl:variable>
  <!-- -->
  <xsl:template match="/">
    <entries ct="{$ct}" l="{$l}" ts="{$ts}">
      <entry includeinreport='no'>
        <sql:execute-query>
          <sql:query isstoredprocedure="true">
BEGIN
   -- the following stored procedure selects all MV's and updates them;
   batch_pre_processing.refresh_mv(p_viewname => '<xsl:value-of select="$view-name"/>');
END;
          </sql:query>
        </sql:execute-query>
      </entry>
    </entries>
  </xsl:template>
</xsl:stylesheet>