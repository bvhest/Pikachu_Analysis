<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0">
  
  <xsl:import href="../service-base.xsl"/>
  
  <xsl:param name="contentType" select="'PMS'"/>
  <xsl:param name="since" select="'2009-07-31T12:00:00'"/>
  <xsl:param name="startAtIndex" select="0"/>
  <xsl:param name="maxNum" select="999"/>
  
  <xsl:template match="/root">
    <root>
      <xsl:variable name="lMaxNum" select="if ($maxNum != '') then $maxNum else 99999"/>
      <xsl:variable name="lStartAtIndex" select="if ($startAtIndex != '') then number($startAtIndex)+1 else 1"/>
      <xsl:variable name="endAtIndex" select="number($lStartAtIndex + $lMaxNum)"/>
      <xsl:variable name="subcats" select="fn:concat($apos,fn:string-join(svc:allowed-subcats-for-profile($uap, 'Read')/SubcategoryCode/text(),fn:concat($apos,',',$apos)),$apos)"/>
      <sql:execute-query>
        <!-- The double sub select makes it possible to get the rownum on the sorted actual data -->
        <sql:query>
          select
            t2.content_type,
            t2.localisation,
            t2.object_id,
            to_char(t2.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts,
            t2.total,
            o.data
          from (
            select
              t.content_type, 
              t.localisation, 
              t.object_id, 
              t.lastmodified_ts,
              rownum rn,
              count(*) over() total -- This returns the total count in every row
            from (
              select ol.object_id, max(ol.lastmodified_ts) lastmodified_ts, ol.content_type, ol.localisation
              from octl_log ol
              inner join vw_object_categorization oc
                 on oc.object_id = ol.object_id
                and oc.catalogcode = '<xsl:value-of select="svc:objectcat-code-for-catalog-code('')"/>'
                and oc.subcategory in (<xsl:value-of select="$subcats"/>)
              -- Join categorization to get only active subcategories' products
              inner join categorization c12n on c12n.subcategorycode = oc.subcategory
                and c12n.catalogcode = 'CONSUMER'
                and c12n.subcategory_status = 'Active'
              where ol.lastmodified_ts &gt; to_date('<xsl:value-of select="$since"/>','yyyy-mm-dd"T"hh24:mi:ss')
                and ol.content_type = '<xsl:value-of select="$contentType"/>' 
              group by ol.object_id, ol.content_type, ol.localisation
              order by 2 desc, 3, 1
            ) t
          ) t2
          -- join on COTL to get the data
          inner join octl o 
             on o.content_type = t2.content_type
             and o.localisation = t2.localisation
             and o.object_id = t2.object_id
             and o.lastmodified_ts = t2.lastmodified_ts
          where rn &lt; <xsl:value-of select="$endAtIndex"/>
          	and rn >= <xsl:value-of select="$lStartAtIndex"/>
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
