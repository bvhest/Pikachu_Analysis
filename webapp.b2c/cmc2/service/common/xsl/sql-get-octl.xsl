<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:param name="o"/>
  <xsl:param name="runmode"/>

  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  <xsl:template match="/">
    <octl>
      <sql:execute-query>
	    <sql:query>
           select   o.active_flag
                   ,oc.batch_number
                   ,o.content_type
                   ,to_char(o.endofprocessing,'yyyy-mm-dd"t"hh24:mi:ss') endofprocessing
                   ,oc.intransaction_flag
                   ,to_char(o.lastmodified_ts,'yyyy-mm-dd"t"hh24:mi:ss') lastmodified_ts
                   ,o.localisation
                   ,to_char(o.masterlastmodified_ts,'yyyy-mm-dd"t"hh24:mi:ss') masterlastmodified_ts
                   ,oc.needsprocessing_flag
                   ,to_char(oc.needsprocessing_ts,'yyyy-mm-dd"t"hh24:mi:ss') needsprocessing_ts
                   ,o.object_id
                   ,to_char(o.startofprocessing,'yyyy-mm-dd"t"hh24:mi:ss') startofprocessing
                   ,o.status
                   ,o.marketingversion
                   ,o.remark
                   ,o.islocalized
                   ,o.data
            from octl o
            left outer join octl_control oc
              on oc.content_type = o.content_type
             and oc.localisation = o.localisation 
             and oc.object_id    = o.object_id 
             and oc.modus        = '<xsl:value-of select="$modus"/>'
           where o.CONTENT_TYPE  = '<xsl:value-of select="$ct"/>'
             and o.LOCALISATION  = '<xsl:value-of select="$l"/>'
             and o.OBJECT_ID     = '<xsl:value-of select="$o"/>'
             and o.status       != 'PLACEHOLDER'
        </sql:query>
	</sql:execute-query>
    </octl>
  </xsl:template>
</xsl:stylesheet>
