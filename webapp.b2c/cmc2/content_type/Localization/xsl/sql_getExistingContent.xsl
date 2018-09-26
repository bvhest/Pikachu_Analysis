<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <!-- -->
  <xsl:param name="mode"/>
  <xsl:param name="ct"/>
  <!-- -->
  <xsl:template match="/">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="$mode = 'newcontent'">
          <xsl:apply-templates select="@*|node()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="reprocessexistingcontent"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="entry">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <currentcontent>
        <sql:execute-query>
          <sql:query>
              select o.object_id, o.data
                from octl o
               where o.content_type = 'Localization'
                 and o.localisation = 'none'
                 and o.object_id = '<xsl:value-of select="@o"/>'
                 and NVL(o.status, 'XXX') != 'PLACEHOLDER'
          </sql:query>
        </sql:execute-query>
      </currentcontent>
      <currentrelations output_content_type="PMT_Localised">
        <sql:execute-query>
          <sql:query>
            select input_content_type
                 , input_localisation
                 , output_content_type
                 , output_localisation
                 , output_object_id
                 , issecondary
              from octl_relations cr
             where issecondary = 1
               and input_object_id = '<xsl:value-of select="@o"/>'
               and input_content_type = '<xsl:value-of select="$ct"/>'
               and output_content_type = 'PMT_Localised'
          order by output_content_type, output_localisation, output_object_id
          </sql:query>
        </sql:execute-query>
      </currentrelations>
      <currentrelations output_content_type="RangeText_Localized">
        <sql:execute-query>
          <sql:query>
            select input_content_type
                 , input_localisation
                 , output_content_type
                 , output_localisation
                 , output_object_id
                 , issecondary
              from octl_relations cr
             where issecondary = 1
               and input_object_id = '<xsl:value-of select="@o"/>'
               and input_content_type = '<xsl:value-of select="$ct"/>'
               and output_content_type = 'RangeText_Localized'
          order by output_content_type, output_localisation, output_object_id
          </sql:query>
        </sql:execute-query>
      </currentrelations>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template name="reprocessexistingcontent">
    <Localizations>
        <sql:execute-query>
          <sql:query name="content">
              select o.object_id
			       , o.data
                from octl o
               where o.content_type = 'Localization'
                 and o.localisation = 'none'
                 and NVL(o.status, 'XXX') != 'PLACEHOLDER'
            order by o.object_id
          </sql:query>
        </sql:execute-query>
      <currentrelations output_content_type="PMT_Localised">
        <sql:execute-query>
          <sql:query name="relations">
            select input_content_type
                 , input_localisation
                 , input_object_id
                 , output_content_type
                 , output_localisation
                 , output_object_id
                 , issecondary
              from octl_relations cr
             where issecondary = 1
               and input_content_type = '<xsl:value-of select="$ct"/>'
               and output_content_type = 'PMT_Localised'
          order by output_content_type, output_localisation, output_object_id
          </sql:query>
        </sql:execute-query>
      </currentrelations>
    </Localizations>
  </xsl:template>
</xsl:stylesheet>

