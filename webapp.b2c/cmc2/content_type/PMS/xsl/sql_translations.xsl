<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:include href="pmsBase.xsl"/>
  
  <xsl:template match="Countries[ancestor::entry/@valid='true']">
    <xsl:variable name="object" select="ancestor::entry/@o" />
    <xsl:copy>
      <sql:execute-query>
        <sql:query name="locales">
          SELECT  pmt_translated.marketingversion mv_trans
               ,  to_char(pmt_translated.lastmodified_ts,'yyyy-mm-dd') lmdate_trans
               ,  to_char(pmt_translated.masterlastmodified_ts,'yyyy-mm-dd') mlmdate_trans
               ,  pmt_translated.status status_trans
               ,  pmt_translated.localisation locale_trans
               ,  pmt.marketingversion mv_live
               ,  to_char(pmt.lastmodified_ts,'yyyy-mm-dd') lmdate_live
          from octl pmt_translated
          
          left outer join octl pmt
          on pmt_translated.object_id = pmt.object_id
          and pmt_translated.localisation = pmt.localisation
          
         where pmt_translated.content_type = 'PMT_Translated'
           and pmt_translated.object_id    = '<xsl:value-of select="$object" />'
           and pmt_translated.status      != 'PLACEHOLDER'
           and pmt_translated.data is not null
           and pmt.content_type = 'PMT'
        </sql:query>
      </sql:execute-query>
      <sql:execute-query>
        <sql:query name="pendingTranslations">
        SELECT ot.content_type
              , ot.localisation
              , ot.object_id
              , ot.marketingversion
              , to_char(ot.doctimestamp,'yyyy-mm-dd') as doctimestamp
              , ot.import_ts
              , ot.valid
              , ot.result
              , ot.localisation||'.'||replace(ot.marketingversion, '.', '_') as locale_version
           FROM octl_translations ot
          WHERE ot.object_id    = '<xsl:value-of select="$object" />'
            AND ot.content_type = 'PMT_Translated' 
            AND ot.workflow     = 'CL_CMC'
            AND ( ot.import_ts IS NULL 
              AND ot.valid     IS NULL
                )
            AND ot.doctimestamp = (select MAX(oti.doctimestamp)
                                     FROM octl_translations oti
                                    WHERE oti.content_type = ot.content_type
                                      AND oti.workflow     = ot.workflow 
                                      AND oti.localisation = ot.localisation
                                      AND oti.object_id    = ot.object_id
                                      AND ( oti.import_ts IS NULL 
                                        AND oti.valid     IS NULL
                                          )
                                  )
          ORDER BY ot.localisation, ot.marketingversion
        </sql:query>
      </sql:execute-query>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
