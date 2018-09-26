<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                exclude-result-prefixes="fn sql">

  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:param name="categorization"/>
  <xsl:param name="sop"/>
  <xsl:param name="eop"/>
  <xsl:param name="max-results" as="xs:decimal"/>
  
  <xsl:variable name="categorization-parts" select="fn:tokenize($categorization, '/')"/>
  <xsl:variable name="catalog">
    <xsl:if test="string-length($categorization) > 0">
      <xsl:value-of select="$categorization-parts[1]"/>
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="group">
    <xsl:if test="count($categorization-parts) > 1">
      <xsl:value-of select="$categorization-parts[2]"/>
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="category">
    <xsl:if test="count($categorization-parts) > 2">
      <xsl:value-of select="$categorization-parts[3]"/>
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="subcategory">
    <xsl:if test="count($categorization-parts) > 3">
      <xsl:value-of select="$categorization-parts[4]"/>
    </xsl:if>
  </xsl:variable>
  
  <xsl:variable name="l-max-results" as="xs:decimal">
    <xsl:choose>
      <xsl:when test="number($max-results)=0 or string(number($max-results))='NaN'"><xsl:value-of select="number(2000)"/></xsl:when>
      <xsl:when test="number($max-results) &gt; 2000"><xsl:value-of select="number(2000)"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="number($max-results)"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/">
    <sql:execute-query>
      <sql:query>
        select sub1.object_id, catalogcode, groupcode, categorycode, subcategorycode, octl.data
        from ( 
          select distinct octl.object_id, content_type, localisation,
                 masterlastmodified_ts, lastmodified_ts,
                 catalogcode, groupcode, categorycode, subcategorycode
          from octl
          inner join vw_Object_Categorization oc
                  on octl.object_id=oc.object_id
                  and oc.catalogcode = 'MASTER'
          inner join categorization c
                  on oc.subcategory=c.subcategorycode
                  and c.subcategorycode = oc.catalogcode
          <xsl:if test="$catalog != '' and $catalog != '*'">
          inner join catalog_objects co
                  on co.object_id=octl.object_id
                 and co.customer_id=catalogcode
            <xsl:if test="fn:contains($l,'_')">
                 and co.country='<xsl:value-of select="fn:substring-after($l,'_')"/>'
            </xsl:if>
          </xsl:if>
          where
              octl.content_type='<xsl:value-of select="$ct"/>'
          and octl.localisation='<xsl:value-of select="$l"/>'
          <xsl:if test="$sop ne ''">
          and octl.startofprocessing &gt; to_date('<xsl:value-of select="$sop"/>','yyyymmmdd')
          </xsl:if>
          <xsl:if test="$eop ne ''">
          and octl.endofprocessing &lt; to_date('<xsl:value-of select="$eop"/>','yyyymmmdd')
          </xsl:if>
          <xsl:if test="$sop eq '' and $eop eq ''">
          and octl.startofprocessing &lt;= sysdate
          and octl.endofprocessing &gt; sysdate
          </xsl:if>
          <xsl:if test="$catalog != '' and $catalog != '*'">
          and catalogcode='<xsl:value-of select="$catalog"/>'
          </xsl:if>
          <xsl:if test="$group != '' and $group != '*'">
          and groupcode='<xsl:value-of select="$group"/>'
          </xsl:if>
          <xsl:if test="$category != '' and $category != '*'">
          and categorycode='<xsl:value-of select="$category"/>'
          </xsl:if>
          <xsl:if test="$subcategory != '' and $subcategory != '*'">
          and subcategorycode like '<xsl:value-of select="$subcategory"/>'
          </xsl:if>
          order by octl.object_id
        ) sub1
        where rownum &lt;= <xsl:value-of select="$l-max-results"/>
          and NVL(octl.status, 'XXX') != 'PLACEHOLDER'
        order by sub1.object_id
      </sql:query>
    </sql:execute-query>
  </xsl:template>

</xsl:stylesheet>