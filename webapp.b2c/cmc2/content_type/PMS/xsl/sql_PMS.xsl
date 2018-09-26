<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="content[../@valid='true']">
    <xsl:variable name="object" select="../@o" />
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
      <sql:execute-query name="PMS">
        <sql:query>
          SELECT pms.data pms_data
          from octl pms
          where pms.content_type='PMS__'
          and pms.localisation='none'
          and pms.object_id='<xsl:value-of select="$object" />'
          and pms.status!='PLACEHOLDER'
        </sql:query>
      </sql:execute-query>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
