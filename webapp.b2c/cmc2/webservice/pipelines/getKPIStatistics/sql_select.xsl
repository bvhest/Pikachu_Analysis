<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
                >

  <xsl:import href="../em-functions.xsl"/>

  <xsl:template match="/root">
    <root>
      <owners>
        <sql:execute-query>
          <sql:query name="getOwners">
            select distinct p.owner, o.status from vw_pms_products p
            inner join octl o
            on p.owner = o.object_id
            where o.content_type='UAP'
            and o.localisation='none'
          </sql:query>
          <sql:execute-query>
            <sql:query name="cat">
              select count(*) logincount from logging_event where upper(formatted_message) like 'INITIALIZEUSER%<sql:ancestor-value name="owner" level="1"/>%'
            </sql:query>
          </sql:execute-query>
        </sql:execute-query>
      </owners>
      <products>
        <sql:execute-query>
          <sql:query name="getProducts">
            select p.ctn, p.owner, p.marketingclass, p.cr_date, 
            a.rank,  a.date_modified, a.columnid, a.publication_status,
            c.gcs_category_code,
            o.data
    
            from vw_pms_products p
                       
            inner join octl o
            on p.ctn = o.object_id
            and o.content_type = 'PMS_Raw'
            and o.localisation = 'none'
                       
            inner join pms_alerts a
            on p.ctn = a.ctn
            and a.columnid in ('PUR','PCU','PHO','VID','TXT','SUP','PCY')
                        
            left join pms_categories c 
            on p.ctn = c.ctn
                  
            and c.gcs_level = 'SU'
          </sql:query>
        </sql:execute-query>
      </products>         
    </root>
  </xsl:template>
</xsl:stylesheet>
