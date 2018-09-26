<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<!-- -->
	<xsl:template match="node()|@*">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!-- -->
	<xsl:template match="/">
		<root>
			<xsl:apply-templates select="@*|node()"/>
			<sql:execute-query>
				<sql:query name="PikachuFamilyCount">  
select co.customer_id as catalog
     , o.localisation
     , count(o.object_id) pmt_count
     , (select count(co2.object_id) 
          from catalog_objects co2
         where co2.customer_id = co.customer_id
           and co2.country     = substr(o.localisation,4,2)
           and co2.deleted     = 0
           and sysdate between co2.sop and co2.eop
       ) catalog_count
 from octl o 
inner join catalog_objects co
   on co.object_id   = o.object_id
  and co.country     = substr(o.localisation,4,2)
where o.content_type = 'FMT'
  and o.status       = 'Final Published'
  and o.endofprocessing >= sysdate
  and co.deleted     = 0
  and sysdate between co.sop and co.eop
-- test-condition on localisation:  
--  and o.localisation in ('de_DE', 'nl_NL')
group by co.customer_id, o.localisation
order by co.customer_id, o.localisation		
				</sql:query>
			</sql:execute-query>
		</root>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
