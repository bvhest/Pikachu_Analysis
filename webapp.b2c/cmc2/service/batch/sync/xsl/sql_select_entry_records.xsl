<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="country_code"/>
  <xsl:param name="ts"/>
  <xsl:param name="ct"/>
  <xsl:param name="input_ct"/>
  <xsl:param name="reload"/>
  <xsl:param name="batch_number"/>
  <xsl:param name="nosync"/>
  <xsl:param name="runmode"/>
  
  <xsl:variable name="l-sync" select="$nosync = '' or $nosync != 'true'"/>
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  
  <xsl:template match="/">
    <entries
      ct="{$ct}"
      l="{$country_code}"
      ts="{$ts}"
      >
      <xsl:attribute name="batchnumber" select="if($ct = 'PMT') then $batch_number else '0'"/>

      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
          <xsl:choose>
            <xsl:when test="$l-sync">
                  SELECT '<xsl:value-of select="$input_ct"/>' content_type,
                        l2.locale localisation,
                        in_o.object_id,
                        TO_CHAR(MAX(in_o.MASTERLASTMODIFIED_TS),'YYYYMMDD"T"HH24MISS') MASTERLASTMODIFIED_TS
                    FROM (SELECT os.object_id
                               , os.masterlastmodified_ts
                               , ll.country_code
                               , COUNT (DISTINCT os.localisation) locs
                            FROM octl_store os
                           INNER JOIN locale_language ll
                              ON ll.locale = os.localisation
                           INNER JOIN octl_control o
                              ON o.content_type   = '<xsl:value-of select="$ct"/>'
                             AND o.localisation   = os.localisation
                             AND o.object_id      = os.object_id
                             AND o.modus          = '<xsl:value-of select="$modus"/>'
                             <!-- Don't attempt to sync content for locales that have been disabled -->
                           INNER JOIN ctl
                              ON ctl.localisation = os.localisation
                             AND ctl.SYNC_CODE    = 1
                             AND CTL.CONTENT_TYPE = o.content_type
                           WHERE os.content_type  = '<xsl:value-of select="$input_ct"/>'
                             AND ll.country_code  = '<xsl:value-of select="$country_code"/>'
                        GROUP BY os.object_id
                               , os.masterlastmodified_ts
                               , ll.country_code
                          HAVING COUNT (DISTINCT os.localisation) = (SELECT count(distinct ll.locale)
                                                                       FROM locale_language ll
                                                                      INNER JOIN language_translations lt
                                                                         ON lt.locale         = ll.locale
                                                                      INNER JOIN ctl ctl2
                                                                         ON ctl2.localisation = ll.locale
                                                                      WHERE ctl2.SYNC_CODE    = 1
                                                                        AND CTL2.CONTENT_TYPE = '<xsl:value-of select="$ct"/>'
                                                                        AND LL.country_code   = '<xsl:value-of select="$country_code"/>'
                                                                    )
                           <xsl:if test="not($reload='true')">
                             AND MAX(o.needsprocessing_flag)>0
                           </xsl:if>
                         ) in_o
                   INNER JOIN locale_language l2
                           ON l2.country_code   = in_o.country_code
                   INNER JOIN ctl ctl3
                           ON ctl3.localisation = l2.locale
                          AND ctl3.CONTENT_TYPE = '<xsl:value-of select="$ct"/>'
                   WHERE ctl3.SYNC_CODE    = 1
                   GROUP BY l2.locale, in_o.object_id
            </xsl:when>
            <!--
              Without synchronizing multiple locales in a country 
            -->
            <xsl:otherwise>
                  SELECT '<xsl:value-of select="$input_ct"/>' content_type,
                         o.localisation,
                         o.object_id,
                         TO_CHAR(otr.masterlastmodified_ts,'YYYYMMDD"T"HH24MISS') masterlastmodified_ts
                    FROM OCTL_CONTROL o
              INNER JOIN octl otr
                      ON otr.content_type = '<xsl:value-of select="$input_ct"/>'
                     AND otr.object_id    = o.object_id
                     AND otr.localisation = o.localisation
              INNER JOIN locale_language ll
                      ON ll.locale        = o.localisation
                     AND ll.country_code  = '<xsl:value-of select="$country_code"/>'
              INNER JOIN ctl
                      ON ctl.content_type = o.content_type
                     AND ctl.localisation = o.localisation
                     AND ctl.sync_code    = 1
                   WHERE o.modus          = '<xsl:value-of select="$modus"/>'
                     AND o.content_type   = '<xsl:value-of select="$ct"/>'
                     AND o.needsprocessing_flag > 0
            </xsl:otherwise>
          </xsl:choose>
        </sql:query>
      </sql:execute-query>
    </entries>
  </xsl:template>
</xsl:stylesheet>