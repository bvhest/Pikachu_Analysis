<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0">
  
  <xsl:import href="../service-base.xsl"/>
  
  <xsl:param name="startAtIndex" select="'0'"/>
  <xsl:param name="maxNum" select="'9999'"/>
  <xsl:param name="since" select="'2009-07-31T12:00:00'"/>
  
  <xsl:template match="/root">
    <root>
      <xsl:variable name="lMaxNum" select="if ($maxNum != '') then number($maxNum) else 99999"/>
      <xsl:variable name="lStartAtIndex" select="if ($startAtIndex != '') then number($startAtIndex)+1 else 1"/>
      <xsl:variable name="endAtIndex" select="number($lStartAtIndex + $lMaxNum)"/>
      <xsl:variable name="subcats" select="fn:concat($apos,fn:string-join(svc:allowed-subcats-for-profile($uap, 'Read')/SubcategoryCode/text(),fn:concat($apos,',',$apos)),$apos)"/>
      <sql:execute-query>
        <!-- The double sub select makes it possible to get the rownum on the sorted actual data -->
        <sql:query>
          select * from (
            select t.*,
              rownum rn,
              count(*) over() total -- This returns the total count in every row
            from (
              select
                ol.content_type, 
                ol.localisation, 
                ol.object_id, 
                to_char(ol.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts
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
              order by ol.lastmodified_ts desc, ol.content_type, ol.object_id
            ) t
          )
          where rn &lt; <xsl:value-of select="$endAtIndex"/>
          and rn >= <xsl:value-of select="$lStartAtIndex"/>
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
