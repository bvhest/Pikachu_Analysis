<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="content">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <octl>
        <sql:execute-query>
          <sql:query name="AssetList">
            select o.content_type, o.localisation, o.object_id, o.masterlastmodified_ts, o.lastmodified_ts, o.status, o.marketingversion, o.data
              from octl o
             where o.content_type = 'AssetList'
               and o.localisation = 'master_global'
               and o.object_id = '<xsl:value-of select="../@o"/>'
               and NVL(o.status, 'XXX') != 'PLACEHOLDER'
          </sql:query>
        </sql:execute-query>
      </octl>
      <octl>
        <sql:execute-query>
          <sql:query name="KeyValuePairs">
            select o.content_type, o.localisation, o.object_id, o.masterlastmodified_ts, o.lastmodified_ts, o.status, o.marketingversion, o.data
              from octl o
             where o.content_type = 'KeyValuePairs'
               and o.localisation = 'master_global'
               and o.object_id = '<xsl:value-of select="../@o"/>'
               and NVL(o.status, 'XXX') != 'PLACEHOLDER'
          </sql:query>
        </sql:execute-query>
      </octl>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>