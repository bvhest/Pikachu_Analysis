<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:param name="ct" />
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:apply-templates select="@*|node()" />
    </root>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="entry">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
      <currentrelations output_content_type="PMT_Master">
        <sql:execute-query>
          <sql:query>
            SELECT cr.input_content_type, cr.input_localisation, cr.output_content_type, cr.output_localisation,
                   cr.output_object_id, cr.issecondary
            FROM octl_relations cr
            WHERE cr.issecondary = 1 and cr.input_object_id = '<xsl:value-of select="@o" />' and output_content_type = 'PMT_Master'
            order by output_content_type, output_localisation
          </sql:query>
        </sql:execute-query>
      </currentrelations>
      <currentrelations output_content_type="PMT_Enriched">
        <sql:execute-query>
          <sql:query>
            SELECT cr.input_content_type, cr.input_localisation, cr.output_content_type, cr.output_localisation,
                   cr.output_object_id, cr.issecondary
            FROM octl_relations cr
            WHERE cr.issecondary = 1 and cr.input_object_id = '<xsl:value-of select="@o" />' and output_content_type = 'PMT_Enriched'
            order by output_content_type, output_localisation
          </sql:query>
        </sql:execute-query>
      </currentrelations>   
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>

