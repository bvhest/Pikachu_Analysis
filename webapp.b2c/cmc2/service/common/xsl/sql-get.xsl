<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                exclude-result-prefixes="fn sql">

  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:param name="id-list"/>
  <xsl:param name="max-results" as="xs:decimal"/>
  <xsl:param name="runmode"/>
  <!-- -->
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  <xsl:variable name="apos">'</xsl:variable>
  <xsl:variable name="l-max-results" as="xs:decimal">
    <xsl:choose>
      <xsl:when test="number($max-results)=0 or string(number($max-results))='NaN'"><xsl:value-of select="number(500)"/></xsl:when>
      <xsl:when test="number($max-results) &gt; 500"><xsl:value-of select="number(500)"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="number($max-results)"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="id-seq" select="fn:subsequence(fn:tokenize($id-list, '\s*,\s*'),1,$l-max-results)"/>
  <xsl:variable name="id-query" select="fn:string-join(for $id in $id-seq return fn:concat($apos,$id,$apos),',')"/>
  <!-- -->
  <xsl:template match="/">
    <sql:execute-query>
      <sql:query>
        select   o.active_flag
                ,oc.batch_number
                ,o.content_type
                ,to_char(o.endofprocessing,'YYYY-MM-DD"T"HH24:MI:SS') endofprocessing
                ,oc.intransaction_flag
                ,to_char(o.lastmodified_ts,'YYYY-MM-DD"T"HH24:MI:SS') lastmodified_ts
                ,o.localisation
                ,to_char(o.masterlastmodified_ts,'YYYY-MM-DD"T"HH24:MI:SS') masterlastmodified_ts
                ,oc.needsprocessing_flag
                ,to_char(oc.needsprocessing_ts,'YYYY-MM-DD"T"HH24:MI:SS') needsprocessing_ts
                ,o.object_id
                ,to_char(o.startofprocessing,'YYYY-MM-DD"T"HH24:MI:SS') startofprocessing
                ,o.status
                ,o.marketingversion
                ,o.remark
                ,o.islocalized
                ,o.data
        from octl o
        left outer join octl_control oc
          on oc.content_type          = o.content_type
         and oc.localisation          = o.localisation 
         and oc.object_id             = o.object_id 
         and oc.modus                 = '<xsl:value-of select="$modus"/>'
       where o.content_type           = '<xsl:value-of select="$ct"/>' 
         and o.localisation           = '<xsl:value-of select="$l"/>' 
         and o.object_id             in (<xsl:value-of select="$id-query"/>) 
      </sql:query>
    </sql:execute-query>
  </xsl:template>

</xsl:stylesheet>