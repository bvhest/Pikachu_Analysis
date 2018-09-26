<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                >
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ct"/>
  <xsl:param name="ts"/>
  <xsl:param name="workflow"/>  
  <xsl:param name="process"/>    
  <xsl:param name="phase2">no</xsl:param>
  <xsl:param name="xexporttype"/>
  <xsl:param name="runmode"/>
  <!-- -->
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  <!-- -->
  <xsl:template match="/">
    <entries ct="{$ct}" ts="{$ts}" workflow="{$workflow}" phase2="{$phase2}">
      <xsl:attribute name="iscatalogexport" select="if($xexporttype = 'Catalog') then 'yes' else 'no'"/>
      <entry includeinreport='yes'>
        <xsl:choose>
          <xsl:when test="$ct = ('PMT_Translated','PText_Translated') and $process = 'export' and $workflow = 'CL_QUERY' and not($xexporttype='Catalog')">
            <xsl:call-template name="resetFlagsForQueryExport"/>
          </xsl:when>
          <!-- see remark at the template for PMT_Translated and needsprocessing_flag = 9 -->
          <xsl:when test="$ct = ('PText_Translated') and $process = 'export' and $workflow = 'CL_CMC' and not($phase2 = 'yes') and not($xexporttype='Catalog')">
            <xsl:call-template name="resetFlagsForRealExport"/>
          </xsl:when>
          <xsl:otherwise>No query to run for this process</xsl:otherwise>
        </xsl:choose>
      </entry>
    </entries>
  </xsl:template>    
  <!-- -->
  <xsl:template name="resetFlagsForQueryExport">
    <xsl:copy>  
      <sql:execute-query>
        <sql:query name="resetFlagsForQueryExport">
          update octl_control oc
             set oc.needsprocessing_flag = 1
           where oc.modus                = '<xsl:value-of select="$modus"/>'
             and oc.content_type         = '<xsl:value-of select="$ct"/>'
             and oc.needsprocessing_flag = 9
             and (sysdate - 3)           > nvl((select max(doctimestamp) 
                                                  from octl_translations ot 
                                                  where ot.content_type = oc.content_type 
                                                    and ot.localisation = oc.localisation 
                                                    and ot.object_id    = oc.object_id)
                                              ,to_date('19000101','YYYYMMDD')
                                              ) 
        </sql:query>
      </sql:execute-query>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template name="resetFlagsForRealExport">
    <xsl:copy>  
      <!-- the following update will never modify any records for the ct=PMT_Translated 
         | as needsprocessing_flag = 9 can only be true after a Query export 
         | (see exportTranslationStore.xsl).
         -->
      <sql:execute-query>
        <sql:query name="resetFlagsForRealExport">
          update octl_control oc
             set oc.needsprocessing_flag = 1
           where oc.modus                = '<xsl:value-of select="$modus"/>'
             and oc.content_type         = '<xsl:value-of select="$ct"/>'
             and oc.needsprocessing_flag = 9 
             and (exists (select 1
                           from octl_translations ot
                          where ot.content_type = oc.content_type 
                            and ot.localisation = oc.localisation 
                            and ot.object_id    = oc.object_id
                            and ot.doctimestamp = to_date('<xsl:value-of select="substring($ts,1,12)"/>','YYYYMMDDHH24MI'))
                 or
                    sysdate - 3 > nvl((select max(doctimestamp) 
                                         from octl_translations ot 
                                        where ot.content_type = oc.content_type 
                                          and ot.localisation = oc.localisation 
                                          and ot.object_id    = oc.object_id)
                                      ,to_date('19000101','YYYYMMDD')
                                      )
                  )
        </sql:query>
      </sql:execute-query>
    </xsl:copy>
  </xsl:template>  
  <!-- -->
</xsl:stylesheet>