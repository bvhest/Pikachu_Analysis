<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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
      <xsl:attribute name="batchnumber" select="$batch_number"/>

      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
          <xsl:choose>
            <xsl:when test="$l-sync">
          <!-- Use this sql for divisionalised synchs -->
          SELECT '<xsl:value-of select="$input_ct"/>' content_type,
                l2.locale localisation,
                l2.islatin,
                in_o.object_id,
                TO_CHAR(MAX(in_o.MASTERLASTMODIFIED_TS),'YYYYMMDD"T"HH24MISS') MASTERLASTMODIFIED_TS
            FROM (SELECT   os.object_id, os.masterlastmodified_ts, ll.country_code, omd.division, COUNT (DISTINCT os.localisation) locs
                    FROM octl_store os
                   INNER JOIN object_master_data omd
                      ON os.object_id   = omd.object_id
                   INNER JOIN locale_language ll
                      ON os.localisation = ll.locale
                   INNER JOIN octl o
                      on o.content_type = '<xsl:value-of select="$ct"/>'
                     and o.localisation = os.localisation
                     and o.object_id    = os.object_id
                   INNER JOIN octl_control octl_c
                      ON octl_c.content_type = o.content_type
                     AND octl_c.localisation = o.localisation
                     AND octl_c.object_id    = o.object_id
                     AND octl_c.modus        = '<xsl:value-of select="$modus"/>'
                     <!-- Don't attempt to sync content for locales that have been disabled -->
                   INNER JOIN ctl ctl
                      ON os.localisation  = ctl.localisation
                     AND ctl.sync_code    = 1
                     AND CTL.content_type = o.content_type
                   <xsl:if test="$reload='true'">
                   <!-- filter out old PMTs in a reload -->
                   INNER JOIN mv_co_object_id mvo
                      ON mvo.object_id = o.object_id
                     AND mvo.deleted   = 0
                     AND mvo.eop       > SYSDATE
                   </xsl:if>
                   WHERE os.content_type  = '<xsl:value-of select="$input_ct"/>'
                     AND ll.country_code  = '<xsl:value-of select="$country_code"/>'
                   <!--and os.object_id in ('SCF290/20' ,'42PFL9900D/10')-->
                   GROUP BY os.object_id, os.masterlastmodified_ts, ll.country_code, omd.division
                  HAVING COUNT (DISTINCT os.localisation) = (SELECT COUNT (LL.locale)
                                                               FROM locale_language ll
                                                              INNER JOIN language_translations lt
                                                                 ON ll.locale = lt.locale
                                                              INNER JOIN ctl ctl
                                                                 ON ll.locale = ctl.localisation
                                                              WHERE ctl.SYNC_CODE = 1
                                                                AND CTL.CONTENT_TYPE = '<xsl:value-of select="$ct"/>'
                                                                AND lt.division = omd.division
                                                                AND country_code = '<xsl:value-of select="$country_code"/>')
                    <xsl:if test="not($reload='true')">
                      AND MAX(octl_c.needsprocessing_flag) > 0
                    </xsl:if>
                      and max(nvl(octl_c.batch_number,0)) = <xsl:value-of select="$batch_number"/>
                    ) in_o
            INNER JOIN locale_language l2
                    ON in_o.country_code = l2.country_code
            INNER JOIN language_translations lt
                    ON l2.locale         = lt.locale
            INNER JOIN ctl ctl
                    ON ctl.localisation  = l2.locale
                   AND ctl.content_type  = '<xsl:value-of select="$ct"/>'
                 WHERE ctl.sync_code     = 1
                   AND lt.division = in_o.division
              GROUP BY l2.locale, l2.islatin, in_o.object_id
            </xsl:when>
            
            <!--
              Without synchronizing multiple locales in a country 
            -->
            <xsl:otherwise>
                  SELECT '<xsl:value-of select="$input_ct"/>' content_type,
                         o.localisation,
                         ll.islatin,
                         o.object_id,
                         TO_CHAR(otr.masterlastmodified_ts,'YYYYMMDD"T"HH24MISS') masterlastmodified_ts
                    FROM OCTL o
                    
              INNER JOIN octl_control octl_c
                      ON octl_c.content_type = o.content_type
                     AND octl_c.object_id    = o.object_id
                     AND octl_c.localisation = o.localisation
                     AND octl_c.modus        = '<xsl:value-of select="$modus"/>'
                   <xsl:if test="$reload!='true'">
                     AND octl_c.needsprocessing_flag > 0
                   </xsl:if>
                     AND nvl(octl_c.batch_number,0) = <xsl:value-of select="$batch_number"/>

              INNER JOIN octl otr
                      ON otr.content_type = 'PMT_Translated'
                     AND otr.object_id    = o.object_id
                     AND otr.localisation = o.localisation
       
              INNER JOIN object_master_data omd
                      ON omd.object_id    = o.object_id
                      
              INNER JOIN locale_language ll
                      ON ll.locale        = o.localisation
                     AND ll.country_code  = '<xsl:value-of select="$country_code"/>'
                     
              INNER JOIN language_translations lt
                      ON lt.locale        = ll.locale
                     AND lt.division      = omd.division
                            
              INNER JOIN ctl
                      ON ctl.content_type = o.content_type
                     AND ctl.localisation = o.localisation
                     AND ctl.sync_code    = 1
              
                   WHERE o.content_type   = '<xsl:value-of select="$ct"/>'
                  <xsl:if test="$reload='true'">
                     AND o.endofprocessing> sysdate
                  </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </sql:query>
      </sql:execute-query>
    </entries>
  </xsl:template>
</xsl:stylesheet>