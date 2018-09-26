<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0"
                >
  
  <xsl:import href="../service-base.xsl"/>

  <xsl:param name="catalogID" />
  <xsl:param name="country" />

  <xsl:template match="/root">
    <root>
      <xsl:if test="svc:catalog-allowed($catalogID)">
        <xsl:variable name="oc-cat" select="svc:objectcat-code-for-catalog-code($catalogID)"/>
        <sql:execute-query>
          <sql:query>
select
  c.customer_id, 
  c.country,
  c.division,
  c.object_id,
  c.sop,
  c.eop,
  c.sos,
  c.eos,
  c.buy_online,
  c.lastmodified
from catalog_objects c
inner join vw_object_categorization oc 
   on oc.object_id  = c.object_id
where c.customer_id = '<xsl:value-of select="$catalogID"/>'
  and c.country     = '<xsl:value-of select="$country"/>'
  and c.deleted     = 0
  and oc.catalogcode='<xsl:value-of select="$oc-cat"/>'
order by c.object_id

          </sql:query>
        </sql:execute-query>
      </xsl:if>
    </root>
  </xsl:template>
</xsl:stylesheet>
