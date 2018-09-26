<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:param name="ct"/>
  <xsl:param name="reload"/>
  <xsl:param name="runmode" select="''" />
  <!-- -->
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  <!-- -->
  <xsl:template match="/">
    <root>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
          <!-- Only select rows for countries that have at least one OCTL waiting to be processed -->
           select cr.output_content_type as content_type
                 ,cr.input_content_type
                 ,ll.country_code
           from
                (select distinct output_content_type, input_content_type
                 from CTL_Relations
                 where output_content_type = '<xsl:value-of select="$ct"/>'
                   and issecondary         = 0
                ) cr,
                (select distinct country_code
                   from locale_language ll
                  inner join octl o
                     on o.localisation   = ll.locale
                  inner join octl_control oc
                     on oc.content_type  = o.content_type
                    and oc.localisation  = o.localisation
                    and oc.object_id     = o.object_id
                    and oc.modus         = '<xsl:value-of select="$modus"/>'
              <!-- sync only active ctls (e.g. not PMT/ms_MY, PMT/es_US)-->
                  inner join ctl 
                     on ctl.content_type = o.content_type
                    and ctl.localisation = o.localisation
                    and ctl.sync_code    = 1
                  where o.content_type   = '<xsl:value-of select="$ct"/>'
              <xsl:if test="not($reload='true')">
                    and oc.needsprocessing_flag = 1
              <!-- Disabled until the concept of multiple catalogs supporting individual output OCTLs is implemented
                    and o.startofprocessing &lt;= trunc(sysdate)
                -->
                </xsl:if>
                    and o.endofprocessing &gt;= trunc(sysdate)
                    and o.active_flag    = 1
                ) ll
           order by cr.output_content_type, cr.input_content_type, ll.country_code
        </sql:query>
      </sql:execute-query>
    </root>
</xsl:template>
</xsl:stylesheet>
