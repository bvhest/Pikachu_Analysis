<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:include href="pmsBase.xsl"/>
  
  <xsl:template match="content[ancestor::entry/@valid='true']">
    <xsl:variable name="object" select="ancestor::entry/@o" />
    <xsl:copy>
      <sql:execute-query>
        <sql:query name="MasterData">
          SELECT to_char(pmt_master.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified,
                 pmt_master.data data
           from octl pmt_master
          where pmt_master.content_type='PMT_Master'
            and pmt_master.localisation='master_global'
            and pmt_master.object_id='<xsl:value-of select="$object" />'
            and pmt_master.status != 'PLACEHOLDER'
        </sql:query>
      </sql:execute-query>

      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
