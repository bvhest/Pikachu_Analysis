<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="channel"/>
  <xsl:param name="country"/>
  <xsl:param name="locale"/>
  <!-- -->
  <xsl:template match="/">
  <root>
  <!-- clear all-->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>

SELECT   object_id ctn, locale, masterlm AS masterproductlastmodified, locallm localizedproductlastmodified, division, sop, eop, catalog_type
       , translationstatus, exportedtocq
    FROM (SELECT MASTER.object_id, MASTER.division, MASTER.lastmodified_ts masterlastmodified
               , MASTER.lastmodified_ts masterlm, localized.lastmodified_ts locallm, MASTER.sop, MASTER.eop
               , MASTER.customer_id catalog_type
               , CASE
                    WHEN MASTER.enabled != 0
                    AND MASTER.isdirect = 0
                       THEN CASE
                              WHEN 
                               returnedtranslation_hist.lastmodified_ts IS NULL
                              AND outstandingtranslation_hist.lastmodified_ts IS NULL
                              AND returnedtranslation.lastmodified_ts IS NULL
                              AND outstandingtranslation.lastmodified_ts IS NULL                              
                                 THEN 'Translation not requested'
                                 
                              WHEN ((returnedtranslation_hist.lastmodified_ts IS NULL
                              AND outstandingtranslation_hist.lastmodified_ts IS NOT NULL) or
                              (returnedtranslation.lastmodified_ts IS NULL
                              AND outstandingtranslation.lastmodified_ts IS NOT NULL))
                                 THEN 'Translation request pending'
                                 
                              WHEN ((returnedtranslation_hist.lastmodified_ts IS NOT NULL
                              AND outstandingtranslation_hist.lastmodified_ts IS NOT NULL
                              AND outstandingtranslation_hist.lastmodified_ts > returnedtranslation_hist.lastmodified_ts )
                              OR (returnedtranslation.lastmodified_ts IS NOT NULL
                              AND outstandingtranslation.lastmodified_ts IS NOT NULL
                              AND outstandingtranslation.lastmodified_ts > returnedtranslation.lastmodified_ts ))                             
                                 THEN 'Approved, newer request pending'
                              ELSE 'Approved'
                           END
                    WHEN MASTER.enabled != 0
                    AND MASTER.isdirect = 1
                       THEN 'Approved'
                    WHEN MASTER.enabled = 0
                       THEN 'Translation not requested'
                 END translationstatus
               , CASE
                    WHEN NVL (cle.lasttransmit, TO_DATE ('19000101', 'YYYYMMDD')) =
                                                                      TO_DATE ('19000101', 'YYYYMMDD')
                       THEN 'N'
                    ELSE 'Y'
                 END AS exportedtocq
               , country, MASTER.locale
            FROM (SELECT DISTINCT o.lastmodified_ts, o.object_id, co.country, ll.locale, lt.enabled, lt.isdirect
                                , lt.division, co.sop, co.eop, co.customer_id
                             FROM octl o INNER JOIN catalog_objects co ON o.object_id = co.object_id
                                  INNER JOIN locale_language ll ON co.country = ll.country
                                  INNER JOIN language_translations lt ON ll.locale = lt.locale
                                  INNER JOIN object_master_data omd
                                  ON o.object_id = omd.object_id
                                AND omd.division = lt.division
                            WHERE customer_id IS NOT NULL
                              AND content_type = 'PMT_Enriched') MASTER
                 LEFT OUTER JOIN
                 (SELECT *
                    FROM customer_locale_export
                   WHERE customer_id = 'Products2CQ') cle ON MASTER.locale = cle.locale
                                                      AND MASTER.object_id = cle.ctn
                 LEFT OUTER JOIN
                 (SELECT content_type, localisation, object_id, masterlastmodified_ts, lastmodified_ts
                    FROM octl
                   WHERE content_type = 'PMT'
                     AND status != 'PLACEHOLDER') localized
                 ON MASTER.object_id = localized.object_id
               AND MASTER.locale = localized.localisation
                 LEFT OUTER JOIN
                 (SELECT   o.content_type, o.localisation, o.object_id
                         , MAX (o.masterlastmodified_ts) masterlastmodified_ts, MAX (o2.lastmodified_ts)
                                                                                                        lastmodified_ts
                      FROM (SELECT   MAX (o.masterlastmodified_ts) masterlastmodified_ts, o.content_type, o.object_id
                                   , o.localisation
                                FROM octl_translations o
                               WHERE o.content_type = 'PMT_Translated'
                                 AND o.import_ts IS NOT NULL
                                 AND o.result in ('InitialTableLoad','OK')
                                 AND o.valid = 'true'                                 
                            GROUP BY o.content_type, o.localisation, o.object_id) o
                           INNER JOIN
                           octl_translations o2
                           ON o.content_type = o2.content_type
                         AND o.localisation = o2.localisation
                         AND o.object_id = o2.object_id
                         AND o.masterlastmodified_ts = o2.masterlastmodified_ts
                  GROUP BY o.content_type, o.localisation, o.object_id) returnedtranslation
                 ON MASTER.object_id = returnedtranslation.object_id
               AND MASTER.locale = returnedtranslation.localisation
                 LEFT OUTER JOIN
                 (SELECT   o.content_type, o.localisation, o.object_id
                         , MAX (o.masterlastmodified_ts) masterlastmodified_ts, MAX (o2.lastmodified_ts)
                                                                                                        lastmodified_ts
                      FROM (SELECT   MAX (o.masterlastmodified_ts) masterlastmodified_ts, o.content_type, o.object_id
                                   , o.localisation
                                FROM octl_translations o
                               WHERE o.content_type = 'PMT_Translated'
                                 AND o.import_ts IS NULL
                                 AND nvl(result,'X') != 'CANCELLED BY CMST'
                            GROUP BY o.content_type, o.localisation, o.object_id) o
                           INNER JOIN
                           octl_translations o2
                           ON o.content_type = o2.content_type
                         AND o.localisation = o2.localisation
                         AND o.object_id = o2.object_id
                         AND o.masterlastmodified_ts = o2.masterlastmodified_ts
                  GROUP BY o.content_type, o.localisation, o.object_id) outstandingtranslation
                 ON MASTER.object_id = outstandingtranslation.object_id
               AND MASTER.locale = outstandingtranslation.localisation
               -----------------------------------------------------------------
               LEFT OUTER JOIN
                 (SELECT   o.content_type, o.localisation, o.object_id
                         , MAX (o.masterlastmodified_ts) masterlastmodified_ts, MAX (o2.lastmodified_ts)
                                                                                                        lastmodified_ts
                      FROM (SELECT   MAX (o.masterlastmodified_ts) masterlastmodified_ts, o.content_type, o.object_id
                                   , o.localisation
                                FROM octl_translations_hist o
                               WHERE o.content_type = 'PMT_Translated'
                                 AND o.import_ts IS NOT NULL
                                 AND o.result in ('InitialTableLoad','OK')
                                 AND o.valid = 'true'                                 
                            GROUP BY o.content_type, o.localisation, o.object_id) o
                           INNER JOIN
                           octl_translations_hist o2
                           ON o.content_type = o2.content_type
                         AND o.localisation = o2.localisation
                         AND o.object_id = o2.object_id
                         AND o.masterlastmodified_ts = o2.masterlastmodified_ts
                  GROUP BY o.content_type, o.localisation, o.object_id) returnedtranslation_hist
                 ON MASTER.object_id = returnedtranslation_hist.object_id
               AND MASTER.locale = returnedtranslation_hist.localisation
                 LEFT OUTER JOIN
                 (SELECT   o.content_type, o.localisation, o.object_id
                         , MAX (o.masterlastmodified_ts) masterlastmodified_ts, MAX (o2.lastmodified_ts)
                                                                                                        lastmodified_ts
                      FROM (SELECT   MAX (o.masterlastmodified_ts) masterlastmodified_ts, o.content_type, o.object_id
                                   , o.localisation
                                FROM octl_translations_hist o
                               WHERE o.content_type = 'PMT_Translated'
                                 AND o.import_ts IS NULL
                                 AND nvl(result,'X') != 'CANCELLED BY CMST'
                            GROUP BY o.content_type, o.localisation, o.object_id) o
                           INNER JOIN
                           octl_translations_hist o2
                           ON o.content_type = o2.content_type
                         AND o.localisation = o2.localisation
                         AND o.object_id = o2.object_id
                         AND o.masterlastmodified_ts = o2.masterlastmodified_ts
                  GROUP BY o.content_type, o.localisation, o.object_id) outstandingtranslation_hist
                 ON MASTER.object_id = outstandingtranslation_hist.object_id
               AND MASTER.locale = outstandingtranslation_hist.localisation
               -----------------------------------------------------------------
                 )
   --WHERE object_id = 'SCF147/82' ---and locale='ar_AE'
ORDER BY locale,object_id,catalog_type
      
      </sql:query>
    </sql:execute-query>
  <!-- -->
  </root>
</xsl:template>
</xsl:stylesheet>