<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="content[ancestor::entry/@valid='true']">
    <xsl:variable name="object" select="ancestor::entry/@o" />
    <xsl:copy>
      <sql:execute-query>
        <sql:query name="ProductMarketingStatus">
          SELECT to_char(pms_raw.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified
               , to_char(pms_raw.masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified
               , pms_raw.status
               , pms_raw.data
           from octl pms_raw
          where pms_raw.content_type='PMS_Raw'
            and pms_raw.localisation='none'
            and pms_raw.object_id='<xsl:value-of select="$object" />'
        </sql:query>
      </sql:execute-query>
      <!--
      <sql:execute-query>
        <sql:query name="MasterPublishStatus">
          SELECT pmt_raw.status marketingstatus, pmt_raw.marketingversion
               , to_char(pmt_raw.masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified
               , to_char(pmt_raw.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified
           from octl pmt_raw
          where pmt_raw.content_type='PMT_Raw'
            and pmt_raw.localisation='none'
            and pmt_raw.object_id='<xsl:value-of select="$object" />'
            and pmt_raw.status != 'PLACEHOLDER'
        </sql:query>
      </sql:execute-query>
      -->
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
