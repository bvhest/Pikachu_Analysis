<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:import href="../service-base.xsl"/>
  
  <!--
     | Select distinct catalog id from CATALOG_CTL table by stripping the country/locale suffix.
     | This is much faster than doing a distinct on the CUSTOMER_CATALOG table. 
     -->
  <xsl:template match="/root">
    <root>
      <sql:execute-query>
        <sql:query>

select distinct(regexp_replace(cc.catalog_id, '(_[a-z][a-z])?_[A-Z][A-Z]_Catalog$', '')) as catalogcode
from catalog_ctl cc
where regexp_like(cc.catalog_id, '(_[a-z][a-z])?_[A-Z][A-Z]_Catalog$')
order by catalogcode

        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
